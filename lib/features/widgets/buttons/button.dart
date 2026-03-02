import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/font_size.dart';

class Button extends StatelessWidget {
  final String text;
  final Function onPressed;

  const Button({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: AppSize.s50.h,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        child: Text(text,
            style: AppTextStyles.bodyLarge(
                fontWeight: FontWeightUtil.regular, color: CustomColors.white)),
      ),
    );
  }
}
