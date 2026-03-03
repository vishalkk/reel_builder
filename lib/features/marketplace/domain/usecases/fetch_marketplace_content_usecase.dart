import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/features/marketplace/data/models/category_dto.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_summary_dto.dart';
import 'package:mis_mobile/features/marketplace/data/repositories/template_repository.dart';

class FetchMarketplaceContentUseCase {
  final TemplateRepository _repository;

  const FetchMarketplaceContentUseCase(this._repository);

  Future<Either<ApiFailure, FetchMarketplaceContentResult>> execute(
    FetchMarketplaceContentInput input,
  ) async {
    final categoriesResult = await _repository.fetchCategories();
    final templatesResult = await _repository.fetchTemplates(
      category: input.category,
      q: input.query,
      page: input.page,
    );

    return categoriesResult.fold(
      Left.new,
      (categories) => templatesResult.fold(
        Left.new,
        (templates) => Right(
          FetchMarketplaceContentResult(
            categories: categories,
            templates: templates,
          ),
        ),
      ),
    );
  }
}

class FetchMarketplaceContentInput {
  final String? category;
  final String? query;
  final int page;

  const FetchMarketplaceContentInput({
    this.category,
    this.query,
    this.page = 1,
  });
}

class FetchMarketplaceContentResult {
  final List<CategoryDto> categories;
  final List<TemplateSummaryDto> templates;

  const FetchMarketplaceContentResult({
    required this.categories,
    required this.templates,
  });
}
