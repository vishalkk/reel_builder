import 'package:flutter/material.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/pick_image_util.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';

class Dialogs {
  static Future<ImageSourceType?> pickImageWithDialog(
      BuildContext context) async {
    return await showDialog<ImageSourceType>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColors.white,
          title: Text(
            AppStrings.imageSource,
            style: AppTextStyles.bodyMedium(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(
                  AppStrings.gallery,
                  style: AppTextStyles.bodyMedium(),
                ),
                onTap: () => Navigator.pop(context, ImageSourceType.gallery),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text(
                  AppStrings.photoCamera,
                  style: AppTextStyles.bodyMedium(),
                ),
                onTap: () => Navigator.pop(context, ImageSourceType.camera),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppStrings.cancel,
                style: AppTextStyles.bodyMedium(),
              ),
            ),
          ],
        );
      },
    );
  }
}
