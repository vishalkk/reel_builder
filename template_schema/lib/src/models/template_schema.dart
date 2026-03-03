import 'package:json_annotation/json_annotation.dart';

part 'template_schema.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum TransitionType { cut, fade, slideLeft, slideRight }

@JsonEnum(fieldRename: FieldRename.snake)
enum Position {
  topLeft,
  topCenter,
  topRight,
  center,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum FontWeight { w300, w400, w500, w600, w700, w800 }

@JsonSerializable(explicitToJson: true)
class TextStyle {
  const TextStyle({
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    this.colorRef,
  });

  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final String? colorRef;

  factory TextStyle.fromJson(Map<String, dynamic> json) =>
      _$TextStyleFromJson(json);
  Map<String, dynamic> toJson() => _$TextStyleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EditableTextField {
  const EditableTextField({
    required this.id,
    required this.label,
    required this.defaultText,
    this.maxLength,
    this.style,
  });

  final String id;
  final String label;
  final String defaultText;
  final int? maxLength;
  final TextStyle? style;

  factory EditableTextField.fromJson(Map<String, dynamic> json) =>
      _$EditableTextFieldFromJson(json);
  Map<String, dynamic> toJson() => _$EditableTextFieldToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Slot {
  const Slot({
    required this.id,
    required this.position,
    this.textRef,
    this.colorRef,
  });

  final String id;
  final Position position;
  final String? textRef;
  final String? colorRef;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);
  Map<String, dynamic> toJson() => _$SlotToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Scene {
  const Scene({
    required this.id,
    required this.startMs,
    required this.endMs,
    required this.slotIds,
    this.transition = TransitionType.cut,
  });

  final String id;
  final int startMs;
  final int endMs;
  final List<String> slotIds;
  final TransitionType transition;

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);
  Map<String, dynamic> toJson() => _$SceneToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Theme {
  const Theme({required this.colors, this.defaultTextStyle});

  final Map<String, String> colors;
  final TextStyle? defaultTextStyle;

  factory Theme.fromJson(Map<String, dynamic> json) => _$ThemeFromJson(json);
  Map<String, dynamic> toJson() => _$ThemeToJson(this);
}

class ValidationIssue {
  const ValidationIssue({required this.code, required this.message});

  final String code;
  final String message;
}

@JsonSerializable(explicitToJson: true)
class Template {
  const Template({
    required this.schemaVersion,
    required this.id,
    required this.name,
    required this.aspectRatio,
    required this.durationMs,
    required this.theme,
    required this.editableTextFields,
    required this.slots,
    required this.scenes,
  });

  final int schemaVersion;
  final String id;
  final String name;
  final String aspectRatio;
  final int durationMs;
  final Theme theme;
  final List<EditableTextField> editableTextFields;
  final List<Slot> slots;
  final List<Scene> scenes;

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateToJson(this);

  List<ValidationIssue> validate() {
    final issues = <ValidationIssue>[];

    if (aspectRatio != '9:16') {
      issues.add(
        const ValidationIssue(
          code: 'invalid_aspect_ratio',
          message: 'aspectRatio must be 9:16.',
        ),
      );
    }

    if (durationMs > 30000) {
      issues.add(
        const ValidationIssue(
          code: 'duration_exceeds_limit',
          message: 'duration must be less than or equal to 30s.',
        ),
      );
    }

    final slotIds = slots.map((slot) => slot.id).toSet();
    final textFieldIds = editableTextFields.map((field) => field.id).toSet();
    final colorKeys = theme.colors.keys.toSet();

    for (final scene in scenes) {
      if (scene.startMs < 0 ||
          scene.endMs > durationMs ||
          scene.startMs >= scene.endMs) {
        issues.add(
          ValidationIssue(
            code: 'scene_out_of_bounds',
            message:
                'scene "${scene.id}" must fit within duration and have start < end.',
          ),
        );
      }

      for (final slotId in scene.slotIds) {
        if (!slotIds.contains(slotId)) {
          issues.add(
            ValidationIssue(
              code: 'unknown_scene_slot',
              message:
                  'scene "${scene.id}" references unknown slotId "$slotId".',
            ),
          );
        }
      }
    }

    for (final slot in slots) {
      if (slot.textRef != null && !textFieldIds.contains(slot.textRef)) {
        issues.add(
          ValidationIssue(
            code: 'unknown_text_ref',
            message:
                'slot "${slot.id}" references unknown textRef "${slot.textRef}".',
          ),
        );
      }

      if (slot.colorRef != null && !colorKeys.contains(slot.colorRef)) {
        issues.add(
          ValidationIssue(
            code: 'unknown_color_ref',
            message:
                'slot "${slot.id}" references unknown colorRef "${slot.colorRef}".',
          ),
        );
      }
    }

    return issues;
  }
}
