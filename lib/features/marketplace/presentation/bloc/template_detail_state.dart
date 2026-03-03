part of 'template_detail_bloc.dart';

enum TemplateDetailStatus { initial, loading, success, failure }

class TemplateDetailState {
  final TemplateDetailStatus status;
  final TemplateDetailDto? detail;
  final String? error;

  const TemplateDetailState({
    this.status = TemplateDetailStatus.initial,
    this.detail,
    this.error,
  });

  TemplateDetailState copyWith({
    TemplateDetailStatus? status,
    TemplateDetailDto? detail,
    String? error,
    bool clearError = false,
  }) {
    return TemplateDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
