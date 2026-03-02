import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/font_size.dart';

class ThemeCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool value;
  final Function(bool)? onChanged;
  const ThemeCard(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.value,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.s150.w,
      height: AppSize.s300.h,
      decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(AppSize.s12.r)),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: AppSize.s10.h),
              child: Image.asset(
                imagePath,
                scale: 0.9,
              ),
            ),
            Text(
              text,
              style:
                  AppTextStyles.bodyMedium(fontWeight: FontWeightUtil.semibold),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: CustomColors.green,
              thumbColor: WidgetStateProperty.all<Color>(CustomColors.white),
              inactiveTrackColor: CustomColors.black,
            )
          ],
        ),
      ),
    );
  }
}
