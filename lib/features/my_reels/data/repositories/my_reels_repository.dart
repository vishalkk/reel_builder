import 'package:mis_mobile/features/my_reels/data/datasources/my_reels_local_data_source.dart';
import 'package:mis_mobile/features/my_reels/data/models/my_reel_item.dart';

abstract class MyReelsRepository {
  Future<List<MyReelItem>> getReels();

  Future<MyReelItem> saveExport({
    required String sourceVideoPath,
    required String templateId,
    required String templateName,
    required Map<String, String> textOverrides,
    required Map<String, String> themeOverrides,
  });

  Future<void> deleteReel(String reelId);
}

class MyReelsRepositoryImpl implements MyReelsRepository {
  final MyReelsLocalDataSource localDataSource;

  MyReelsRepositoryImpl(this.localDataSource);

  @override
  Future<List<MyReelItem>> getReels() {
    return localDataSource.getReels();
  }

  @override
  Future<MyReelItem> saveExport({
    required String sourceVideoPath,
    required String templateId,
    required String templateName,
    required Map<String, String> textOverrides,
    required Map<String, String> themeOverrides,
  }) {
    return localDataSource.saveExport(
      sourceVideoPath: sourceVideoPath,
      templateId: templateId,
      templateName: templateName,
      textOverrides: textOverrides,
      themeOverrides: themeOverrides,
    );
  }

  @override
  Future<void> deleteReel(String reelId) {
    return localDataSource.deleteReel(reelId);
  }
}
