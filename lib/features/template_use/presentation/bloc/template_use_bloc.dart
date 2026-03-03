import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/features/template_use/domain/entities/template_use_request.dart';
import 'package:mis_mobile/features/template_use/domain/usecases/create_render_submission_usecase.dart';
import 'package:mis_mobile/features/template_use/domain/usecases/get_render_submission_status_usecase.dart';

part 'template_use_event.dart';
part 'template_use_state.dart';

class TemplateUseBloc extends Bloc<TemplateUseEvent, TemplateUseState> {
  final CreateRenderSubmissionUseCase createRenderSubmissionUseCase;
  final GetRenderSubmissionStatusUseCase getRenderSubmissionStatusUseCase;
  Timer? _pollingTimer;

  TemplateUseBloc({
    required this.createRenderSubmissionUseCase,
    required this.getRenderSubmissionStatusUseCase,
  }) : super(const TemplateUseState()) {
    on<TemplateUseSubmitted>(_onSubmitted);
    on<TemplateUseStatusRequested>(_onStatusRequested);
    on<TemplateUsePollingStopped>(_onPollingStopped);
    on<TemplateUseResetRequested>(_onResetRequested);
  }

  Future<void> _onSubmitted(
    TemplateUseSubmitted event,
    Emitter<TemplateUseState> emit,
  ) async {
    _stopPollingTimer();
    emit(
      state.copyWith(
        status: TemplateUseStatus.submitting,
        clearError: true,
        clearResult: true,
      ),
    );

    final Either<ApiFailure, RenderSubmissionAcceptedResponse> result =
        await createRenderSubmissionUseCase.execute(event.request);

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: TemplateUseStatus.failure,
            error: failure.message,
          ),
        );
      },
      (accepted) async {
        emit(
          state.copyWith(
            status: TemplateUseStatus.polling,
            submissionId: accepted.submissionId,
            progress: accepted.progress,
            etaSeconds: accepted.etaSeconds,
            backendStatus: accepted.status,
            clearError: true,
          ),
        );
        _startPolling(accepted.submissionId);
      },
    );
  }

  Future<void> _onStatusRequested(
    TemplateUseStatusRequested event,
    Emitter<TemplateUseState> emit,
  ) async {
    final Either<ApiFailure, RenderSubmissionStatusResponse> result =
        await getRenderSubmissionStatusUseCase.execute(event.submissionId);

    result.fold(
      (failure) {
        _stopPollingTimer();
        emit(
          state.copyWith(
            status: TemplateUseStatus.failure,
            error: failure.message,
          ),
        );
      },
      (response) {
        final backendStatus = response.status;
        final isTerminal = backendStatus == RenderSubmissionStatus.completed ||
            backendStatus == RenderSubmissionStatus.failed ||
            backendStatus == RenderSubmissionStatus.cancelled;

        if (isTerminal) {
          _stopPollingTimer();
        }

        final mappedStatus = switch (backendStatus) {
          RenderSubmissionStatus.completed => TemplateUseStatus.completed,
          RenderSubmissionStatus.failed => TemplateUseStatus.failure,
          RenderSubmissionStatus.cancelled => TemplateUseStatus.cancelled,
          RenderSubmissionStatus.queued ||
          RenderSubmissionStatus.processing =>
            TemplateUseStatus.polling,
        };

        emit(
          state.copyWith(
            status: mappedStatus,
            submissionId: response.submissionId,
            progress: response.progress,
            etaSeconds: response.etaSeconds,
            backendStatus: backendStatus,
            downloadUrl: response.result?.downloadUrl,
            error: response.error?.message,
            clearError: response.error == null &&
                mappedStatus != TemplateUseStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> _onPollingStopped(
    TemplateUsePollingStopped event,
    Emitter<TemplateUseState> emit,
  ) async {
    _stopPollingTimer();
    emit(
      state.copyWith(
        status: TemplateUseStatus.cancelled,
        error: event.reason ?? state.error,
      ),
    );
  }

  Future<void> _onResetRequested(
    TemplateUseResetRequested event,
    Emitter<TemplateUseState> emit,
  ) async {
    _stopPollingTimer();
    emit(const TemplateUseState());
  }

  void _startPolling(String submissionId) {
    _stopPollingTimer();

    add(TemplateUseStatusRequested(submissionId));
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      add(TemplateUseStatusRequested(submissionId));
    });
  }

  void _stopPollingTimer() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  Future<void> close() {
    _stopPollingTimer();
    return super.close();
  }
}
