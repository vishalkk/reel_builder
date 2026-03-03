import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/features/marketplace/data/models/category_dto.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_summary_dto.dart';
import 'package:mis_mobile/features/marketplace/domain/usecases/fetch_marketplace_content_usecase.dart';

part 'template_marketplace_event.dart';
part 'template_marketplace_state.dart';

class TemplateMarketplaceBloc
    extends Bloc<TemplateMarketplaceEvent, TemplateMarketplaceState> {
  final FetchMarketplaceContentUseCase fetchMarketplaceContentUseCase;

  TemplateMarketplaceBloc({
    required this.fetchMarketplaceContentUseCase,
  }) : super(const TemplateMarketplaceState()) {
    on<TemplateMarketplaceStarted>(_onStarted);
    on<TemplateMarketplaceSearchSubmitted>(_onSearchSubmitted);
    on<TemplateMarketplaceCategoryChanged>(_onCategoryChanged);
    on<TemplateMarketplaceRefreshed>(_onRefreshed);
  }

  Future<void> _onStarted(
    TemplateMarketplaceStarted event,
    Emitter<TemplateMarketplaceState> emit,
  ) async {
    await _fetch(emit, category: state.selectedCategory, query: state.search);
  }

  Future<void> _onSearchSubmitted(
    TemplateMarketplaceSearchSubmitted event,
    Emitter<TemplateMarketplaceState> emit,
  ) async {
    final query = event.query.trim();
    await _fetch(emit, category: state.selectedCategory, query: query);
  }

  Future<void> _onCategoryChanged(
    TemplateMarketplaceCategoryChanged event,
    Emitter<TemplateMarketplaceState> emit,
  ) async {
    await _fetch(emit, category: event.categoryId, query: state.search);
  }

  Future<void> _onRefreshed(
    TemplateMarketplaceRefreshed event,
    Emitter<TemplateMarketplaceState> emit,
  ) async {
    await _fetch(emit, category: state.selectedCategory, query: state.search);
  }

  Future<void> _fetch(
    Emitter<TemplateMarketplaceState> emit, {
    required String? category,
    required String query,
  }) async {
    emit(
      state.copyWith(
        status: TemplateMarketplaceStatus.loading,
        category: category,
        search: query,
        clearError: true,
      ),
    );

    final Either<ApiFailure, FetchMarketplaceContentResult> result =
        await fetchMarketplaceContentUseCase.execute(
      FetchMarketplaceContentInput(
        category: category,
        query: query.isEmpty ? null : query,
        page: 1,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TemplateMarketplaceStatus.failure,
          error: failure.message,
          category: category,
          search: query,
        ),
      ),
      (payload) => emit(
        state.copyWith(
          status: TemplateMarketplaceStatus.success,
          category: category,
          search: query,
          categories: payload.categories,
          templates: payload.templates,
          clearError: true,
        ),
      ),
    );
  }
}
