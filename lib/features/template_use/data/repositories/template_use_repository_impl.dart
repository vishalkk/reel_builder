import 'package:mis_mobile/features/template_use/data/datasources/template_use_local_data_source.dart';
import 'package:mis_mobile/features/template_use/domain/entities/template_use_request.dart';
import 'package:mis_mobile/features/template_use/domain/repositories/template_use_repository.dart';

class TemplateUseRepositoryImpl implements TemplateUseRepository {
  final TemplateUseLocalDataSource localDataSource;

  const TemplateUseRepositoryImpl(this.localDataSource);

  @override
  Future<void> useTemplate(TemplateUseRequest request) {
    return localDataSource.useTemplate(request);
  }
}
