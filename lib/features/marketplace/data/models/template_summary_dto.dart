import 'package:json_annotation/json_annotation.dart';

part 'template_summary_dto.g.dart';

@JsonSerializable()
class TemplateSummaryDto {
  final String id;
  final String title;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @JsonKey(name: 'duration_seconds')
  final int? durationSeconds;
  @JsonKey(name: 'is_premium', defaultValue: false)
  final bool isPremium;
  @JsonKey(name: 'category_id')
  final String? categoryId;

  const TemplateSummaryDto({
    required this.id,
    required this.title,
    this.thumbnailUrl,
    this.durationSeconds,
    required this.isPremium,
    this.categoryId,
  });

  factory TemplateSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateSummaryDtoToJson(this);
}
