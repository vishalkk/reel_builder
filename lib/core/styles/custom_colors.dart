import 'package:flutter/material.dart';

class CustomColors {
  static const Color primary = Color(0xFF2F77DE);
  static const Color primaryDark = Color(0xFF1E55D3);
  static const Color primaryLight = Color(0xFF5AC3F8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFD8D8D8);
  static const Color black = Color(0xFF303030);
  static const Color red = Color(0xFFE35152);
  static const Color green = Color(0xFF38B070);
  static const Color yellow = Color(0xFFF4FF51);
  static const Color bluishGreen = Color(0xFF089D9D);
  static const Color notification = Color(0xFF68C22F);
  static const Color iconBlack = Color(0xFF383434);
  static const Color goldBg = Color(0xFFD0BC91);
  static const Color mainBg = Color(0xFFD0E6F7);
  static const Color successFillColor = Color(0xffedfff5);
  static const Color successBorderColor = Color(0xff38b070);
  static const Color failFillColor = Color(0xfffff4f4);
  static const Color failBorderColor = Color(0xffff6363);
  static const Color boxShadowColor = Color(0xb2c9dcec);
  static const Color redErrorColor = Color(0xb2FE6261);
  static const Color editBoxColorBlue = Color.fromRGBO(225, 240, 255, 1);
  static const Color darkTextBlue = Color.fromRGBO(64, 114, 228, 1);
  // static Color addMoneyBoxShadowColor =
  //     const Color(0xFFC9DDEC).withOpacity(0.7);
  static const Color disabledColor = Color(0xFF2C394C);
  static const Color cursorColor = Color(0xFFAAD4FF);
  static const Color lineColor = Color(0xFFCCD9E4);
  static const Color greyColor = Color(0xFF383737);
  static const LinearGradient ringGradient = LinearGradient(colors: [
    Color(0xFF4080EE),
    Color(0xFF6ACBF6),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
  static const LinearGradient timerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF089D9D),
      Color(0xFFF4FF51),
    ],
  );
  static const LinearGradient resultBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF5090FF),
      Color(0xFF6ACBF6),
    ],
  );
  static const BoxShadow customBoxShadow = BoxShadow(
    color: CustomColors.boxShadowColor,
    offset: Offset(0, 9),
    blurRadius: 27,
  );
  // static BoxShadow addMoneyBoxShadow = BoxShadow(
  //   color: CustomColors.addMoneyBoxShadowColor,
  //   offset: const Offset(0, 9),
  //   blurRadius: 26,
  // );
}

class FriendlyColors {
  static const Color primary = Color(0xFF5474E7);
  static const Color purple = Color(0xFFC86DCB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFD8D8D8);
  static const Color black = Color(0xFF303030);
  static const Color red = Color(0xFFFF6363);
  static const Color notifcation = Color(0xFF68C22F);
  static const Color iconBlack = Color(0xFF383434);
  static const Color buttonBg = Color(0xFFDDE3FA);
}
