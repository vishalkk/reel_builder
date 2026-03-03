import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/features/template_use/domain/entities/template_use_request.dart';
import 'package:mis_mobile/features/template_use/domain/repositories/template_use_repository.dart';

class CreateRenderSubmissionUseCase {
  final TemplateUseRepository _repository;

  const CreateRenderSubmissionUseCase(this._repository);

  Future<Either<ApiFailure, RenderSubmissionAcceptedResponse>> execute(
    RenderSubmissionCreateRequest request,
  ) {
    return _repository.createSubmission(request);
  }
}
