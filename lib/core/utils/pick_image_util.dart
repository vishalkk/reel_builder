import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mis_mobile/core/utils/crop_image_util.dart';

enum ImageSourceType { gallery, camera }

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  static Future<String?> pickFromGallery({
    double maxWidth = 1024,
    double maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    try {
      // Check permission
      final permission = await _checkGalleryPermission();
      if (!permission) {
        return '';
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (image != null) {
        final croppedImagePath = await CropImageUtil.cropImage(image.path);
        return croppedImagePath;
      }

      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Pick image from camera
  static Future<String?> pickFromCamera({
    double maxWidth = 1024,
    double maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    try {
      // Check permission
      final permission = await _checkCameraPermission();
      if (!permission) {
        throw Exception();
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (image != null) {
        final croppedImagePath = await CropImageUtil.cropImage(image.path);
        return croppedImagePath;
      }

      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Crop image

  // Validate image file
  static bool validateImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return false;

    final File file = File(imagePath);
    if (!file.existsSync()) return false;

    // Check file size (e.g., max 10MB)
    final int fileSizeInBytes = file.lengthSync();
    final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    if (fileSizeInMB > 10) return false;

    // Check file extension
    final String extension = imagePath.toLowerCase().split('.').last;
    final List<String> allowedExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp'
    ];

    return allowedExtensions.contains(extension);
  }

  // Delete image file
  static Future<bool> deleteImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (file.existsSync()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Private helper methods
  static Future<bool> _checkGalleryPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      List<Permission> permissions = [];

      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+: Request specific media permissions
        permissions.addAll([
          Permission.photos,
          Permission.videos, // If you need video access
        ]);
      } else if (androidInfo.version.sdkInt >= 30) {
        // Android 11-12: Request storage permission
        permissions.add(Permission.storage);
      } else {
        // Android 10 and below
        permissions.addAll([
          Permission.storage,
          Permission.photos,
        ]);
      }

      // Check all permissions
      Map<Permission, PermissionStatus> statuses = await permissions.request();

      // Check if any required permission is granted
      bool hasPermission = false;
      for (Permission permission in permissions) {
        if (statuses[permission]?.isGranted == true) {
          hasPermission = true;
          break;
        }
      }

      if (!hasPermission) {
        // Check if any permission is permanently denied
        bool isPermanentlyDenied = false;
        for (Permission permission in permissions) {
          if (statuses[permission]?.isPermanentlyDenied == true) {
            isPermanentlyDenied = true;
            break;
          }
        }

        if (isPermanentlyDenied) {
          print('Permission permanently denied. Please enable in settings.');
          await openAppSettings();
          return false;
        }
      }

      return hasPermission;
    } else if (Platform.isIOS) {
      final status = await Permission.photos.status;

      if (status.isDenied) {
        final result = await Permission.photos.request();
        return result.isGranted;
      }

      if (status.isPermanentlyDenied) {
        print('Permission permanently denied. Please enable in settings.');
        await openAppSettings();
        return false;
      }

      return status.isGranted;
    }

    return true;
  }

  static Future<bool> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }
    return status.isGranted;
  }
}
