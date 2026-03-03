import 'package:mis_mobile/features/marketplace/domain/entities/marketplace_item.dart';

class MarketplaceLocalDataSource {
  const MarketplaceLocalDataSource();

  List<MarketplaceItem> getItems() {
    return const [
      MarketplaceItem(
        id: 'starter-pack',
        title: 'Starter Reel Pack',
        description: 'Quick-start templates for short-form product reels.',
      ),
      MarketplaceItem(
        id: 'food-pack',
        title: 'Food Creator Pack',
        description: 'Vertical formats designed for menu and cafe showcases.',
      ),
      MarketplaceItem(
        id: 'fashion-pack',
        title: 'Fashion Drop Pack',
        description: 'Transitions and layouts for lookbooks and launches.',
      ),
    ];
  }
}
