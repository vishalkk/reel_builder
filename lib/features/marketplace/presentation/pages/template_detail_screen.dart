import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:mis_mobile/core/Network/api_client.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/core/theme/premium_colors.dart';
import 'package:mis_mobile/core/theme/premium_spacing.dart';
import 'package:mis_mobile/features/marketplace/data/datasources/template_remote_data_source.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_detail_dto.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_summary_dto.dart';
import 'package:mis_mobile/features/marketplace/data/repositories/template_repository.dart';
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
  late final TemplateRepository _repository;

  bool _isLoading = true;
  String? _error;
  TemplateDetailDto? _detail;

  late final TextEditingController _slotsController;
  late final TextEditingController _textFieldsController;
  late final TextEditingController _themeController;

  VideoPlayerController? _videoController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    _repository =
        TemplateRepositoryImpl(TemplateRemoteDataSourceImpl(ApiClient()));
    _slotsController = TextEditingController(text: '3');
    _textFieldsController = TextEditingController(text: '5');
    _themeController = TextEditingController(text: 'Premium Gold');
    _loadDetail();
  }

  @override
  void dispose() {
    _slotsController.dispose();
    _textFieldsController.dispose();
    _themeController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final Either<ApiFailure, TemplateDetailDto> result =
        await _repository.fetchTemplateDetail(widget.templateId);

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _error = failure.message;
        });
      },
      (detail) async {
        _applySummaryDefaults(detail);
        await _setupVideo(detail.previewUrl);
        if (!mounted) {
          return;
        }
        setState(() {
          _detail = detail;
          _isLoading = false;
        });
      },
    );
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
      return;
    }

    final uri = Uri.tryParse(previewUrl);
    if (uri == null || (!uri.hasScheme || !previewUrl.startsWith('http'))) {
      return;
    }

    final controller = VideoPlayerController.networkUrl(uri);
    await controller.initialize();
    controller.setLooping(true);
    controller.play();

    _videoController = controller;
    _videoReady = true;
  }

  @override
  Widget build(BuildContext context) {
    final title =
        _detail?.title ?? widget.templateSummary?.title ?? 'Template Detail';

    return Scaffold(
      appBar: AppBar(title: const Text('Template Detail')),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildErrorState()
                : _buildContent(title),
      ),
    );
  }

  Widget _buildErrorState() {
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
            _error!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: PremiumColors.textSecondary),
          ),
          const SizedBox(height: PremiumSpacing.x3),
          GoldGradientButton(
            text: 'Retry',
            onPressed: _loadDetail,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String title) {
    final duration = _formatDuration(
      _detail?.durationSeconds ?? widget.templateSummary?.durationSeconds,
    );

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
              if ((_detail?.isPremium ?? widget.templateSummary?.isPremium) ==
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TemplateUsePage(
                      template: _detail!,
                    ),
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
