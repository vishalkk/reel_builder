part of 'template_use_bloc.dart';

abstract class TemplateUseEvent {
  const TemplateUseEvent();
}

class TemplateUseSubmitted extends TemplateUseEvent {
  final RenderSubmissionCreateRequest request;

  const TemplateUseSubmitted(this.request);
}

class TemplateUseStatusRequested extends TemplateUseEvent {
  final String submissionId;

  const TemplateUseStatusRequested(this.submissionId);
}

class TemplateUsePollingStopped extends TemplateUseEvent {
  final String? reason;

  const TemplateUsePollingStopped({this.reason});
}

class TemplateUseResetRequested extends TemplateUseEvent {
  const TemplateUseResetRequested();
}
