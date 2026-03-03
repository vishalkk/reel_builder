import 'package:mis_mobile/core/Network/api_client.dart';
import 'package:mis_mobile/core/Network/endpoints.dart';
import 'package:mis_mobile/features/template_use/domain/entities/template_use_request.dart';

abstract class TemplateUseRemoteDataSource {
  Future<RenderSubmissionAcceptedResponse> createSubmission(
    RenderSubmissionCreateRequest request,
  );

  Future<RenderSubmissionStatusResponse> getSubmissionStatus(
      String submissionId);
}

class TemplateUseRemoteDataSourceImpl implements TemplateUseRemoteDataSource {
  final ApiClient _apiClient;

  TemplateUseRemoteDataSourceImpl(this._apiClient);

  @override
  Future<RenderSubmissionAcceptedResponse> createSubmission(
    RenderSubmissionCreateRequest request,
  ) async {
    final response = await _apiClient.post<dynamic>(
      templateUseRenderSubmissionsEndpoint,
      data: request.toJson(),
    );

    final payload = _extractMap(response.data);
    return RenderSubmissionAcceptedResponse.fromJson(payload);
  }

  @override
  Future<RenderSubmissionStatusResponse> getSubmissionStatus(
    String submissionId,
  ) async {
    final response = await _apiClient.get<dynamic>(
      '$templateUseRenderSubmissionsEndpoint/$submissionId',
    );

    final payload = _extractMap(response.data);
    return RenderSubmissionStatusResponse.fromJson(payload);
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
}
