import 'package:json_annotation/json_annotation.dart';

part 'category_dto.g.dart';

@JsonSerializable()
class CategoryDto {
  final String id;
  final String name;
  @JsonKey(name: 'icon_url')
  final String? iconUrl;

  const CategoryDto({
    required this.id,
    required this.name,
    this.iconUrl,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}
