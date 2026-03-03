import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:mis_mobile/core/Network/api_client.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/core/theme/premium_colors.dart';
import 'package:mis_mobile/core/theme/premium_spacing.dart';
import 'package:mis_mobile/features/marketplace/data/datasources/template_remote_data_source.dart';
import 'package:mis_mobile/features/marketplace/data/models/category_dto.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_summary_dto.dart';
import 'package:mis_mobile/features/marketplace/data/repositories/template_repository.dart';
import 'package:mis_mobile/features/marketplace/presentation/pages/template_detail_screen.dart';
import 'package:mis_mobile/features/widgets/category_chip.dart';
import 'package:mis_mobile/features/widgets/duration_badge.dart';
import 'package:mis_mobile/features/widgets/gold_gradient_button.dart';
import 'package:mis_mobile/features/widgets/premium_badge.dart';
import 'package:mis_mobile/features/widgets/premium_card.dart';

class MarketplaceHomeScreen extends StatefulWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  State<MarketplaceHomeScreen> createState() => _MarketplaceHomeScreenState();
}

class _MarketplaceHomeScreenState extends State<MarketplaceHomeScreen> {
  late final TemplateRepository _repository;
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _error;
  List<CategoryDto> _categories = const [];
  List<TemplateSummaryDto> _templates = const [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _repository =
        TemplateRepositoryImpl(TemplateRemoteDataSourceImpl(ApiClient()));
    _loadMarketplace();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMarketplace() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final categoriesResult = await _repository.fetchCategories();
    final templatesResult = await _repository.fetchTemplates(
      category: _selectedCategory,
      q: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
      page: 1,
    );

    final String? errorMessage =
        _resolveFailure(categoriesResult) ?? _resolveFailure(templatesResult);

    if (errorMessage != null) {
      setState(() {
        _isLoading = false;
        _error = errorMessage;
      });
      return;
    }

    setState(() {
      _isLoading = false;
      _categories = categoriesResult.getOrElse(() => const []);
      _templates = templatesResult.getOrElse(() => const []);
    });
  }

  String? _resolveFailure<T>(Either<ApiFailure, T> result) {
    return result.fold((failure) => failure.message, (_) => null);
  }

  List<TemplateSummaryDto> get _trendingTemplates {
    final sorted = [..._templates];
    sorted.sort((a, b) {
      final premiumOrder = (b.isPremium ? 1 : 0) - (a.isPremium ? 1 : 0);
      if (premiumOrder != 0) {
        return premiumOrder;
      }
      return (b.durationSeconds ?? 0).compareTo(a.durationSeconds ?? 0);
    });
    return sorted.take(8).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadMarketplace,
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return ListView(
        padding: const EdgeInsets.all(PremiumSpacing.x3),
        children: [
          const SizedBox(height: PremiumSpacing.x4),
          Text(
            'Could not load marketplace',
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
            onPressed: _loadMarketplace,
          ),
        ],
      );
    }

    if (_templates.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(PremiumSpacing.x3),
        children: [
          _buildHeader(context),
          const SizedBox(height: PremiumSpacing.x3),
          _buildSearchBar(),
          const SizedBox(height: PremiumSpacing.x3),
          _buildCategoryChips(),
          const SizedBox(height: PremiumSpacing.x4),
          Text(
            'No templates found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: PremiumSpacing.x1),
          Text(
            'Try another category or search term.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: PremiumColors.textSecondary),
          ),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(PremiumSpacing.x2),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildHeader(context),
              const SizedBox(height: PremiumSpacing.x2),
              _buildSearchBar(),
              const SizedBox(height: PremiumSpacing.x3),
              _buildSectionTitle('Trending'),
              const SizedBox(height: PremiumSpacing.x2),
              _buildTrendingCarousel(),
              const SizedBox(height: PremiumSpacing.x3),
              _buildCategoryChips(),
              const SizedBox(height: PremiumSpacing.x3),
              _buildSectionTitle('Templates'),
              const SizedBox(height: PremiumSpacing.x2),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: PremiumSpacing.x2),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: PremiumSpacing.x2,
              crossAxisSpacing: PremiumSpacing.x2,
              childAspectRatio: 0.76,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final template = _templates[index];
                return _buildTemplateGridCard(template);
              },
              childCount: _templates.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: PremiumSpacing.x3),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello Creator',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: PremiumColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: PremiumSpacing.x1),
        Text(
          'Find your next reel template',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onSubmitted: (_) => _loadMarketplace(),
      decoration: InputDecoration(
        hintText: 'Search templates...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: _loadMarketplace,
          icon: const Icon(Icons.tune),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: PremiumColors.textPrimary,
      ),
    );
  }

  Widget _buildTrendingCarousel() {
    final items = _trendingTemplates;

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: PremiumSpacing.x2),
        itemBuilder: (context, index) {
          final template = items[index];
          return SizedBox(
            width: 260,
            child: PremiumCard(
              onTap: () => _openTemplateDetail(template),
              padding: const EdgeInsets.all(PremiumSpacing.x2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        color: PremiumColors.background,
                        child: _buildThumbnail(template.thumbnailUrl),
                      ),
                    ),
                  ),
                  const SizedBox(height: PremiumSpacing.x2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          template.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: PremiumColors.textPrimary,
                          ),
                        ),
                      ),
                      if (template.isPremium) const PremiumBadge(),
                    ],
                  ),
                  const SizedBox(height: PremiumSpacing.x1),
                  DurationBadge(
                      duration: _formatDuration(template.durationSeconds)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: PremiumSpacing.x1),
        itemBuilder: (context, index) {
          if (index == 0) {
            return CategoryChip(
              label: 'All',
              selected: _selectedCategory == null,
              onTap: () {
                setState(() => _selectedCategory = null);
                _loadMarketplace();
              },
            );
          }

          final category = _categories[index - 1];
          return CategoryChip(
            label: category.name,
            selected: _selectedCategory == category.id,
            onTap: () {
              setState(() => _selectedCategory = category.id);
              _loadMarketplace();
            },
          );
        },
      ),
    );
  }

  Widget _buildTemplateGridCard(TemplateSummaryDto template) {
    return PremiumCard(
      onTap: () => _openTemplateDetail(template),
      padding: const EdgeInsets.all(PremiumSpacing.x2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                color: PremiumColors.background,
                child: _buildThumbnail(template.thumbnailUrl),
              ),
            ),
          ),
          const SizedBox(height: PremiumSpacing.x2),
          Text(
            template.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: PremiumColors.textPrimary,
            ),
          ),
          const SizedBox(height: PremiumSpacing.x1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: DurationBadge(
                    duration: _formatDuration(template.durationSeconds)),
              ),
              if (template.isPremium) const PremiumBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String? url) {
    if (url == null || url.isEmpty) {
      return const Icon(
        Icons.movie_creation_outlined,
        size: 40,
        color: PremiumColors.softGold,
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.broken_image_outlined,
        size: 40,
        color: PremiumColors.softGold,
      ),
    );
  }

  void _openTemplateDetail(TemplateSummaryDto template) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TemplateDetailScreen(
          templateId: template.id,
          templateSummary: template,
        ),
      ),
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
