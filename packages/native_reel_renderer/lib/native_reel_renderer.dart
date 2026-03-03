import 'native_reel_renderer_platform_interface.dart';

class NativeReelRenderer {
  const NativeReelRenderer();

  Future<String> render({
    required String templateJson,
    required Map<String, String> slotVideoPaths,
    required Map<String, String> textOverrides,
    required Map<String, String> themeOverrides,
  }) {
    return NativeReelRendererPlatform.instance.render(
      templateJson: templateJson,
      slotVideoPaths: slotVideoPaths,
      textOverrides: textOverrides,
      themeOverrides: themeOverrides,
    );
  }

  Stream<double> renderProgress() {
    return NativeReelRendererPlatform.instance.renderProgress();
  }

  Future<void> cancelRender() {
    return NativeReelRendererPlatform.instance.cancelRender();
  }
}
