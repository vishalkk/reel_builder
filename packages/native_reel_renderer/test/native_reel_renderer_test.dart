import 'package:flutter_test/flutter_test.dart';
import 'package:native_reel_renderer/native_reel_renderer.dart';
import 'package:native_reel_renderer/native_reel_renderer_method_channel.dart';
import 'package:native_reel_renderer/native_reel_renderer_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativeReelRendererPlatform
    with MockPlatformInterfaceMixin
    implements NativeReelRendererPlatform {
  @override
  Future<void> cancelRender() async {}

  @override
  Stream<double> renderProgress() => const Stream<double>.empty();

  @override
  Future<String> render({
    required String templateJson,
    required Map<String, String> slotVideoPaths,
    required Map<String, String> textOverrides,
    required Map<String, String> themeOverrides,
  }) async {
    return '/mock/rendered.mp4';
  }
}

void main() {
  final initialPlatform = NativeReelRendererPlatform.instance;

  test('$MethodChannelNativeReelRenderer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativeReelRenderer>());
  });

  test('render returns mocked path from platform', () async {
    final plugin = NativeReelRenderer();
    final fakePlatform = MockNativeReelRendererPlatform();
    NativeReelRendererPlatform.instance = fakePlatform;

    final output = await plugin.render(
      templateJson: '{}',
      slotVideoPaths: const {'slot1': '/tmp/a.mp4'},
      textOverrides: const {'title': 'Hello'},
      themeOverrides: const {'primary': '#D4AF37'},
    );

    expect(output, '/mock/rendered.mp4');
  });
}
