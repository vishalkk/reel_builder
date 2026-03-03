import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mis_mobile/features/my_reels/data/models/my_reel_item.dart';

abstract class MyReelsLocalDataSource {
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

class MyReelsLocalDataSourceImpl implements MyReelsLocalDataSource {
  static const String _reelsKey = 'my_reels_items';

  @override
  Future<List<MyReelItem>> getReels() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_reelsKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(MyReelItem.fromJson)
        .toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<MyReelItem> saveExport({
    required String sourceVideoPath,
    required String templateId,
    required String templateName,
    required Map<String, String> textOverrides,
    required Map<String, String> themeOverrides,
  }) async {
    final sourceFile = File(sourceVideoPath);
    if (!await sourceFile.exists()) {
      throw Exception('Selected export file does not exist.');
    }

    final reelsDir = await _ensureReelsDirectory();
    final extension = _extension(sourceVideoPath);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final destinationPath = '${reelsDir.path}/reel_$id$extension';
    final savedFile = await sourceFile.copy(destinationPath);

    final item = MyReelItem(
      id: id,
      templateId: templateId,
      templateName: templateName,
      videoPath: savedFile.path,
      createdAt: DateTime.now(),
      textOverrides: textOverrides,
      themeOverrides: themeOverrides,
    );

    final reels = await getReels();
    final updated = [item, ...reels];
    await _persist(updated);

    return item;
  }

  @override
  Future<void> deleteReel(String reelId) async {
    final reels = await getReels();
    final target = reels.where((item) => item.id == reelId).toList();
    if (target.isEmpty) {
      return;
    }

    final file = File(target.first.videoPath);
    if (await file.exists()) {
      await file.delete();
    }

    final updated =
        reels.where((item) => item.id != reelId).toList(growable: false);
    await _persist(updated);
  }

  Future<Directory> _ensureReelsDirectory() async {
    final appDocs = await getApplicationDocumentsDirectory();
    final reelsDir = Directory('${appDocs.path}/reels');
    if (!await reelsDir.exists()) {
      await reelsDir.create(recursive: true);
    }
    return reelsDir;
  }

  Future<void> _persist(List<MyReelItem> reels) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        jsonEncode(reels.map((e) => e.toJson()).toList(growable: false));
    await prefs.setString(_reelsKey, encoded);
  }

  String _extension(String path) {
    final idx = path.lastIndexOf('.');
    if (idx == -1) {
      return '.mp4';
    }
    return path.substring(idx);
  }
}
