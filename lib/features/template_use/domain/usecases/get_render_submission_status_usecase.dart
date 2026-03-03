import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/features/template_use/domain/entities/template_use_request.dart';
import 'package:mis_mobile/features/template_use/domain/repositories/template_use_repository.dart';

class GetRenderSubmissionStatusUseCase {
  final TemplateUseRepository _repository;

  const GetRenderSubmissionStatusUseCase(this._repository);

  Future<Either<ApiFailure, RenderSubmissionStatusResponse>> execute(
    String submissionId,
  ) {
    return _repository.getSubmissionStatus(submissionId);
  }
}
