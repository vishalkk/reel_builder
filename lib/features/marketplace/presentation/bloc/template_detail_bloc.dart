import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_detail_dto.dart';
import 'package:mis_mobile/features/marketplace/domain/usecases/fetch_template_detail_usecase.dart';

part 'template_detail_event.dart';
part 'template_detail_state.dart';

class TemplateDetailBloc
    extends Bloc<TemplateDetailEvent, TemplateDetailState> {
  final FetchTemplateDetailUseCase fetchTemplateDetailUseCase;

  TemplateDetailBloc({
    required this.fetchTemplateDetailUseCase,
  }) : super(const TemplateDetailState()) {
    on<TemplateDetailRequested>(_onRequested);
  }

  Future<void> _onRequested(
    TemplateDetailRequested event,
    Emitter<TemplateDetailState> emit,
  ) async {
    emit(
        state.copyWith(status: TemplateDetailStatus.loading, clearError: true));

    final Either<ApiFailure, TemplateDetailDto> result =
        await fetchTemplateDetailUseCase.execute(event.templateId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TemplateDetailStatus.failure,
          error: failure.message,
        ),
      ),
      (detail) => emit(
        state.copyWith(
          status: TemplateDetailStatus.success,
          detail: detail,
          clearError: true,
        ),
      ),
    );
  }
}
