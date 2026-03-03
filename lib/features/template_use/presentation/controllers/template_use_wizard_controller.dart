import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_detail_dto.dart';
import 'package:native_reel_renderer/native_reel_renderer.dart';

enum TemplateUseWizardStep { media, text, theme, export }

class TemplateUseWizardController extends ChangeNotifier {
  final ImagePicker _picker;
  final TemplateDetailDto template;
  final NativeReelRenderer _renderer;
  StreamSubscription<double>? _progressSubscription;

  TemplateUseWizardController({
    required this.template,
    ImagePicker? picker,
    NativeReelRenderer? renderer,
  })  : _picker = picker ?? ImagePicker(),
        _renderer = renderer ?? const NativeReelRenderer() {
    for (final field in template.editableFields?.textFields ??
        const <TemplateTextFieldDto>[]) {
      textOverrides[field.id] = field.defaultValue ?? '';
    }
    themeOverrides.addAll(_presetValues['Dark Luxury']!);
  }

  TemplateUseWizardStep currentStep = TemplateUseWizardStep.media;

  final Map<String, String> selectedVideos = <String, String>{};
  final Map<String, String> textOverrides = <String, String>{};
  final Map<String, String> themeOverrides = <String, String>{};

  String? validationError;
  String? renderError;
  String? lastRenderOutputPath;
  double renderProgress = 0.0;
  bool isRendering = false;

  static const Map<String, Map<String, String>> _presetValues = {
    'Royal Gold': {
      'primary': '#D4AF37',
      'secondary': '#C6A75E',
      'background': '#0B0B0B',
    },
    'Matte Black': {
      'primary': '#2E2E2E',
      'secondary': '#5A5A5A',
      'background': '#0B0B0B',
    },
    'Champagne': {
      'primary': '#E7C98E',
      'secondary': '#D2B48C',
      'background': '#1A1A1A',
    },
    'Dark Luxury': {
      'primary': '#B08D57',
      'secondary': '#8C7853',
      'background': '#121212',
    },
  };

  List<TemplateUseWizardStep> get steps => TemplateUseWizardStep.values;

  Future<void> pickVideoForSlot(String slotId) async {
    final XFile? file = await _picker.pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(minutes: 2));
    if (file == null) {
      return;
    }

