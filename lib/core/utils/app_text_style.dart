import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';

class AppTextStyles {
  // Small Body Text
  static TextStyle bodySmall(
      {Color color = CustomColors.black,
      double fontSize = 12,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontFamily: 'Plus Jakarta',
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.4,
      color: color,
    );
  }

  // Regular Body Text
  static TextStyle bodyMedium(
      {Color color = CustomColors.black,
      double fontSize = 14,
      FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
      fontFamily: 'Plus Jakarta',
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.5,
      color: color,
    );
  }

  // Large Body Text
  static TextStyle bodyLarge(
      {Color color = CustomColors.black,
      double fontSize = 16,
      FontWeight fontWeight = FontWeight.w600}) {
    return TextStyle(
      fontFamily: 'Plus Jakarta',
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.5,
      color: color,
    );
  }

  static TextStyle bodyXLarge(
      {Color color = CustomColors.black,
      double fontSize = 20,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontFamily: 'Plus Jakarta',
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.4,
      color: color,
    );
  }

  // Headline Small
  static TextStyle headlineSmall(
      {Color color = CustomColors.black,
      double fontSize = 18,
      FontWeight fontWeight = FontWeight.w600}) {
    return TextStyle(
      fontFamily: 'Plus Jakarta',
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.3,
      color: color,
    );
  }

  // Headline Medium
  static TextStyle headlineMedium(
      {Color color = CustomColors.black,
      double fontSize = 22,
      FontWeight fontWeight = FontWeight.w700}) {
    return TextStyle(
      fontFamily: 'Plus Jakarta',
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.2,
      color: color,
    );
  }

  // Headline Large
  static TextStyle headlineLarge(
      {Color color = CustomColors.black,
      double fontSize = 28,
      FontWeight fontWeight = FontWeight.w700}) {
    return TextStyle(
      fontFamily: 'Plus Jakarta',
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.1,
      color: color,
    );
  }

  // Headline XLarge
  static TextStyle headlineXLarge(
      {Color color = CustomColors.black,
      double fontSize = 30,
      FontWeight fontWeight = FontWeight.w700}) {
    return TextStyle(
      fontFamily: 'Plus Jakarta',
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.1,
      color: color,
    );
  }

  static ThemeData textFieldThemeData() {
    return ThemeData(
        textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: Colors.black26,
      selectionHandleColor: Colors.black,
    ));
  }
}
