import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/app_images.dart';
import 'package:mis_mobile/core/utils/app_size.dart';

class BoxDecorations {
  static BoxDecoration backgroundDecoration() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(AppImages.backgroundImageString),
        fit: BoxFit.cover,
      ),
    );
  }

  static BoxDecoration shadowDecoration() {
    return BoxDecoration(
      color: CustomColors.white,
      boxShadow: [CustomColors.customBoxShadow],
    );
  }

  static BoxDecoration tileDecoration() {
    return BoxDecoration(
      color: CustomColors.white,
      border: Border.all(color: Colors.black, width: 0.2),
      borderRadius: BorderRadius.circular(AppSize.s12.r),
      boxShadow: [
        BoxShadow(
          color: CustomColors.boxShadowColor,
          spreadRadius: AppSize.s5,
          blurRadius: AppSize.s7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static BoxDecoration editDecoration() {
    return BoxDecoration(
      color: CustomColors.editBoxColorBlue,
      border: Border.all(color: Colors.black, width: 0.2.w),
      borderRadius: BorderRadius.circular(5.r),
    );
  }

  static BoxDecoration animatedDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(AppSize.s3.r)),
    );
  }

  static BoxDecoration imageDecoration(ImageProvider img) {
    return BoxDecoration(image: DecorationImage(image: img));
  }

  static BoxDecoration idCardOcrDetailDecoration() {
    return BoxDecoration(
      color: CustomColors.white,
      borderRadius: BorderRadius.circular(AppSize.s12.r), // rounded corners
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    );
  }

  static BoxDecoration cameraCaptureButtonDecoration() {
    return BoxDecoration(
      color: CustomColors.grey,
      shape: BoxShape.circle,
      border: Border.all(color: CustomColors.white, width: 2),
    );
  }

  static BoxDecoration circularDecoration(Color color) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    );
  }

  static BoxDecoration resultBgGradientDecoration() {
    return BoxDecoration(
      gradient: CustomColors.resultBgGradient,
    );
  }
}
