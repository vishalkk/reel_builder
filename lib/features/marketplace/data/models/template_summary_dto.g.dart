// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemplateSummaryDto _$TemplateSummaryDtoFromJson(Map<String, dynamic> json) =>
    TemplateSummaryDto(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
      isPremium: json['is_premium'] as bool? ?? false,
      categoryId: json['category_id'] as String?,
    );

Map<String, dynamic> _$TemplateSummaryDtoToJson(TemplateSummaryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnail_url': instance.thumbnailUrl,
      'duration_seconds': instance.durationSeconds,
      'is_premium': instance.isPremium,
      'category_id': instance.categoryId,
    };
