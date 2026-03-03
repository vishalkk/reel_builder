import 'package:mis_mobile/features/template_use/domain/entities/template_use_request.dart';

abstract class TemplateUseRepository {
  Future<void> useTemplate(TemplateUseRequest request);
}
