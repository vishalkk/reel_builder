# native_reel_renderer

Flutter plugin for native video reel rendering on Android and iOS.

## Features

- Start a native render job with template + user overrides.
- Receive render progress as a `Stream<double>` (`0.0` to `1.0`).
- Cancel an in-flight render.

## Installation

Add the plugin to your app:

```yaml
dependencies:
  native_reel_renderer:
    path: ../native_reel_renderer
```

Then run:

```bash
flutter pub get
```

## API

```dart
const renderer = NativeReelRenderer();
```

- `render(...)` -> `Future<String>`
  - Returns the rendered output file path.
- `renderProgress()` -> `Stream<double>`
  - Emits progress updates while render is running.
- `cancelRender()` -> `Future<void>`
  - Requests cancellation on native side.

## Usage Example

```dart
import 'package:flutter/services.dart';
import 'package:native_reel_renderer/native_reel_renderer.dart';

const renderer = NativeReelRenderer();

Future<String?> generateReel() async {
  try {
    final outputPath = await renderer.render(
      templateJson: '''
      {
        "id": "tpl_001",
        "name": "Promo Reel",
        "slots": [{"id": "slot_1", "name": "Main Clip"}]
      }
      ''',
      slotVideoPaths: {
        "slot_1": "/storage/emulated/0/Movies/input.mp4",
      },
      textOverrides: {
        "headline": "New Launch",
      },
      themeOverrides: {
        "primary": "#D4AF37",
        "secondary": "#111111",
        "background": "#000000",
      },
    );
    return outputPath;
  } on PlatformException catch (e) {
    // Handle native render failure.
    debugPrint('Render failed: ${e.code} ${e.message}');
    return null;
  }
}

void listenToProgress() {
  renderer.renderProgress().listen((progress) {
    debugPrint('Progress: ${(progress * 100).toStringAsFixed(0)}%');
  });
}

Future<void> cancelReelRender() async {
  await renderer.cancelRender();
}
```

## Notes

- Ensure every required slot in your template has a valid local file path.
- `render(...)` throws `PlatformException` on native errors.
- Integration tests for this plugin require a connected Android/iOS device or emulator/simulator.
- See the runnable sample app in `example/`.
