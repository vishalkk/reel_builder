import 'package:mis_mobile/features/marketplace/domain/entities/marketplace_item.dart';
import 'package:mis_mobile/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetMarketplaceItemsUsecase {
  final MarketplaceRepository repository;

  const GetMarketplaceItemsUsecase(this.repository);

  Future<List<MarketplaceItem>> call() => repository.getItems();
}
