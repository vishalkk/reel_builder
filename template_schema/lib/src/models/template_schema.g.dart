// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextStyle _$TextStyleFromJson(Map<String, dynamic> json) => TextStyle(
  fontFamily: json['fontFamily'] as String,
  fontSize: (json['fontSize'] as num).toDouble(),
  fontWeight: $enumDecode(_$FontWeightEnumMap, json['fontWeight']),
  colorRef: json['colorRef'] as String?,
);

Map<String, dynamic> _$TextStyleToJson(TextStyle instance) => <String, dynamic>{
  'fontFamily': instance.fontFamily,
  'fontSize': instance.fontSize,
  'fontWeight': _$FontWeightEnumMap[instance.fontWeight]!,
  'colorRef': instance.colorRef,
};

const _$FontWeightEnumMap = {
  FontWeight.w300: 'w300',
  FontWeight.w400: 'w400',
  FontWeight.w500: 'w500',
  FontWeight.w600: 'w600',
  FontWeight.w700: 'w700',
  FontWeight.w800: 'w800',
};

EditableTextField _$EditableTextFieldFromJson(Map<String, dynamic> json) =>
    EditableTextField(
      id: json['id'] as String,
      label: json['label'] as String,
      defaultText: json['defaultText'] as String,
      maxLength: (json['maxLength'] as num?)?.toInt(),
      style: json['style'] == null
          ? null
          : TextStyle.fromJson(json['style'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditableTextFieldToJson(EditableTextField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'defaultText': instance.defaultText,
      'maxLength': instance.maxLength,
      'style': instance.style?.toJson(),
    };

Slot _$SlotFromJson(Map<String, dynamic> json) => Slot(
  id: json['id'] as String,
  position: $enumDecode(_$PositionEnumMap, json['position']),
  textRef: json['textRef'] as String?,
  colorRef: json['colorRef'] as String?,
);

Map<String, dynamic> _$SlotToJson(Slot instance) => <String, dynamic>{
  'id': instance.id,
  'position': _$PositionEnumMap[instance.position]!,
  'textRef': instance.textRef,
  'colorRef': instance.colorRef,
};

const _$PositionEnumMap = {
  Position.topLeft: 'top_left',
  Position.topCenter: 'top_center',
  Position.topRight: 'top_right',
  Position.center: 'center',
  Position.bottomLeft: 'bottom_left',
  Position.bottomCenter: 'bottom_center',
  Position.bottomRight: 'bottom_right',
};

Scene _$SceneFromJson(Map<String, dynamic> json) => Scene(
  id: json['id'] as String,
  startMs: (json['startMs'] as num).toInt(),
  endMs: (json['endMs'] as num).toInt(),
  slotIds: (json['slotIds'] as List<dynamic>).map((e) => e as String).toList(),
  transition:
      $enumDecodeNullable(_$TransitionTypeEnumMap, json['transition']) ??
      TransitionType.cut,
);

Map<String, dynamic> _$SceneToJson(Scene instance) => <String, dynamic>{
  'id': instance.id,
  'startMs': instance.startMs,
  'endMs': instance.endMs,
  'slotIds': instance.slotIds,
  'transition': _$TransitionTypeEnumMap[instance.transition]!,
};

const _$TransitionTypeEnumMap = {
  TransitionType.cut: 'cut',
  TransitionType.fade: 'fade',
  TransitionType.slideLeft: 'slide_left',
  TransitionType.slideRight: 'slide_right',
};

Theme _$ThemeFromJson(Map<String, dynamic> json) => Theme(
  colors: Map<String, String>.from(json['colors'] as Map),
  defaultTextStyle: json['defaultTextStyle'] == null
      ? null
      : TextStyle.fromJson(json['defaultTextStyle'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ThemeToJson(Theme instance) => <String, dynamic>{
  'colors': instance.colors,
  'defaultTextStyle': instance.defaultTextStyle?.toJson(),
};

Template _$TemplateFromJson(Map<String, dynamic> json) => Template(
  schemaVersion: (json['schemaVersion'] as num).toInt(),
  id: json['id'] as String,
  name: json['name'] as String,
  aspectRatio: json['aspectRatio'] as String,
  durationMs: (json['durationMs'] as num).toInt(),
  theme: Theme.fromJson(json['theme'] as Map<String, dynamic>),
  editableTextFields: (json['editableTextFields'] as List<dynamic>)
      .map((e) => EditableTextField.fromJson(e as Map<String, dynamic>))
      .toList(),
  slots: (json['slots'] as List<dynamic>)
      .map((e) => Slot.fromJson(e as Map<String, dynamic>))
      .toList(),
  scenes: (json['scenes'] as List<dynamic>)
      .map((e) => Scene.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TemplateToJson(Template instance) => <String, dynamic>{
  'schemaVersion': instance.schemaVersion,
  'id': instance.id,
  'name': instance.name,
  'aspectRatio': instance.aspectRatio,
  'durationMs': instance.durationMs,
  'theme': instance.theme.toJson(),
  'editableTextFields': instance.editableTextFields
      .map((e) => e.toJson())
      .toList(),
  'slots': instance.slots.map((e) => e.toJson()).toList(),
  'scenes': instance.scenes.map((e) => e.toJson()).toList(),
};
