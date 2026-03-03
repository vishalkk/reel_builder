import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mis_mobile/core/di/di.dart';
import 'package:provider/provider.dart';
import 'package:mis_mobile/core/theme/premium_colors.dart';
import 'package:mis_mobile/core/theme/premium_spacing.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_detail_dto.dart';
import 'package:mis_mobile/features/template_use/domain/entities/template_use_request.dart';
import 'package:mis_mobile/features/template_use/presentation/bloc/template_use_bloc.dart';
import 'package:mis_mobile/features/template_use/presentation/controllers/template_use_wizard_controller.dart';
import 'package:mis_mobile/features/widgets/category_chip.dart';
import 'package:mis_mobile/features/widgets/gold_gradient_button.dart';
import 'package:mis_mobile/features/widgets/premium_card.dart';

class TemplateUsePage extends StatelessWidget {
  final TemplateDetailDto template;

  const TemplateUsePage({
    super.key,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TemplateUseBloc>(
      create: (_) => sl<TemplateUseBloc>(),
      child: ChangeNotifierProvider<TemplateUseWizardController>(
        create: (_) => TemplateUseWizardController(template: template),
        child: const _TemplateUseWizardView(),
      ),
    );
  }
}

class _TemplateUseWizardView extends StatelessWidget {
  const _TemplateUseWizardView();

  static const _stepLabels = {
    TemplateUseWizardStep.media: 'Media',
    TemplateUseWizardStep.text: 'Text',
    TemplateUseWizardStep.theme: 'Theme',
    TemplateUseWizardStep.export: 'Export',
  };

