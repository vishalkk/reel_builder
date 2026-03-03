import AVFoundation
import CoreMedia
import Flutter
import QuartzCore
import UIKit

public class NativeReelRendererPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var progressSink: FlutterEventSink?
  private var progressTimer: Timer?
  private var exportSession: AVAssetExportSession?
  private var pendingResult: FlutterResult?
  private var isRendering = false
  private var wasCancelled = false

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "native_reel_renderer", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "native_reel_renderer/progress", binaryMessenger: registrar.messenger())

    let instance = NativeReelRendererPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "render":
      handleRender(call: call, result: result)
    case "cancelRender":
      handleCancel(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func handleRender(call: FlutterMethodCall, result: @escaping FlutterResult) {
    if isRendering {
      result(FlutterError(code: "busy", message: "A render is already in progress.", details: nil))
      return
    }

    guard
      let args = call.arguments as? [String: Any],
      let templateJson = args["templateJson"] as? String,
      let slotVideoPaths = args["slotVideoPaths"] as? [String: String]
    else {
      result(FlutterError(code: "invalid_args", message: "templateJson and slotVideoPaths are required.", details: nil))
      return
    }

    let themeOverrides = args["themeOverrides"] as? [String: String] ?? [:]

    let template: ParsedTemplate
    do {
      template = try parseTemplate(templateJson: templateJson)
    } catch {
      result(FlutterError(code: "template_parse_error", message: "Template JSON is invalid: \(error.localizedDescription)", details: nil))
      return
    }

    if template.scenes.isEmpty {
      result(FlutterError(code: "template_error", message: "Template has no scenes to render.", details: nil))
      return
    }

    let totalDurationMs = template.scenes.reduce(0) { $0 + max(0, $1.endMs - $1.startMs) }
    if totalDurationMs > 30_000 {
      result(FlutterError(code: "duration_limit", message: "Template duration exceeds 30 seconds.", details: nil))
      return
    }

    if let guardrailError = validateInputs(template: template, slotVideoPaths: slotVideoPaths) {
      result(FlutterError(code: "input_validation", message: guardrailError, details: nil))
      return
    }

    let outputPath = (FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?
      .appendingPathComponent("native_reel_\(Int(Date().timeIntervalSince1970 * 1000)).mp4").path)
      ?? NSTemporaryDirectory().appending("native_reel_\(Int(Date().timeIntervalSince1970 * 1000)).mp4")

    do {
      let pipeline = try buildRenderPipeline(
        template: template,
        slotVideoPaths: slotVideoPaths,
        themeOverrides: themeOverrides
      )

      let composition = pipeline.composition
      let videoComposition = pipeline.videoComposition

      guard let session = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
        result(FlutterError(code: "export_error", message: "Could not create export session.", details: nil))
        return
      }

      guard session.supportedFileTypes.contains(.mp4) else {
        result(FlutterError(code: "export_error", message: "MP4 export is not supported on this device.", details: nil))
        return
      }

      let outputURL = URL(fileURLWithPath: outputPath)
      if FileManager.default.fileExists(atPath: outputURL.path) {
        try? FileManager.default.removeItem(at: outputURL)
      }

      session.outputURL = outputURL
      session.outputFileType = .mp4
      session.videoComposition = videoComposition
      session.shouldOptimizeForNetworkUse = true

      exportSession = session
      pendingResult = result
      isRendering = true
      wasCancelled = false

      startProgressTimer()
      progressSink?(0.0)

      session.exportAsynchronously { [weak self] in
        DispatchQueue.main.async {
          self?.handleExportCompletion(outputPath: outputPath)
        }
      }
    } catch {
      result(FlutterError(code: "composition_error", message: error.localizedDescription, details: nil))
    }
  }

  private func handleCancel(result: @escaping FlutterResult) {
    if isRendering {
      wasCancelled = true
      exportSession?.cancelExport()
      stopProgressTimer()
      progressSink?(0.0)
    }
    result(nil)
  }

  private func handleExportCompletion(outputPath: String) {
    stopProgressTimer()

    guard let session = exportSession else {
      pendingResult?(FlutterError(code: "export_error", message: "Export session was released unexpectedly.", details: nil))
      clearRenderState()
      return
    }

    switch session.status {
    case .completed:
      progressSink?(1.0)
      pendingResult?(outputPath)
    case .cancelled:
      pendingResult?(FlutterError(code: "render_cancelled", message: "Render cancelled.", details: nil))
    case .failed:
      let message = session.error?.localizedDescription ?? "Unknown export failure"
      pendingResult?(FlutterError(code: "render_failed", message: "Render failed: \(message)", details: nil))
    default:
      let message = session.error?.localizedDescription ?? "Export did not finish successfully."
      pendingResult?(FlutterError(code: "render_failed", message: message, details: nil))
    }

    clearRenderState()
  }

  private func clearRenderState() {
    exportSession = nil
    pendingResult = nil
    isRendering = false
    wasCancelled = false
  }

  private func startProgressTimer() {
    stopProgressTimer()

    progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      guard
        let self,
        let session = self.exportSession,
        self.isRendering
      else {
        return
      }

      let progress = Double(session.progress)
      self.progressSink?(progress)
    }
  }

  private func stopProgressTimer() {
    progressTimer?.invalidate()
    progressTimer = nil
  }

  private func parseTemplate(templateJson: String) throws -> ParsedTemplate {
    guard let data = templateJson.data(using: .utf8) else {
      throw NSError(domain: "renderer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Template is not valid UTF-8"])
    }

    guard let root = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
      throw NSError(domain: "renderer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Template root must be an object"])
    }

    let scenesRaw = (root["scenes"] as? [[String: Any]])
      ?? ((root["template"] as? [String: Any])?["scenes"] as? [[String: Any]])
      ?? []

    let theme = root["theme"] as? [String: Any]
    let primaryColor = (theme?["primaryColor"] as? String) ?? "#D4AF37"
    let backgroundColor = (theme?["backgroundColor"] as? String)

    let scenes = try scenesRaw.enumerated().map { idx, scene in
      let slotId = ((scene["slotId"] as? String) ?? (scene["slot_id"] as? String) ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
      if slotId.isEmpty {
        throw NSError(domain: "renderer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Scene \(idx + 1) is missing slotId"])
      }

      let startMs = (scene["startMs"] as? Int64) ?? (scene["start"] as? Int64) ?? 0
      let endMs = (scene["endMs"] as? Int64) ?? (scene["end"] as? Int64) ?? 0
      if endMs <= startMs {
        throw NSError(domain: "renderer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Scene \(idx + 1) has invalid trim range"])
      }

      let transition = ((scene["transition"] as? String) ?? "none").lowercased()
      if transition != "none" && transition != "fade" {
        throw NSError(domain: "renderer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unsupported transition '\(transition)'. Use none or fade."])
      }

      let textObj = scene["text"] as? [String: Any]
      let headline = (textObj?["headline"] as? String) ?? (scene["headline"] as? String)
      let textPosition = ((textObj?["position"] as? String) ?? (scene["textPosition"] as? String) ?? "center").lowercased()

      return SceneSpec(
        slotId: slotId,
        startMs: startMs,
        endMs: endMs,
        transition: transition,
        headline: headline,
        textPosition: textPosition
      )
    }

    return ParsedTemplate(
      scenes: scenes,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor
    )
  }

  private func validateInputs(template: ParsedTemplate, slotVideoPaths: [String: String]) -> String? {
    let uniqueSlots = Array(Set(template.scenes.map { $0.slotId }))

    for slotId in uniqueSlots {
      guard let path = slotVideoPaths[slotId], FileManager.default.fileExists(atPath: path) else {
        return "Video file for slot '\(slotId)' was not found."
      }

      let url = URL(fileURLWithPath: path)
      let asset = AVURLAsset(url: url)
      guard let track = asset.tracks(withMediaType: .video).first else {
        return "Video for slot '\(slotId)' has no video track."
      }

      let size = orientedVideoSize(for: track)
      let larger = max(size.width, size.height)
      let smaller = min(size.width, size.height)
      if larger > 1920.0 || smaller > 1080.0 {
        return "Input video for slot '\(slotId)' is above 1080p. Please use 1080p or lower."
      }
    }

    return nil
  }

  private func buildRenderPipeline(
    template: ParsedTemplate,
    slotVideoPaths: [String: String],
    themeOverrides: [String: String]
  ) throws -> RenderPipeline {
    let composition = AVMutableComposition()

    guard
      let videoTrackA = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
      let videoTrackB = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
    else {
      throw NSError(domain: "renderer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to create composition tracks"])
    }

    let audioTrackA = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
    let audioTrackB = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)

    let fadeDuration = CMTime(seconds: 0.35, preferredTimescale: 600)

    var clipRecords: [ClipRecord] = []
    var timelineCursor = CMTime.zero

    for (index, scene) in template.scenes.enumerated() {
      guard let path = slotVideoPaths[scene.slotId] else {
        throw NSError(domain: "renderer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing video for slot '\(scene.slotId)'"])
      }

      let sourceURL = URL(fileURLWithPath: path)
      let asset = AVURLAsset(url: sourceURL)

      guard let sourceVideoTrack = asset.tracks(withMediaType: .video).first else {
        throw NSError(domain: "renderer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Video for slot '\(scene.slotId)' has no video track"])
      }

      let sourceAudioTrack = asset.tracks(withMediaType: .audio).first

      let start = CMTime(value: scene.startMs, timescale: 1000)
      let end = CMTime(value: scene.endMs, timescale: 1000)
      let duration = CMTimeSubtract(end, start)

      if CMTimeCompare(duration, .zero) <= 0 {
        throw NSError(domain: "renderer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Scene for slot '\(scene.slotId)' has invalid duration"])
      }

      if CMTimeCompare(CMTimeAdd(start, duration), asset.duration) == 1 {
        throw NSError(domain: "renderer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Trim range for slot '\(scene.slotId)' exceeds source video length"])
      }

      let useTrackA = index % 2 == 0
      let targetVideoTrack = useTrackA ? videoTrackA : videoTrackB
      let targetAudioTrack = useTrackA ? audioTrackA : audioTrackB

      let hasFadeFromPrev = index > 0 && scene.transition == "fade"
      var insertionTime = timelineCursor
      if hasFadeFromPrev {
        insertionTime = CMTimeSubtract(timelineCursor, fadeDuration)
        if CMTimeCompare(insertionTime, .zero) < 0 {
          insertionTime = .zero
        }
      }

      try targetVideoTrack.insertTimeRange(CMTimeRange(start: start, duration: duration), of: sourceVideoTrack, at: insertionTime)
      if let sourceAudioTrack, let targetAudioTrack {
        try? targetAudioTrack.insertTimeRange(CMTimeRange(start: start, duration: duration), of: sourceAudioTrack, at: insertionTime)
      }

      let clipStart = insertionTime
      let clipEnd = CMTimeAdd(insertionTime, duration)
      timelineCursor = clipEnd

      clipRecords.append(
        ClipRecord(
          trackID: targetVideoTrack.trackID,
          startTime: clipStart,
          endTime: clipEnd,
          sourceTrack: sourceVideoTrack,
          headline: scene.headline,
          textPosition: scene.textPosition,
          incomingFade: hasFadeFromPrev
        )
      )
    }

    let outputSize = CGSize(width: 1080, height: 1920)
    let videoComposition = AVMutableVideoComposition()
    videoComposition.renderSize = outputSize
    videoComposition.frameDuration = CMTime(value: 1, timescale: 30)

    let layerInstructionA = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrackA)
    let layerInstructionB = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrackB)

    layerInstructionA.setOpacity(0.0, at: .zero)
    layerInstructionB.setOpacity(0.0, at: .zero)

    for (i, record) in clipRecords.enumerated() {
      let layer = (record.trackID == videoTrackA.trackID) ? layerInstructionA : layerInstructionB
      let transform = transformForPortrait(track: record.sourceTrack, outputSize: outputSize)
      layer.setTransform(transform, at: record.startTime)

      if record.incomingFade {
        let fadeStart = record.startTime
        let fadeEnd = CMTimeAdd(record.startTime, fadeDuration)
        layer.setOpacityRamp(fromStartOpacity: 0.0, toEndOpacity: 1.0, timeRange: CMTimeRange(start: fadeStart, end: fadeEnd))
      } else {
        layer.setOpacity(1.0, at: record.startTime)
      }

      let next = (i + 1 < clipRecords.count) ? clipRecords[i + 1] : nil
      if let next, next.incomingFade {
        let fadeStart = next.startTime
        let fadeEnd = CMTimeAdd(next.startTime, fadeDuration)
        layer.setOpacityRamp(fromStartOpacity: 1.0, toEndOpacity: 0.0, timeRange: CMTimeRange(start: fadeStart, end: fadeEnd))
      } else {
        layer.setOpacity(0.0, at: record.endTime)
      }
    }

    let instruction = AVMutableVideoCompositionInstruction()
    instruction.timeRange = CMTimeRange(start: .zero, end: timelineCursor)
    instruction.layerInstructions = [layerInstructionA, layerInstructionB]
    videoComposition.instructions = [instruction]

    let parentLayer = CALayer()
    parentLayer.frame = CGRect(origin: .zero, size: outputSize)

    let backgroundLayer = CALayer()
    backgroundLayer.frame = parentLayer.frame
    let bgColorHex = themeOverrides["background"] ?? template.backgroundColor
    backgroundLayer.backgroundColor = colorFromHex(bgColorHex ?? "#000000").cgColor
    parentLayer.addSublayer(backgroundLayer)

    let videoLayer = CALayer()
    videoLayer.frame = parentLayer.frame
    parentLayer.addSublayer(videoLayer)

    let textColor = colorFromHex(themeOverrides["primary"] ?? template.primaryColor)
    addTextOverlays(
      parentLayer: parentLayer,
      records: clipRecords,
      timelineDuration: timelineCursor,
      textColor: textColor,
      outputSize: outputSize
    )

    videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(
      postProcessingAsVideoLayer: videoLayer,
      in: parentLayer
    )

    return RenderPipeline(
      composition: composition,
      videoComposition: videoComposition
    )
  }

  private func addTextOverlays(
    parentLayer: CALayer,
    records: [ClipRecord],
    timelineDuration: CMTime,
    textColor: UIColor,
    outputSize: CGSize
  ) {
    let totalSeconds = max(CMTimeGetSeconds(timelineDuration), 0.001)

    for record in records {
      guard let headline = record.headline?.trimmingCharacters(in: .whitespacesAndNewlines), !headline.isEmpty else {
        continue
      }

      let layer = CATextLayer()
      layer.string = headline
      layer.alignmentMode = .center
      layer.foregroundColor = textColor.cgColor
      layer.contentsScale = UIScreen.main.scale
      layer.fontSize = 42
      layer.font = UIFont.boldSystemFont(ofSize: 42)
      layer.opacity = 0.0

      let horizontalInset: CGFloat = 80
      let height: CGFloat = 120
      let y: CGFloat
      switch record.textPosition.lowercased() {
      case "top":
        y = 180
      case "bottom":
        y = outputSize.height - 260
      default:
        y = (outputSize.height - height) / 2
      }
      layer.frame = CGRect(x: horizontalInset, y: y, width: outputSize.width - (horizontalInset * 2), height: height)

      let start = max(CMTimeGetSeconds(record.startTime), 0)
      let end = max(CMTimeGetSeconds(record.endTime), start)
      let epsilon = 0.001

      let anim = CAKeyframeAnimation(keyPath: "opacity")
      anim.values = [0.0, 0.0, 1.0, 1.0, 0.0, 0.0]
      anim.keyTimes = [
        0.0,
        NSNumber(value: max((start - epsilon) / totalSeconds, 0.0)),
        NSNumber(value: min(start / totalSeconds, 1.0)),
        NSNumber(value: min(end / totalSeconds, 1.0)),
        NSNumber(value: min((end + epsilon) / totalSeconds, 1.0)),
        1.0,
      ]
      anim.duration = totalSeconds
      anim.isRemovedOnCompletion = false
      anim.fillMode = .forwards

      layer.add(anim, forKey: "visibility_\(record.trackID)_\(start)")
      parentLayer.addSublayer(layer)
    }
  }

  private func transformForPortrait(track: AVAssetTrack, outputSize: CGSize) -> CGAffineTransform {
    let preferred = track.preferredTransform
    let naturalRect = CGRect(origin: .zero, size: track.naturalSize).applying(preferred)
    let sourceSize = CGSize(width: abs(naturalRect.width), height: abs(naturalRect.height))

    let scale = min(outputSize.width / max(sourceSize.width, 1), outputSize.height / max(sourceSize.height, 1))
    let scaledSize = CGSize(width: sourceSize.width * scale, height: sourceSize.height * scale)

    let xOffset = (outputSize.width - scaledSize.width) / 2
    let yOffset = (outputSize.height - scaledSize.height) / 2

    return preferred
      .concatenating(CGAffineTransform(scaleX: scale, y: scale))
      .concatenating(CGAffineTransform(translationX: xOffset, y: yOffset))
  }

  private func orientedVideoSize(for track: AVAssetTrack) -> CGSize {
    let rect = CGRect(origin: .zero, size: track.naturalSize).applying(track.preferredTransform)
    return CGSize(width: abs(rect.width), height: abs(rect.height))
  }

  private func colorFromHex(_ hex: String) -> UIColor {
    var raw = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    if raw.hasPrefix("#") {
      raw.removeFirst()
    }

    guard raw.count == 6, let intVal = Int(raw, radix: 16) else {
      return UIColor(red: 212 / 255.0, green: 175 / 255.0, blue: 55 / 255.0, alpha: 1.0)
    }

    let r = CGFloat((intVal >> 16) & 0xFF) / 255.0
    let g = CGFloat((intVal >> 8) & 0xFF) / 255.0
    let b = CGFloat(intVal & 0xFF) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    progressSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    progressSink = nil
    return nil
  }

  private struct SceneSpec {
    let slotId: String
    let startMs: Int64
    let endMs: Int64
    let transition: String
    let headline: String?
    let textPosition: String
  }

  private struct ParsedTemplate {
    let scenes: [SceneSpec]
    let primaryColor: String
    let backgroundColor: String?
  }

  private struct ClipRecord {
    let trackID: CMPersistentTrackID
    let startTime: CMTime
    let endTime: CMTime
    let sourceTrack: AVAssetTrack
    let headline: String?
    let textPosition: String
    let incomingFade: Bool
  }

  private struct RenderPipeline {
    let composition: AVMutableComposition
    let videoComposition: AVMutableVideoComposition
  }
}
