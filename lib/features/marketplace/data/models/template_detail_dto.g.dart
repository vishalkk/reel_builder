// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemplateDetailDto _$TemplateDetailDtoFromJson(Map<String, dynamic> json) =>
    TemplateDetailDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      previewUrl: json['preview_url'] as String?,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
      isPremium: json['is_premium'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      slots: (json['slots'] as List<dynamic>?)
              ?.map((e) => TemplateSlotDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      editableFields: json['editable_fields'] == null
          ? null
          : EditableFieldsDto.fromJson(
              json['editable_fields'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TemplateDetailDtoToJson(TemplateDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'thumbnail_url': instance.thumbnailUrl,
      'preview_url': instance.previewUrl,
      'duration_seconds': instance.durationSeconds,
      'is_premium': instance.isPremium,
      'tags': instance.tags,
      'slots': instance.slots,
      'editable_fields': instance.editableFields,
    };

TemplateSlotDto _$TemplateSlotDtoFromJson(Map<String, dynamic> json) =>
    TemplateSlotDto(
      id: json['id'] as String,
      name: json['name'] as String,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TemplateSlotDtoToJson(TemplateSlotDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'duration_seconds': instance.durationSeconds,
    };

EditableFieldsDto _$EditableFieldsDtoFromJson(Map<String, dynamic> json) =>
    EditableFieldsDto(
      textFields: (json['text_fields'] as List<dynamic>?)
              ?.map((e) =>
                  TemplateTextFieldDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$EditableFieldsDtoToJson(EditableFieldsDto instance) =>
    <String, dynamic>{
      'text_fields': instance.textFields,
    };

TemplateTextFieldDto _$TemplateTextFieldDtoFromJson(
        Map<String, dynamic> json) =>
    TemplateTextFieldDto(
      id: json['id'] as String,
      label: json['label'] as String,
      maxChars: (json['max_chars'] as num?)?.toInt(),
      placeholder: json['placeholder'] as String?,
      defaultValue: json['default_value'] as String?,
    );

Map<String, dynamic> _$TemplateTextFieldDtoToJson(
        TemplateTextFieldDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'max_chars': instance.maxChars,
      'placeholder': instance.placeholder,
      'default_value': instance.defaultValue,
    };
