part of 'template_marketplace_bloc.dart';

enum TemplateMarketplaceStatus { initial, loading, success, failure }

class TemplateMarketplaceState {
  final TemplateMarketplaceStatus status;
  final List<CategoryDto> categories;
  final List<TemplateSummaryDto> templates;
  final String? selectedCategory;
  final String search;
  final String? error;

  const TemplateMarketplaceState({
    this.status = TemplateMarketplaceStatus.initial,
    this.categories = const <CategoryDto>[],
    this.templates = const <TemplateSummaryDto>[],
    this.selectedCategory,
    this.search = '',
    this.error,
  });

  bool get isLoading => status == TemplateMarketplaceStatus.loading;

  TemplateMarketplaceState copyWith({
    TemplateMarketplaceStatus? status,
    List<CategoryDto>? categories,
    List<TemplateSummaryDto>? templates,
    String? category,
    bool clearCategory = false,
    String? search,
    String? error,
    bool clearError = false,
  }) {
    return TemplateMarketplaceState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      templates: templates ?? this.templates,
      selectedCategory: clearCategory ? null : (category ?? selectedCategory),
      search: search ?? this.search,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
