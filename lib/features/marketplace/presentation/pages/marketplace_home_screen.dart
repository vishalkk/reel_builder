import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mis_mobile/core/di/di.dart';
import 'package:mis_mobile/core/theme/premium_colors.dart';
import 'package:mis_mobile/core/theme/premium_spacing.dart';
import 'package:mis_mobile/features/marketplace/data/models/template_summary_dto.dart';
import 'package:mis_mobile/features/marketplace/presentation/bloc/template_marketplace_bloc.dart';
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
  final TextEditingController _searchController = TextEditingController();
  late final TemplateMarketplaceBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<TemplateMarketplaceBloc>()
      ..add(const TemplateMarketplaceStarted());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bloc.close();
    super.dispose();
  }

  List<TemplateSummaryDto> _trendingTemplates(List<TemplateSummaryDto> source) {
    final sorted = [...source];
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
    return BlocProvider<TemplateMarketplaceBloc>.value(
      value: _bloc,
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              _bloc.add(const TemplateMarketplaceRefreshed());
            },
            child:
                BlocBuilder<TemplateMarketplaceBloc, TemplateMarketplaceState>(
              builder: (context, state) {
                _searchController.value = _searchController.value.copyWith(
                  text: state.search,
                  selection:
                      TextSelection.collapsed(offset: state.search.length),
                );
                return _buildBody(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TemplateMarketplaceState state) {
    if (state.isLoading && state.templates.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == TemplateMarketplaceStatus.failure &&
        state.templates.isEmpty) {
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
            state.error ?? 'Unknown error',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: PremiumColors.textSecondary),
          ),
          const SizedBox(height: PremiumSpacing.x3),
          GoldGradientButton(
            text: 'Retry',
            onPressed: () => _bloc.add(const TemplateMarketplaceRefreshed()),
          ),
        ],
      );
    }

    if (state.templates.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(PremiumSpacing.x3),
        children: [
          _buildHeader(context),
          const SizedBox(height: PremiumSpacing.x3),
          _buildSearchBar(),
          const SizedBox(height: PremiumSpacing.x3),
          _buildCategoryChips(state),
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

    final trendingTemplates = _trendingTemplates(state.templates);

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
              _buildTrendingCarousel(trendingTemplates),
              const SizedBox(height: PremiumSpacing.x3),
              _buildCategoryChips(state),
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
                final template = state.templates[index];
                return _buildTemplateGridCard(template);
              },
              childCount: state.templates.length,
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
      onSubmitted: (value) =>
          _bloc.add(TemplateMarketplaceSearchSubmitted(value)),
      decoration: InputDecoration(
        hintText: 'Search templates...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () => _bloc.add(
            TemplateMarketplaceSearchSubmitted(_searchController.text),
          ),
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

  Widget _buildTrendingCarousel(List<TemplateSummaryDto> items) {
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

  Widget _buildCategoryChips(TemplateMarketplaceState state) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: PremiumSpacing.x1),
        itemBuilder: (context, index) {
          if (index == 0) {
            return CategoryChip(
              label: 'All',
              selected: state.selectedCategory == null,
              onTap: () =>
                  _bloc.add(const TemplateMarketplaceCategoryChanged(null)),
            );
          }

          final category = state.categories[index - 1];
          return CategoryChip(
            label: category.name,
            selected: state.selectedCategory == category.id,
            onTap: () =>
                _bloc.add(TemplateMarketplaceCategoryChanged(category.id)),
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
                  duration: _formatDuration(template.durationSeconds),
                ),
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
