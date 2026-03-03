import 'package:mis_mobile/features/marketplace/domain/entities/marketplace_item.dart';

abstract class MarketplaceRepository {
  Future<List<MarketplaceItem>> getItems();
}
