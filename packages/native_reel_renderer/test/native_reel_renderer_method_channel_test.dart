import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_reel_renderer/native_reel_renderer_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelNativeReelRenderer();
  const channel = MethodChannel('native_reel_renderer');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async {
          if (methodCall.method == 'render') {
            return '/mock/path/output.mp4';
          }
          if (methodCall.method == 'cancelRender') {
            return null;
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('render returns output path', () async {
    final path = await platform.render(
      templateJson: '{}',
      slotVideoPaths: const {'slot1': '/tmp/a.mp4'},
      textOverrides: const {'title': 'Hello'},
      themeOverrides: const {'primary': '#D4AF37'},
    );
    expect(path, '/mock/path/output.mp4');
  });

  test('cancelRender completes', () async {
    await platform.cancelRender();
  });
}
