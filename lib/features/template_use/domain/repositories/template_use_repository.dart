import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/features/template_use/domain/entities/template_use_request.dart';

abstract class TemplateUseRepository {
  Future<Either<ApiFailure, RenderSubmissionAcceptedResponse>> createSubmission(
    RenderSubmissionCreateRequest request,
  );

  Future<Either<ApiFailure, RenderSubmissionStatusResponse>>
      getSubmissionStatus(
    String submissionId,
  );
}
