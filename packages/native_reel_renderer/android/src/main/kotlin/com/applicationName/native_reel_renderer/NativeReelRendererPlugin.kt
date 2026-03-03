package com.applicationName.native_reel_renderer

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import android.media.MediaMetadataRetriever
import android.os.Handler
import android.os.Looper
import androidx.media3.common.Effect
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.common.util.UnstableApi
import androidx.media3.effect.BitmapOverlay
import androidx.media3.effect.OverlayEffect
import androidx.media3.effect.Presentation
import androidx.media3.transformer.Composition
import androidx.media3.transformer.EditedMediaItem
import androidx.media3.transformer.EditedMediaItemSequence
import androidx.media3.transformer.Effects
import androidx.media3.transformer.ExportException
import androidx.media3.transformer.ExportResult
import androidx.media3.transformer.TransformationRequest
import androidx.media3.transformer.Transformer
import com.google.common.collect.ImmutableList
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import kotlin.math.max
import kotlin.math.min

@UnstableApi
class NativeReelRendererPlugin :
    FlutterPlugin,
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler {

    private lateinit var appContext: Context
    private lateinit var methodChannel: MethodChannel
    private lateinit var progressChannel: EventChannel

    private val mainHandler = Handler(Looper.getMainLooper())
    private var progressSink: EventChannel.EventSink? = null

    private var currentTransformer: Transformer? = null
    private var pendingResult: MethodChannel.Result? = null
    private var progressRunnable: Runnable? = null
    private var isRendering: Boolean = false
    private var wasCancelled: Boolean = false
    private var progressValue = 0.0

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext

        methodChannel = MethodChannel(binding.binaryMessenger, "native_reel_renderer")
        methodChannel.setMethodCallHandler(this)

        progressChannel = EventChannel(binding.binaryMessenger, "native_reel_renderer/progress")
        progressChannel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "render" -> handleRender(call, result)
            "cancelRender" -> handleCancel(result)
            else -> result.notImplemented()
        }
    }

    private fun handleRender(call: MethodCall, result: MethodChannel.Result) {
        if (isRendering) {
            result.error("busy", "A render is already in progress.", null)
            return
        }

        val args = call.arguments as? Map<*, *>
        if (args == null) {
            result.error("invalid_args", "Render arguments are missing.", null)
            return
        }

        val templateJson = args["templateJson"] as? String
        val slotPathsRaw = args["slotVideoPaths"] as? Map<*, *>
        if (templateJson.isNullOrBlank() || slotPathsRaw == null) {
            result.error("invalid_args", "templateJson and slotVideoPaths are required.", null)
            return
        }

        val slotPaths = slotPathsRaw.entries
            .mapNotNull { (k, v) ->
                val key = k as? String
                val value = v as? String
                if (key == null || value == null) null else key to value
            }
            .toMap()
        val themeOverrides = (args["themeOverrides"] as? Map<*, *>)?.entries
            ?.mapNotNull { (k, v) ->
                val key = k as? String
                val value = v as? String
                if (key == null || value == null) null else key to value
            }
            ?.toMap()
            ?: emptyMap()

        val parsed = try {
            parseTemplate(templateJson)
        } catch (e: Exception) {
            result.error("template_parse_error", "Template JSON is invalid: ${e.message}", null)
            return
        }

        if (parsed.scenes.isEmpty()) {
            result.error("template_error", "Template has no scenes to render.", null)
            return
        }

        val durationMs = parsed.scenes.sumOf { max(0L, it.endMs - it.startMs) }
        if (durationMs > 30_000L) {
            result.error("duration_limit", "Template duration exceeds 30 seconds.", null)
            return
        }

        val guardrailError = validateInputVideos(parsed, slotPaths)
        if (guardrailError != null) {
            result.error("input_validation", guardrailError, null)
            return
        }

        val composition = try {
            buildComposition(parsed, slotPaths, themeOverrides)
        } catch (e: Exception) {
            result.error("composition_error", e.message ?: "Could not build render composition.", null)
            return
        }

        val outputFile = File(appContext.cacheDir, "native_reel_${System.currentTimeMillis()}.mp4")
        if (outputFile.exists()) {
            outputFile.delete()
        }

        val transformer = Transformer.Builder(appContext)
            .setTransformationRequest(
                TransformationRequest.Builder()
                    .setVideoMimeType(MimeTypes.VIDEO_H264)
                    .build()
            )
            .addListener(object : Transformer.Listener {
                override fun onCompleted(composition: Composition, exportResult: ExportResult) {
                    finishProgress(1.0)
                    pendingResult?.success(outputFile.absolutePath)
                    clearRenderState()
                }

                override fun onError(
                    composition: Composition,
                    exportResult: ExportResult,
                    exportException: ExportException,
                ) {
                    val message = if (wasCancelled) {
                        "Render cancelled."
                    } else {
                        "Render failed: ${exportException.message ?: "Unknown error"}"
                    }
                    pendingResult?.error("render_failed", message, null)
                    clearRenderState()
                }
            })
            .build()

        currentTransformer = transformer
        pendingResult = result
        isRendering = true
        wasCancelled = false

        startProgressTicker(durationMs)
        try {
            transformer.start(composition, outputFile.absolutePath)
        } catch (e: Exception) {
            stopProgressTicker()
            clearRenderState()
            result.error("render_start_failed", "Unable to start render: ${e.message}", null)
        }
    }

    private fun handleCancel(result: MethodChannel.Result) {
        if (isRendering) {
            wasCancelled = true
            currentTransformer?.cancel()
            stopProgressTicker()
            progressSink?.success(0.0)
        }

        result.success(null)
    }

    private fun parseTemplate(templateJson: String): ParsedTemplate {
        val root = JSONObject(templateJson)
        val scenesArray =
            root.optJSONArray("scenes") ?: root.optJSONObject("template")?.optJSONArray("scenes") ?: JSONArray()

        val scenes = mutableListOf<SceneSpec>()
        for (index in 0 until scenesArray.length()) {
            val scene = scenesArray.getJSONObject(index)

            val slotId = scene.optString("slotId", scene.optString("slot_id", "")).trim()
            if (slotId.isEmpty()) {
                throw IllegalArgumentException("Scene ${index + 1} is missing slotId.")
            }

            val startMs = scene.optLong("startMs", scene.optLong("start", 0L)).coerceAtLeast(0L)
            val endMs = scene.optLong("endMs", scene.optLong("end", 0L)).coerceAtLeast(0L)
            if (endMs <= startMs) {
                throw IllegalArgumentException("Scene ${index + 1} has invalid trim range.")
            }

            val transition = scene.optString("transition", "none").lowercase()
            if (transition != "none" && transition != "fade") {
                throw IllegalArgumentException("Unsupported transition '$transition'. Use none or fade.")
            }

            val textObj = scene.optJSONObject("text")
            val headline = textObj?.optString("headline")
                ?: scene.optString("headline", "")
            val position = (textObj?.optString("position")
                ?: scene.optString("textPosition", "center")).lowercase()

            scenes.add(
                SceneSpec(
                    slotId = slotId,
                    startMs = startMs,
                    endMs = endMs,
                    transition = transition,
                    headline = headline,
                    textPosition = position,
                )
            )
        }

        val theme = root.optJSONObject("theme") ?: JSONObject()
        val primaryColor = theme.optString("primaryColor", "#D4AF37")

        return ParsedTemplate(scenes, primaryColor)
    }

    private fun validateInputVideos(parsedTemplate: ParsedTemplate, slotPaths: Map<String, String>): String? {
        val usedSlotIds = parsedTemplate.scenes.map { it.slotId }.distinct()

        for (slotId in usedSlotIds) {
            val path = slotPaths[slotId]
                ?: return "Missing video for slot '$slotId'."

            val file = File(path)
            if (!file.exists()) {
                return "Video file for slot '$slotId' was not found."
            }

            val metrics = readVideoMetrics(path)
                ?: return "Could not read video metadata for slot '$slotId'."

            val larger = max(metrics.width, metrics.height)
            val smaller = min(metrics.width, metrics.height)
            if (larger > 1920 || smaller > 1080) {
                return "Input video for slot '$slotId' is above 1080p. Please use 1080p or lower."
            }
        }

        return null
    }

    private fun readVideoMetrics(path: String): VideoMetrics? {
        val retriever = MediaMetadataRetriever()
        return try {
            retriever.setDataSource(path)
            val width = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH)?.toIntOrNull()
            val height = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT)?.toIntOrNull()
            val rotation = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION)?.toIntOrNull() ?: 0

            if (width == null || height == null) {
                null
            } else {
                if (rotation == 90 || rotation == 270) {
                    VideoMetrics(width = height, height = width)
                } else {
                    VideoMetrics(width = width, height = height)
                }
            }
        } catch (_: Exception) {
            null
        } finally {
            retriever.release()
        }
    }

    private fun buildComposition(
        parsedTemplate: ParsedTemplate,
        slotPaths: Map<String, String>,
        themeOverrides: Map<String, String>,
    ): Composition {
        val editedItems = parsedTemplate.scenes.map { scene ->
            val path = slotPaths[scene.slotId]
                ?: throw IllegalArgumentException("Missing input for slot '${scene.slotId}'.")

            val clipping = MediaItem.ClippingConfiguration.Builder()
                .setStartPositionMs(scene.startMs)
                .setEndPositionMs(scene.endMs)
                .build()

            val mediaItem = MediaItem.Builder()
                .setUri(path)
                .setClippingConfiguration(clipping)
                .build()

            val effects = mutableListOf<Effect>()

            // Force portrait output target at 1080x1920.
            effects.add(Presentation.createForWidthAndHeight(1080, 1920, Presentation.LAYOUT_SCALE_TO_FIT))

            // Fade is accepted and handled as a simple visual easing marker for now.
            if (scene.transition == "fade") {
                // A no-op placeholder for fade support to keep transition contract explicit.
            }

            if (!scene.headline.isNullOrBlank()) {
                val primaryColor = themeOverrides["primary"] ?: parsedTemplate.primaryColor
                val overlayBitmap = createHeadlineOverlay(
                    text = scene.headline,
                    position = scene.textPosition,
                    hexColor = primaryColor,
                )
                val bitmapOverlay = BitmapOverlay.createStaticBitmapOverlay(overlayBitmap)
                effects.add(OverlayEffect(ImmutableList.of(bitmapOverlay)))
            }

            val editedMedia = EditedMediaItem.Builder(mediaItem)
                .setEffects(Effects(emptyList(), effects))
                .build()

            editedMedia
        }

        val sequence = EditedMediaItemSequence(editedItems)
        return Composition.Builder(sequence).build()
    }

    private fun createHeadlineOverlay(text: String, position: String, hexColor: String): Bitmap {
        val width = 1080
        val height = 1920
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)

        val color = try {
            Color.parseColor(hexColor)
        } catch (_: Exception) {
            Color.parseColor("#D4AF37")
        }

        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = color
            textAlign = Paint.Align.CENTER
            textSize = 72f
            style = Paint.Style.FILL
            setShadowLayer(8f, 0f, 0f, Color.BLACK)
        }

        val textBounds = Rect()
        paint.getTextBounds(text, 0, text.length, textBounds)

        val y = when (position.lowercase()) {
            "top" -> 240f
            "bottom" -> (height - 180).toFloat()
            else -> (height / 2).toFloat()
        }

        canvas.drawText(text, width / 2f, y, paint)
        return bitmap
    }

    private fun startProgressTicker(estimatedDurationMs: Long) {
        stopProgressTicker()
        progressValue = 0.0
        progressSink?.success(progressValue)

        val safeDuration = estimatedDurationMs.coerceAtLeast(1_000L)
        val tickMs = 200L
        val targetCeiling = 0.95

        progressRunnable = object : Runnable {
            override fun run() {
                if (!isRendering) {
                    return
                }

                val increment = (tickMs.toDouble() / safeDuration.toDouble()) * targetCeiling
                progressValue = (progressValue + increment).coerceAtMost(targetCeiling)
                progressSink?.success(progressValue)
                mainHandler.postDelayed(this, tickMs)
            }
        }

        mainHandler.post(progressRunnable!!)
    }

    private fun finishProgress(value: Double) {
        progressValue = value.coerceIn(0.0, 1.0)
        progressSink?.success(progressValue)
        stopProgressTicker()
    }

    private fun stopProgressTicker() {
        progressRunnable?.let { mainHandler.removeCallbacks(it) }
        progressRunnable = null
    }

    private fun clearRenderState() {
        stopProgressTicker()
        currentTransformer = null
        pendingResult = null
        isRendering = false
        wasCancelled = false
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        progressSink = events
    }

    override fun onCancel(arguments: Any?) {
        progressSink = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        currentTransformer?.cancel()
        clearRenderState()
        methodChannel.setMethodCallHandler(null)
        progressChannel.setStreamHandler(null)
    }

    data class SceneSpec(
        val slotId: String,
        val startMs: Long,
        val endMs: Long,
        val transition: String,
        val headline: String?,
        val textPosition: String,
    )

    data class ParsedTemplate(
        val scenes: List<SceneSpec>,
        val primaryColor: String,
    )

    data class VideoMetrics(
        val width: Int,
        val height: Int,
    )
}
