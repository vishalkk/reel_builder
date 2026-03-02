import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';

class CropImageUtil {
  static Future<String?> cropImage(String imagePath) async {
    try {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
      );

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: AppStrings.cropImage,
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            statusBarColor: Colors.transparent,
            backgroundColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            hideBottomControls: true,
            // Add these properties
            activeControlsWidgetColor: Colors.white,
            dimmedLayerColor: Colors.black.withOpacity(0.8),
            cropGridColor: Colors.white,
            cropFrameColor: Colors.white,
          ),
          IOSUiSettings(
            title: AppStrings.cropImage,
          ),
        ],
      );

      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );

      return croppedFile?.path;
    } catch (e) {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
      throw Exception(e.toString());
    }
  }
}
