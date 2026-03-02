import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final Widget? iconText;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Color? color;

  const RoundedButton(
      {super.key,
      this.text,
      this.iconText,
      required this.onPressed,
      this.isEnabled = true,
      this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s70.h,
      width: AppSize.s330.w,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color ?? CustomColors.black),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppSize.s35.r,
              ),
            ),
          ),
        ),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: iconText ??
                  Text(text ?? "",
                      style: AppTextStyles.headlineSmall(
                        color: isEnabled ? CustomColors.white : Colors.grey,
                      )),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(left: 0),
                width: AppSize.s45.w,
                height: AppSize.s45.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isEnabled ? CustomColors.white : Colors.grey,
                ),
                child: SizedBox(
                  height: AppSize.s7.h,
                  width: AppSize.s7.w,
                  child: const Icon(
                    Icons.chevron_right,
                    color: CustomColors.iconBlack,
                    // size: AppSize.s18.h,,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
