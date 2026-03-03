part of 'template_detail_bloc.dart';

abstract class TemplateDetailEvent {
  const TemplateDetailEvent();
}

class TemplateDetailRequested extends TemplateDetailEvent {
  final String templateId;

  const TemplateDetailRequested(this.templateId);
}
