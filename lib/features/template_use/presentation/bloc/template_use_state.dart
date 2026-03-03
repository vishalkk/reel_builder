part of 'template_use_bloc.dart';

enum TemplateUseStatus {
  initial,
  submitting,
  polling,
  completed,
  failure,
  cancelled,
}

class TemplateUseState {
  final TemplateUseStatus status;
  final String? submissionId;
  final int progress;
  final int? etaSeconds;
  final RenderSubmissionStatus? backendStatus;
  final String? downloadUrl;
  final String? error;

  const TemplateUseState({
    this.status = TemplateUseStatus.initial,
    this.submissionId,
    this.progress = 0,
    this.etaSeconds,
    this.backendStatus,
    this.downloadUrl,
    this.error,
  });

  bool get isBusy =>
      status == TemplateUseStatus.submitting ||
      status == TemplateUseStatus.polling;

  TemplateUseState copyWith({
    TemplateUseStatus? status,
    String? submissionId,
    int? progress,
    int? etaSeconds,
    bool clearEta = false,
    RenderSubmissionStatus? backendStatus,
    String? downloadUrl,
    String? error,
    bool clearError = false,
    bool clearResult = false,
  }) {
    return TemplateUseState(
      status: status ?? this.status,
      submissionId: submissionId ?? this.submissionId,
      progress: progress ?? this.progress,
      etaSeconds: clearEta ? null : (etaSeconds ?? this.etaSeconds),
      backendStatus: backendStatus ?? this.backendStatus,
      downloadUrl: clearResult ? null : (downloadUrl ?? this.downloadUrl),
      error: clearError ? null : (error ?? this.error),
    );
  }
}
