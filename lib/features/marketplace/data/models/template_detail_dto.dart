import 'package:json_annotation/json_annotation.dart';

part 'template_detail_dto.g.dart';

@JsonSerializable()
class TemplateDetailDto {
  final String id;
  final String title;
  final String? description;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @JsonKey(name: 'preview_url')
  final String? previewUrl;
  @JsonKey(name: 'duration_seconds')
  final int? durationSeconds;
  @JsonKey(name: 'is_premium', defaultValue: false)
  final bool isPremium;
  @JsonKey(defaultValue: <String>[])
  final List<String> tags;
  @JsonKey(defaultValue: <TemplateSlotDto>[])
  final List<TemplateSlotDto> slots;
  @JsonKey(name: 'editable_fields')
  final EditableFieldsDto? editableFields;

  const TemplateDetailDto({
    required this.id,
    required this.title,
    this.description,
    this.thumbnailUrl,
    this.previewUrl,
    this.durationSeconds,
    required this.isPremium,
    required this.tags,
    required this.slots,
    this.editableFields,
  });

  factory TemplateDetailDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateDetailDtoToJson(this);
}

@JsonSerializable()
class TemplateSlotDto {
  final String id;
  final String name;
  @JsonKey(name: 'duration_seconds')
  final int? durationSeconds;

  const TemplateSlotDto({
    required this.id,
    required this.name,
    this.durationSeconds,
  });

  factory TemplateSlotDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateSlotDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateSlotDtoToJson(this);
}

@JsonSerializable()
class EditableFieldsDto {
  @JsonKey(name: 'text_fields', defaultValue: <TemplateTextFieldDto>[])
  final List<TemplateTextFieldDto> textFields;

  const EditableFieldsDto({
    required this.textFields,
  });

  factory EditableFieldsDto.fromJson(Map<String, dynamic> json) =>
      _$EditableFieldsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditableFieldsDtoToJson(this);
}

@JsonSerializable()
class TemplateTextFieldDto {
  final String id;
  final String label;
  @JsonKey(name: 'max_chars')
  final int? maxChars;
  final String? placeholder;
  @JsonKey(name: 'default_value')
  final String? defaultValue;

  const TemplateTextFieldDto({
    required this.id,
    required this.label,
    this.maxChars,
    this.placeholder,
    this.defaultValue,
  });

  factory TemplateTextFieldDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateTextFieldDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateTextFieldDtoToJson(this);
}