    selectedVideos[slotId] = file.path;
    validationError = null;
    notifyListeners();
  }

  void updateText(String textId, String value, {int? maxChars}) {
    final normalized =
        maxChars != null && maxChars > 0 && value.length > maxChars
            ? value.substring(0, maxChars)
            : value;
    textOverrides[textId] = normalized;
    validationError = null;
    notifyListeners();
  }

  void updateThemeColor(String key, String hexValue) {
    themeOverrides[key] = _normalizeHex(hexValue);
    validationError = null;
    notifyListeners();
  }

  void applyPreset(String preset) {
    final values = _presetValues[preset];
    if (values == null) {
      return;
    }

    themeOverrides.addAll(values);
    validationError = null;
    notifyListeners();
  }

  String? currentValidationMessage() {
    switch (currentStep) {
      case TemplateUseWizardStep.media:
        final slots = template.slots;
        if (slots.isEmpty) {
          return null;
        }
        final missing =
            slots.where((slot) => !selectedVideos.containsKey(slot.id));
        if (missing.isNotEmpty) {
          return 'Add videos to all media slots to continue.';
        }
        return null;
      case TemplateUseWizardStep.text:
        final fields = template.editableFields?.textFields ??
            const <TemplateTextFieldDto>[];
        for (final field in fields) {
          final value = (textOverrides[field.id] ?? '').trim();
          if (value.isEmpty) {
            return 'Fill all text fields to continue.';
          }
          if (field.maxChars != null && value.length > field.maxChars!) {
            return '${field.label} exceeds ${field.maxChars} characters.';
          }
        }
        return null;
      case TemplateUseWizardStep.theme:
        const requiredKeys = ['primary', 'secondary', 'background'];
        for (final key in requiredKeys) {
          final value = themeOverrides[key] ?? '';
          if (!_isHex(value)) {
            return 'Set valid hex colors for primary, secondary, and background.';
          }
        }
        return null;
      case TemplateUseWizardStep.export:
        return null;
    }
  }

  bool nextStep() {
    final message = currentValidationMessage();
    if (message != null) {
      validationError = message;
      notifyListeners();
      return false;
    }

    final index = steps.indexOf(currentStep);
    if (index < steps.length - 1) {
      currentStep = steps[index + 1];
      validationError = null;
      notifyListeners();
    }
    return true;
  }

  void previousStep() {
    final index = steps.indexOf(currentStep);
    if (index > 0) {
      currentStep = steps[index - 1];
      validationError = null;
      notifyListeners();
    }
  }

  void goToStep(TemplateUseWizardStep step) {
    currentStep = step;
    validationError = null;
    notifyListeners();
  }

  Future<String?> startRender() async {
    if (isRendering) {
      return null;
    }

    final validation = _validateBeforeRender();
    if (validation != null) {
      validationError = validation;
      notifyListeners();
      return null;
    }

    isRendering = true;
    renderError = null;
    renderProgress = 0.0;
    lastRenderOutputPath = null;
    notifyListeners();

    await _progressSubscription?.cancel();
    _progressSubscription = _renderer.renderProgress().listen(
      (progress) {
        renderProgress = progress.clamp(0.0, 1.0);
        notifyListeners();
      },
      onError: (error) {
        renderError = error.toString();
        notifyListeners();
      },
    );

    try {
      final outputPath = await _renderer.render(
        templateJson: jsonEncode(template.toJson()),
        slotVideoPaths: selectedVideos,
        textOverrides: textOverrides,
        themeOverrides: themeOverrides,
      );

      lastRenderOutputPath = outputPath;
      renderProgress = 1.0;
      return outputPath;
    } catch (error) {
      renderError = error.toString();
      return null;
    } finally {
      await _progressSubscription?.cancel();
      _progressSubscription = null;
      isRendering = false;
      notifyListeners();
    }
  }

  Future<void> cancelRender() async {
    await _renderer.cancelRender();
    await _progressSubscription?.cancel();
    _progressSubscription = null;
    isRendering = false;
    renderProgress = 0.0;
    renderError = 'Render cancelled.';
    notifyListeners();
  }

  String? _validateBeforeRender() {
    final slots = template.slots;
    if (slots.isNotEmpty &&
        slots.any((slot) => !selectedVideos.containsKey(slot.id))) {
      return 'Add videos to all media slots before rendering.';
    }

    final fields =
        template.editableFields?.textFields ?? const <TemplateTextFieldDto>[];
    for (final field in fields) {
      final value = (textOverrides[field.id] ?? '').trim();
      if (value.isEmpty) {
        return 'Fill all text fields before rendering.';
      }
      if (field.maxChars != null && value.length > field.maxChars!) {
        return '${field.label} exceeds ${field.maxChars} characters.';
      }
    }

    const requiredKeys = ['primary', 'secondary', 'background'];
    for (final key in requiredKeys) {
      final value = themeOverrides[key] ?? '';
      if (!_isHex(value)) {
        return 'Provide valid theme colors before rendering.';
      }
    }

    if (selectedVideos.isEmpty) {
      return 'Add at least one video before rendering.';
    }

    return null;
  }

  String _normalizeHex(String input) {
    final trimmed = input.trim().toUpperCase();
    if (trimmed.isEmpty) {
      return '#';
    }
    return trimmed.startsWith('#') ? trimmed : '#$trimmed';
  }

  bool _isHex(String value) {
    final exp = RegExp(r'^#([A-Fa-f0-9]{6})$');
    return exp.hasMatch(value);
  }

  @override
  void dispose() {
    _progressSubscription?.cancel();
    super.dispose();
  }
}
