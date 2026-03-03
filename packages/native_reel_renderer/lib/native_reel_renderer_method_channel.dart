import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_reel_renderer_platform_interface.dart';

class MethodChannelNativeReelRenderer extends NativeReelRendererPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('native_reel_renderer');

  @visibleForTesting
  final eventChannel = const EventChannel('native_reel_renderer/progress');

  @override
  Future<String> render({
    required String templateJson,
    required Map<String, String> slotVideoPaths,
    required Map<String, String> textOverrides,
    required Map<String, String> themeOverrides,
  }) async {
    final result = await methodChannel.invokeMethod<String>('render', {
      'templateJson': templateJson,
      'slotVideoPaths': slotVideoPaths,
      'textOverrides': textOverrides,
      'themeOverrides': themeOverrides,
    });

    if (result == null || result.isEmpty) {
      throw PlatformException(
        code: 'empty_result',
        message: 'Native render returned an empty output path.',
      );
    }

    return result;
  }

  @override
  Stream<double> renderProgress() {
    return eventChannel.receiveBroadcastStream().map((dynamic event) {
      if (event is num) {
        return event.toDouble();
      }
      return 0.0;
    });
  }

  @override
  Future<void> cancelRender() async {
    await methodChannel.invokeMethod<void>('cancelRender');
  }
}
