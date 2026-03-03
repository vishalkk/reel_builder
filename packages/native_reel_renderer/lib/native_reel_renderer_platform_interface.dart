import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_reel_renderer_method_channel.dart';

abstract class NativeReelRendererPlatform extends PlatformInterface {
  NativeReelRendererPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeReelRendererPlatform _instance =
      MethodChannelNativeReelRenderer();

  static NativeReelRendererPlatform get instance => _instance;

  static set instance(NativeReelRendererPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> render({
    required String templateJson,
    required Map<String, String> slotVideoPaths,
    required Map<String, String> textOverrides,
    required Map<String, String> themeOverrides,
  }) {
    throw UnimplementedError('render() has not been implemented.');
  }

  Stream<double> renderProgress() {
    throw UnimplementedError('renderProgress() has not been implemented.');
  }

  Future<void> cancelRender() {
    throw UnimplementedError('cancelRender() has not been implemented.');
  }
}
