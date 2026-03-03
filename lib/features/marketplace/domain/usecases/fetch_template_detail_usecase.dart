import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_detail_dto.dart';
import 'package:mis_mobile/features/marketplace/data/repositories/template_repository.dart';

class FetchTemplateDetailUseCase {
  final TemplateRepository _repository;

  const FetchTemplateDetailUseCase(this._repository);

  Future<Either<ApiFailure, TemplateDetailDto>> execute(String templateId) {
    return _repository.fetchTemplateDetail(templateId);
  }
}
