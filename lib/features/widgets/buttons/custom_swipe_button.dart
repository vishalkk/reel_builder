import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';

class CustomSwipeButton extends StatelessWidget {
  final String? text;
  final Widget? iconText;
  final bool isEnabled;
  final Color? color;
  final VoidCallback onSwipe;

  const CustomSwipeButton({
    Key? key,
    this.text,
    this.iconText,
    this.isEnabled = true,
    this.color,
    required this.onSwipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: SwipeButton(
          elevationTrack: 3,
          elevationThumb: 6,
          activeTrackColor: Colors.black,
          thumbPadding: const EdgeInsets.all(8),
          thumb: Container(
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
          height: AppSize.s70.h,
          width: AppSize.s330.w,
          onSwipe: isEnabled ? onSwipe : null,
          child: Container(
            alignment: Alignment.center,
            child: iconText ??
                Text(text ?? "",
                    style: AppTextStyles.headlineSmall(
                      color: isEnabled ? CustomColors.white : Colors.grey,
                    )),
          ),
        ),
      ),
    );
  }
}
