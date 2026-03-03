part of 'template_marketplace_bloc.dart';

abstract class TemplateMarketplaceEvent {
  const TemplateMarketplaceEvent();
}

class TemplateMarketplaceStarted extends TemplateMarketplaceEvent {
  const TemplateMarketplaceStarted();
}

class TemplateMarketplaceRefreshed extends TemplateMarketplaceEvent {
  const TemplateMarketplaceRefreshed();
}

class TemplateMarketplaceSearchSubmitted extends TemplateMarketplaceEvent {
  final String query;

  const TemplateMarketplaceSearchSubmitted(this.query);
}

class TemplateMarketplaceCategoryChanged extends TemplateMarketplaceEvent {
  final String? categoryId;

  const TemplateMarketplaceCategoryChanged(this.categoryId);
}
