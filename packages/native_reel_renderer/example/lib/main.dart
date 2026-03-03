import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_reel_renderer/native_reel_renderer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NativeReelRenderer _renderer = const NativeReelRenderer();
  Stream<double>? _progressStream;
  String _status = 'Idle';
  String? _outputPath;

  @override
  void initState() {
    super.initState();
    _progressStream = _renderer.renderProgress();
  }

  Future<void> _startSampleRender() async {
    setState(() {
      _status = 'Rendering...';
      _outputPath = null;
    });

    try {
      final result = await _renderer.render(
        templateJson:
            '{"id":"sample","name":"Sample Template","slots":[{"id":"slot_1","name":"Main"}]}',
        slotVideoPaths: const <String, String>{'slot_1': '/tmp/input.mp4'},
        textOverrides: const <String, String>{'headline': 'Sample'},
        themeOverrides: const <String, String>{'primary': '#D4AF37'},
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Render complete';
        _outputPath = result;
      });
    } on PlatformException {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Render failed';
      });
    }
  }

  Future<void> _cancelRender() async {
    await _renderer.cancelRender();
    if (!mounted) {
      return;
    }
    setState(() {
      _status = 'Render cancelled';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Native Reel Renderer Example')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Status: $_status'),
              if (_outputPath != null) Text('Output: $_outputPath'),
              const SizedBox(height: 12),
              if (_progressStream != null)
                StreamBuilder<double>(
                  stream: _progressStream,
                  initialData: 0,
                  builder: (context, snapshot) {
                    final progress = snapshot.data ?? 0;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(value: progress),
                        const SizedBox(height: 8),
                        Text(
                          'Progress: ${(progress * 100).toStringAsFixed(0)}%',
                        ),
                      ],
                    );
                  },
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _startSampleRender,
                child: const Text('Start Sample Render'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _cancelRender,
                child: const Text('Cancel Render'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
