import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/core/Network/error_mapper.dart';
import 'package:mis_mobile/features/marketplace/data/datasources/template_remote_data_source.dart';
import 'package:mis_mobile/features/marketplace/data/models/category_dto.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_detail_dto.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_summary_dto.dart';

abstract class TemplateRepository {
  Future<Either<ApiFailure, List<TemplateSummaryDto>>> fetchTemplates({
    String? category,
    String? q,
    int? page,
  });

  Future<Either<ApiFailure, TemplateDetailDto>> fetchTemplateDetail(String id);

  Future<Either<ApiFailure, List<CategoryDto>>> fetchCategories();
}

class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateRemoteDataSource _remoteDataSource;

  TemplateRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<ApiFailure, List<TemplateSummaryDto>>> fetchTemplates({
    String? category,
    String? q,
    int? page,
  }) async {
    try {
      final templates = await _remoteDataSource.fetchTemplates(
        category: category,
        q: q,
        page: page,
      );
      return Right(templates);
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }

  @override
  Future<Either<ApiFailure, TemplateDetailDto>> fetchTemplateDetail(
      String id) async {
    try {
      final detail = await _remoteDataSource.fetchTemplateDetail(id);
      return Right(detail);
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }

  @override
  Future<Either<ApiFailure, List<CategoryDto>>> fetchCategories() async {
    try {
      final categories = await _remoteDataSource.fetchCategories();
      return Right(categories);
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }
}
