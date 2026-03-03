import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:mis_mobile/core/theme/premium_colors.dart';
import 'package:mis_mobile/core/theme/premium_spacing.dart';
import 'package:mis_mobile/features/my_reels/data/datasources/my_reels_local_data_source.dart';
import 'package:mis_mobile/features/my_reels/data/models/my_reel_item.dart';
import 'package:mis_mobile/features/my_reels/data/repositories/my_reels_repository.dart';
import 'package:mis_mobile/features/widgets/premium_card.dart';

class MyReelsPage extends StatefulWidget {
  const MyReelsPage({super.key});

  @override
  State<MyReelsPage> createState() => _MyReelsPageState();
}

class _MyReelsPageState extends State<MyReelsPage> {
  late final MyReelsRepository _repository;
  bool _isLoading = true;
  String? _error;
  List<MyReelItem> _reels = const [];

  @override
  void initState() {
    super.initState();
    _repository = MyReelsRepositoryImpl(MyReelsLocalDataSourceImpl());
    _loadReels();
  }

  Future<void> _loadReels() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final reels = await _repository.getReels();
      if (!mounted) {
        return;
      }
      setState(() {
        _reels = reels;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteReel(MyReelItem reel) async {
    await _repository.deleteReel(reel.id);
    await _loadReels();
  }

  Future<void> _shareReel(MyReelItem reel) async {
    final file = File(reel.videoPath);
    if (!await file.exists()) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video file no longer exists.')),
      );
      return;
    }

    await Share.shareXFiles(
      [XFile(reel.videoPath)],
      text: 'Check out my reel: ${reel.templateName}',
    );
  }

  Future<void> _previewReel(MyReelItem reel) async {
    final file = File(reel.videoPath);
    if (!await file.exists()) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video file no longer exists.')),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _VideoPreviewDialog(path: reel.videoPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reels'),
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadReels,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return ListView(
        padding: const EdgeInsets.all(PremiumSpacing.x3),
        children: [
          const SizedBox(height: PremiumSpacing.x3),
          const Text(
            'Could not load reels',
            style: TextStyle(
              color: PremiumColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: PremiumSpacing.x1),
          Text(
            _error!,
            style: const TextStyle(color: PremiumColors.textSecondary),
          ),
        ],
      );
    }

    if (_reels.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(PremiumSpacing.x3),
        children: const [
          SizedBox(height: PremiumSpacing.x3),
          Text(
            'No exported reels yet.',
            style: TextStyle(
              color: PremiumColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          SizedBox(height: PremiumSpacing.x1),
          Text(
            'Generate a reel from template wizard to see it here.',
            style: TextStyle(color: PremiumColors.textSecondary),
          ),
        ],
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(PremiumSpacing.x2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: PremiumSpacing.x2,
        crossAxisSpacing: PremiumSpacing.x2,
        childAspectRatio: 0.78,
      ),
      itemCount: _reels.length,
      itemBuilder: (context, index) {
        final reel = _reels[index];
        return PremiumCard(
          onTap: () => _previewReel(reel),
          padding: const EdgeInsets.all(PremiumSpacing.x1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: PremiumColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: PremiumColors.border),
                      ),
                      child: const Icon(
                        Icons.movie_creation_outlined,
                        color: PremiumColors.softGold,
                        size: 36,
                      ),
                    ),
                    const Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: PremiumColors.gold,
                          size: 44,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: PremiumSpacing.x1),
              Text(
                reel.templateName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: PremiumColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(reel.createdAt),
                style: const TextStyle(
                  color: PremiumColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: PremiumSpacing.x1),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _shareReel(reel),
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text('Share'),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _deleteReel(reel),
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _VideoPreviewDialog extends StatefulWidget {
  final String path;

  const _VideoPreviewDialog({required this.path});

  @override
  State<_VideoPreviewDialog> createState() => _VideoPreviewDialogState();
}

class _VideoPreviewDialogState extends State<_VideoPreviewDialog> {
  VideoPlayerController? _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final controller = VideoPlayerController.file(File(widget.path));
    await controller.initialize();
    await controller.play();
    if (!mounted) {
      return;
    }
    setState(() {
      _controller = controller;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(PremiumSpacing.x2),
        child: _loading
            ? const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                  const SizedBox(height: PremiumSpacing.x2),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
