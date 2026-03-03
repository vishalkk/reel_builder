import 'package:mis_mobile/features/marketplace/data/datasources/marketplace_local_data_source.dart';
import 'package:mis_mobile/features/marketplace/domain/entities/marketplace_item.dart';
import 'package:mis_mobile/features/marketplace/domain/repositories/marketplace_repository.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final MarketplaceLocalDataSource localDataSource;

  const MarketplaceRepositoryImpl(this.localDataSource);

  @override
  Future<List<MarketplaceItem>> getItems() async {
    return localDataSource.getItems();
  }
}
