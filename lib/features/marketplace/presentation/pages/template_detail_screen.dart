import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mis_mobile/core/di/di.dart';
import 'package:mis_mobile/core/theme/premium_colors.dart';
import 'package:mis_mobile/core/theme/premium_spacing.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_detail_dto.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_summary_dto.dart';
import 'package:mis_mobile/features/marketplace/presentation/bloc/template_detail_bloc.dart';
import 'package:mis_mobile/features/template_use/presentation/pages/template_use_page.dart';
import 'package:mis_mobile/features/widgets/duration_badge.dart';
import 'package:mis_mobile/features/widgets/gold_gradient_button.dart';
import 'package:mis_mobile/features/widgets/premium_badge.dart';
import 'package:mis_mobile/features/widgets/premium_card.dart';
import 'package:video_player/video_player.dart';

class TemplateDetailScreen extends StatefulWidget {
  final String templateId;
  final TemplateSummaryDto? templateSummary;

  const TemplateDetailScreen({
    super.key,
    required this.templateId,
    this.templateSummary,
  });

  @override
  State<TemplateDetailScreen> createState() => _TemplateDetailScreenState();
}

class _TemplateDetailScreenState extends State<TemplateDetailScreen> {
  late final TemplateDetailBloc _bloc;
  late final TextEditingController _slotsController;
  late final TextEditingController _textFieldsController;
  late final TextEditingController _themeController;

  VideoPlayerController? _videoController;
  bool _videoReady = false;
  String? _lastPreparedTemplateId;

  @override
  void initState() {
    super.initState();
    _bloc = sl<TemplateDetailBloc>()
      ..add(TemplateDetailRequested(widget.templateId));
    _slotsController = TextEditingController(text: '3');
    _textFieldsController = TextEditingController(text: '5');
    _themeController = TextEditingController(text: 'Premium Gold');
  }

  @override
  void dispose() {
    _bloc.close();
    _slotsController.dispose();
    _textFieldsController.dispose();
    _themeController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _applySummaryDefaults(TemplateDetailDto detail) {
    _slotsController.text =
        (detail.slots.isEmpty ? 3 : detail.slots.length).toString();
    _textFieldsController.text =
        ((detail.editableFields?.textFields.length ?? 0) == 0
                ? 5
                : detail.editableFields!.textFields.length)
            .toString();
    _themeController.text =
        detail.tags.isNotEmpty ? detail.tags.first : 'Premium Gold';
  }

  Future<void> _setupVideo(String? previewUrl) async {
    await _videoController?.dispose();
    _videoController = null;
    _videoReady = false;

    if (previewUrl == null || previewUrl.isEmpty) {
      if (mounted) {
        setState(() {});
      }
      return;
    }

    final uri = Uri.tryParse(previewUrl);
    if (uri == null || (!uri.hasScheme || !previewUrl.startsWith('http'))) {
      if (mounted) {
        setState(() {});
      }
      return;
    }

    final controller = VideoPlayerController.networkUrl(uri);
    await controller.initialize();
    controller.setLooping(true);
    controller.play();

    _videoController = controller;
    _videoReady = true;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TemplateDetailBloc>.value(
      value: _bloc,
      child: BlocConsumer<TemplateDetailBloc, TemplateDetailState>(
        listenWhen: (previous, current) =>
            previous.detail?.id != current.detail?.id,
        listener: (context, state) {
          final detail = state.detail;
          if (detail == null) {
            return;
          }
          if (_lastPreparedTemplateId == detail.id) {
            return;
          }
          _lastPreparedTemplateId = detail.id;
          _applySummaryDefaults(detail);
          _setupVideo(detail.previewUrl);
        },
        builder: (context, state) {
          final detail = state.detail;
          final title = detail?.title ??
              widget.templateSummary?.title ??
              'Template Detail';

          return Scaffold(
            appBar: AppBar(title: const Text('Template Detail')),
            body: SafeArea(
              child:
                  state.status == TemplateDetailStatus.loading && detail == null
                      ? const Center(child: CircularProgressIndicator())
                      : state.status == TemplateDetailStatus.failure &&
                              detail == null
                          ? _buildErrorState(state.error ?? 'Unknown error')
                          : _buildContent(title, detail),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Padding(
      padding: const EdgeInsets.all(PremiumSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Failed to load template',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: PremiumSpacing.x1),
          Text(
            error,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: PremiumColors.textSecondary),
          ),
          const SizedBox(height: PremiumSpacing.x3),
          GoldGradientButton(
            text: 'Retry',
            onPressed: () =>
                _bloc.add(TemplateDetailRequested(widget.templateId)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String title, TemplateDetailDto? detail) {
    final duration = _formatDuration(
        detail?.durationSeconds ?? widget.templateSummary?.durationSeconds);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(PremiumSpacing.x2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPreviewPlayer(),
          const SizedBox(height: PremiumSpacing.x2),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if ((detail?.isPremium ?? widget.templateSummary?.isPremium) ==
                  true)
                const PremiumBadge(),
            ],
          ),
          const SizedBox(height: PremiumSpacing.x2),
          DurationBadge(duration: duration),
          const SizedBox(height: PremiumSpacing.x3),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editable Summary',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: PremiumColors.textPrimary,
                      ),
                ),
                const SizedBox(height: PremiumSpacing.x2),
                _buildSummaryField(
                  label: 'Slots Count',
                  controller: _slotsController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: PremiumSpacing.x2),
                _buildSummaryField(
                  label: 'Text Fields Count',
                  controller: _textFieldsController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: PremiumSpacing.x2),
                _buildSummaryField(
                  label: 'Theme',
                  controller: _themeController,
                ),
              ],
            ),
          ),
          const SizedBox(height: PremiumSpacing.x3),
          SizedBox(
            width: double.infinity,
            child: GoldGradientButton(
              text: 'USE TEMPLATE',
              onPressed: detail == null
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TemplateUsePage(template: detail),
                        ),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: PremiumColors.surface,
          child: _videoReady && _videoController != null
              ? VideoPlayer(_videoController!)
              : const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 56,
                    color: PremiumColors.softGold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSummaryField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: PremiumColors.textSecondary,
              ),
        ),
        const SizedBox(height: PremiumSpacing.x1),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) {
      return '0s';
    }

    final minutes = seconds ~/ 60;
    final remSeconds = seconds % 60;
    if (minutes == 0) {
      return '${remSeconds}s';
    }
    return '${minutes}m ${remSeconds}s';
  }
}