  void _submitRenderRequest(
    BuildContext context,
    TemplateUseWizardController controller,
  ) {
    final slotMedia = controller.template.slots
        .where((slot) => controller.selectedVideos[slot.id]?.isNotEmpty == true)
        .map(
          (slot) => RenderSlotMediaInput(
            slotId: slot.id,
            sourceFileId: controller.selectedVideos[slot.id]!,
            trim: slot.durationSeconds != null
                ? RenderTrimRange(
                    start: 0, end: slot.durationSeconds!.toDouble())
                : null,
          ),
        )
        .toList(growable: false);

    final request = RenderSubmissionCreateRequest(
      templateId: controller.template.id,
      idempotencyKey:
          '${DateTime.now().microsecondsSinceEpoch}-${controller.template.id}',
      inputs: RenderSubmissionInputs(
        slotMedia: slotMedia,
        textValues: Map<String, String>.from(controller.textOverrides),
        themeOverrides: <String, String>{
          'primaryColor': controller.themeOverrides['primary'] ?? '#B08D57',
          'secondaryColor': controller.themeOverrides['secondary'] ?? '#8C7853',
          'backgroundColor':
              controller.themeOverrides['background'] ?? '#121212',
        },
      ),
      output: const RenderOutputOptions(
        format: 'mp4',
        resolution: '1080x1920',
        fps: 30,
      ),
    );

    context.read<TemplateUseBloc>().add(TemplateUseSubmitted(request));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TemplateUseBloc, TemplateUseState>(
      listener: (context, state) {
        if (state.status == TemplateUseStatus.completed &&
            state.downloadUrl != null &&
            state.downloadUrl!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Render complete. URL: ${state.downloadUrl}'),
            ),
          );
        } else if (state.status == TemplateUseStatus.failure &&
            state.error != null &&
            state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: Consumer<TemplateUseWizardController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Use Template')),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(PremiumSpacing.x2),
                child: Column(
                  children: [
                    _buildStepper(controller),
                    const SizedBox(height: PremiumSpacing.x2),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildStepContent(context, controller),
                      ),
                    ),
                    if (controller.validationError != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: PremiumSpacing.x1),
                        child: Text(
                          controller.validationError!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.redAccent,
                                  ),
                        ),
                      ),
                    _buildFooterActions(context, controller),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepper(TemplateUseWizardController controller) {
    return Row(
      children: controller.steps.map((step) {
        final index = controller.steps.indexOf(step);
        final currentIndex = controller.steps.indexOf(controller.currentStep);
        final selected = step == controller.currentStep;
        final completed = index < currentIndex;

        return Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: PremiumSpacing.x1 / 2),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: PremiumSpacing.x1,
                horizontal: PremiumSpacing.x1,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? PremiumColors.gold
                    : completed
                        ? PremiumColors.softGold
                        : PremiumColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PremiumColors.border),
              ),
              child: Text(
                _stepLabels[step]!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected || completed
                      ? PremiumColors.background
                      : PremiumColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    TemplateUseWizardController controller,
  ) {
    switch (controller.currentStep) {
      case TemplateUseWizardStep.media:
        return _buildMediaStep(context, controller);
      case TemplateUseWizardStep.text:
        return _buildTextStep(context, controller);
      case TemplateUseWizardStep.theme:
        return _buildThemeStep(context, controller);
      case TemplateUseWizardStep.export:
        return _buildExportStep(context, controller);
    }
  }

  Widget _buildMediaStep(
    BuildContext context,
    TemplateUseWizardController controller,
  ) {
    final slots = controller.template.slots;

    if (slots.isEmpty) {
      return const PremiumCard(
        child: Text(
          'No media slots defined for this template.',
          style: TextStyle(color: PremiumColors.textSecondary),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Media Slots',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: PremiumSpacing.x1),
        Text(
          'Add videos for each required slot.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: PremiumColors.textSecondary,
              ),
        ),
        const SizedBox(height: PremiumSpacing.x2),
        ...slots.map((slot) {
          final selectedPath = controller.selectedVideos[slot.id];
          return Padding(
            padding: const EdgeInsets.only(bottom: PremiumSpacing.x2),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.name,
                    style: const TextStyle(
                      color: PremiumColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: PremiumSpacing.x1),
                  Text(
                    'Trim info: ${slot.durationSeconds != null ? 'Target ${slot.durationSeconds}s' : 'Full clip'}',
                    style: const TextStyle(color: PremiumColors.textSecondary),
                  ),
                  const SizedBox(height: PremiumSpacing.x2),
                  if (selectedPath != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(PremiumSpacing.x2),
                      decoration: BoxDecoration(
                        color: PremiumColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: PremiumColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.video_file,
                            color: PremiumColors.softGold,
                          ),
                          const SizedBox(width: PremiumSpacing.x1),
                          Expanded(
                            child: Text(
                              _fileName(selectedPath),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: PremiumColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(PremiumSpacing.x2),
                      decoration: BoxDecoration(
                        color: PremiumColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: PremiumColors.border),
                      ),
                      child: const Text(
                        'No video selected',
                        style: TextStyle(color: PremiumColors.textSecondary),
                      ),
                    ),
                  const SizedBox(height: PremiumSpacing.x2),
                  GoldGradientButton(
                    text: 'Add Video',
                    onPressed: () => controller.pickVideoForSlot(slot.id),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTextStep(
    BuildContext context,
    TemplateUseWizardController controller,
  ) {
    final textFields = controller.template.editableFields?.textFields ??
        const <TemplateTextFieldDto>[];

    if (textFields.isEmpty) {
      return const PremiumCard(
        child: Text(
          'No editable text fields for this template.',
          style: TextStyle(color: PremiumColors.textSecondary),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Editable Text',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: PremiumSpacing.x2),
        ...textFields.map((field) {
          final value = controller.textOverrides[field.id] ?? '';
          final maxChars = field.maxChars ?? 80;
          return Padding(
            padding: const EdgeInsets.only(bottom: PremiumSpacing.x2),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.label,
                    style: const TextStyle(
                      color: PremiumColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: PremiumSpacing.x1),
                  TextFormField(
                    key: ValueKey('text_${field.id}_$value'),
                    initialValue: value,
                    onChanged: (text) => controller.updateText(field.id, text,
                        maxChars: field.maxChars),
                    maxLength: maxChars,
                    decoration: InputDecoration(
                      hintText: field.placeholder ?? 'Enter text',
                      counterText: '${value.length}/$maxChars',
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildThemeStep(
    BuildContext context,
    TemplateUseWizardController controller,
  ) {
    const keys = ['primary', 'secondary', 'background'];
    const presets = ['Royal Gold', 'Matte Black', 'Champagne', 'Dark Luxury'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Overrides',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: PremiumSpacing.x2),
        Wrap(
          spacing: PremiumSpacing.x1,
          runSpacing: PremiumSpacing.x1,
          children: presets
              .map(
                (preset) => CategoryChip(
                  label: preset,
                  selected: false,
                  onTap: () => controller.applyPreset(preset),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: PremiumSpacing.x2),
        ...keys.map((key) {
          final value = controller.themeOverrides[key] ?? '#';
          return Padding(
            padding: const EdgeInsets.only(bottom: PremiumSpacing.x2),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _titleCase(key),
                    style: const TextStyle(
                      color: PremiumColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: PremiumSpacing.x1),
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _parseColor(value),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: PremiumColors.border),
                        ),
                      ),
                      const SizedBox(width: PremiumSpacing.x1),
                      Expanded(
                        child: TextFormField(
                          key: ValueKey('theme_${key}_$value'),
                          initialValue: value,
                          onChanged: (text) =>
                              controller.updateThemeColor(key, text),
                          decoration: const InputDecoration(
                            hintText: '#RRGGBB',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildExportStep(
    BuildContext context,
    TemplateUseWizardController controller,
  ) {
    final renderState = context.watch<TemplateUseBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export Summary',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: PremiumSpacing.x2),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryRow('Template', controller.template.title),
              const SizedBox(height: PremiumSpacing.x1),
              _summaryRow(
                  'Videos selected', '${controller.selectedVideos.length}'),
              const SizedBox(height: PremiumSpacing.x1),
              _summaryRow(
                  'Text overrides', '${controller.textOverrides.length}'),
              const SizedBox(height: PremiumSpacing.x1),
              _summaryRow(
                'Theme',
                'P:${controller.themeOverrides['primary']} '
                    'S:${controller.themeOverrides['secondary']} '
                    'B:${controller.themeOverrides['background']}',
              ),
            ],
          ),
        ),
        const SizedBox(height: PremiumSpacing.x3),
        if (renderState.isBusy ||
            renderState.status == TemplateUseStatus.completed) ...[
          LinearProgressIndicator(
            value: (renderState.progress.clamp(0, 100)) / 100,
            minHeight: 8,
            backgroundColor: PremiumColors.surface,
            color: PremiumColors.gold,
          ),
          const SizedBox(height: PremiumSpacing.x1),
          Text(
            'Status: ${renderState.backendStatus?.name ?? renderState.status.name} '
            '${renderState.progress}%',
            style: const TextStyle(color: PremiumColors.textSecondary),
          ),
          if (renderState.etaSeconds != null) ...[
            const SizedBox(height: PremiumSpacing.x1),
            Text(
              'ETA: ${renderState.etaSeconds}s',
              style: const TextStyle(color: PremiumColors.textSecondary),
            ),
          ],
          const SizedBox(height: PremiumSpacing.x2),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: renderState.isBusy
                  ? () {
                      context.read<TemplateUseBloc>().add(
                            const TemplateUsePollingStopped(
                              reason: 'Stopped polling render status.',
                            ),
                          );
                    }
                  : null,
              child: const Text('Stop Polling'),
            ),
          ),
          const SizedBox(height: PremiumSpacing.x2),
        ],
        if (renderState.downloadUrl != null &&
            renderState.downloadUrl!.isNotEmpty) ...[
          _summaryRow('Download URL', renderState.downloadUrl!),
          const SizedBox(height: PremiumSpacing.x2),
        ],
        SizedBox(
          width: double.infinity,
          child: GoldGradientButton(
            text: 'Generate',
            isLoading: renderState.isBusy,
            onPressed: () {
              if (renderState.isBusy) {
                return;
              }
              _submitRenderRequest(context, controller);
            },
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String key, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            key,
            style: const TextStyle(color: PremiumColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: PremiumColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterActions(
    BuildContext context,
    TemplateUseWizardController controller,
  ) {
    final currentIndex = controller.steps.indexOf(controller.currentStep);
    final isLast = controller.currentStep == TemplateUseWizardStep.export;

    return Row(
      children: [
        if (currentIndex > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: controller.previousStep,
              child: const Text('Back'),
            ),
          ),
        if (currentIndex > 0) const SizedBox(width: PremiumSpacing.x2),
        if (!isLast)
          Expanded(
            child: GoldGradientButton(
              text: 'Next',
              onPressed: controller.nextStep,
            ),
          ),
      ],
    );
  }

  Color _parseColor(String hex) {
    final value = hex.replaceFirst('#', '');
    if (value.length != 6) {
      return PremiumColors.surface;
    }

    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null) {
      return PremiumColors.surface;
    }

    return Color(0xFF000000 | parsed);
  }

  String _titleCase(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _fileName(String path) {
    return File(path).uri.pathSegments.isEmpty
        ? path
        : File(path).uri.pathSegments.last;
  }
}
