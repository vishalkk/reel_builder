// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:native_reel_renderer/native_reel_renderer.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('plugin exposes render API', (WidgetTester tester) async {
    const NativeReelRenderer plugin = NativeReelRenderer();

    expect(plugin.renderProgress(), isA<Stream<double>>());
  });
}
