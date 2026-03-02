import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 844 is the layout height that designer use

  // shortestSide helps determine the type of device
  // if less than 600, then it is a phone
  if (SizeConfig._mediaQueryData.size.shortestSide < 600) {
    if (SizeConfig.orientation == Orientation.portrait) {
      return (inputHeight / 844.0) * screenHeight;
    } else {
      return (inputHeight / 390.0) * screenHeight;
    }
  }

  return (inputHeight / 844.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 390 is the layout width that designer use

  // shortestSide helps determine the type of device
  // if less than 600, then it is a phone
  if (SizeConfig._mediaQueryData.size.shortestSide < 600) {
    if (SizeConfig.orientation == Orientation.portrait) {
      return (inputWidth / 390.0) * screenWidth;
    } else {
      return (inputWidth / 844.0) * screenWidth;
    }
  }

  return (inputWidth / 390.0) * screenWidth;
}
