import 'package:mis_mobile/core/Network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:mis_mobile/features/marketplace/data/models/category_dto.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_detail_dto.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_summary_dto.dart';

abstract class TemplateRemoteDataSource {
  Future<List<TemplateSummaryDto>> fetchTemplates({
    String? category,
    String? q,
    int? page,
  });

  Future<TemplateDetailDto> fetchTemplateDetail(String id);

  Future<List<CategoryDto>> fetchCategories();
}

class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  final ApiClient _apiClient;

  TemplateRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<TemplateSummaryDto>> fetchTemplates({
    String? category,
    String? q,
    int? page,
  }) async {
    final response = await _apiClient.get<dynamic>(
      '/templates',
      queryParameters: {
        if (category != null && category.isNotEmpty) 'category': category,
        if (q != null && q.isNotEmpty) 'q': q,
        if (page != null) 'page': page,
      },
    );

    final list = _extractList(response.data);
    return list
        .map(_normalizeTemplateSummaryJson)
        .map((item) => TemplateSummaryDto.fromJson(item))
        .toList(growable: false);
  }

  @override
  Future<TemplateDetailDto> fetchTemplateDetail(String id) async {
    final response = await _apiClient.get<dynamic>('/templates/$id');
    final map = _normalizeTemplateDetailJson(_extractMap(response.data));
    return TemplateDetailDto.fromJson(map);
  }

  @override
  Future<List<CategoryDto>> fetchCategories() async {
    try {
      final response = await _apiClient.get<dynamic>('/template-categories');
      final list = _extractList(response.data);
      return list
          .map(_normalizeCategoryJson)
          .map((item) => CategoryDto.fromJson(item))
          .toList(growable: false);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        // Some backends expose category info inside template items only.
        return const <CategoryDto>[];
      }
      rethrow;
    }
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    final dynamic payload = (data is Map<String, dynamic>)
        ? (data['data'] ?? data['items'] ?? data['results'] ?? const [])
        : data;

    if (payload is! List) {
      throw const FormatException('Expected a list response payload.');
    }

    return payload.whereType<Map<String, dynamic>>().toList(growable: false);
  }

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final dynamic payload = data['data'] ?? data;
      if (payload is Map<String, dynamic>) {
        return payload;
      }
    }

    throw const FormatException('Expected an object response payload.');
  }

  Map<String, dynamic> _normalizeTemplateSummaryJson(
      Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['id'] = normalized['id'] ?? normalized['uid'] ?? '';

    final category = normalized['category'];
    if (normalized['category_id'] == null && category is Map<String, dynamic>) {
      normalized['category_id'] = category['id'] ?? category['uid'];
    }

    return normalized;
  }

  Map<String, dynamic> _normalizeTemplateDetailJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['id'] = normalized['id'] ?? normalized['uid'] ?? '';
    return normalized;
  }

  Map<String, dynamic> _normalizeCategoryJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['id'] = normalized['id'] ?? normalized['uid'] ?? '';
    return normalized;
  }
}
