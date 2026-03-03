import 'package:mis_mobile/features/template_use/domain/entities/template_use_request.dart';
import 'package:mis_mobile/features/template_use/domain/repositories/template_use_repository.dart';

class UseTemplateUsecase {
  final TemplateUseRepository repository;

  const UseTemplateUsecase(this.repository);

  Future<void> call(TemplateUseRequest request) {
    return repository.useTemplate(request);
  }
}
