import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/box_decorations.dart';
import 'package:mis_mobile/core/utils/font_size.dart';
import 'package:mis_mobile/features/onboarding/presentation/onboarding.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/features/widgets/buttons/back_button.dart';

class Template extends StatelessWidget {
  final String text;
  final String? subText;
  final String? backButtonText;
  final Widget child;
  final bool goOnboard;
  final bool blueButton;
  final String? blueButtonText;
  final VoidCallback? onBlueButtonPressed;
  final bool scrollable;

  const Template({
    super.key,
    required this.text,
    this.subText,
    this.backButtonText,
    required this.child,
    this.blueButton = false,
    this.goOnboard = false,
    this.blueButtonText,
    this.onBlueButtonPressed,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: scrollable == true
          ? SingleChildScrollView(primary: false, child: _buildContent(context))
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final Widget content = child is Expanded || child is Flexible
        ? child
        : Expanded(child: child);

    return Container(
      height: AppSize.s850.h,
      decoration: BoxDecorations.backgroundDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 34.0),
            decoration: BoxDecorations.shadowDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSize.s70.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(
                      text: backButtonText ?? 'Back',
                      onPressed: () => goOnboard
                          ? Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const Onboarding()),
                              (route) => false)
                          : Navigator.pop(context),
                      color: CustomColors.black,
                    ),
                    blueButton
                        ? TextButton(
                            onPressed: onBlueButtonPressed,
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0xffe0efff),
                                minimumSize: Size(
                                  AppSize.s140.w,
                                  AppSize.s37.h,
                                )),
                            child: Text(blueButtonText!,
                                style: AppTextStyles.bodySmall(
                                    fontWeight: FontWeightUtil.bold)),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                SizedBox(height: AppSize.s28.h),
                Text(text,
                    softWrap: false,
                    maxLines: 1,
                    style: AppTextStyles.headlineMedium(
                        fontSize: FontSizeUtil.f30.sp,
                        fontWeight: FontWeightUtil.bold)),
                SizedBox(height: AppSize.s11.h),
                if (subText != null) ...[
                  Text(
                    subText!,
                    style: AppTextStyles.bodyLarge(
                        fontSize: FontSizeUtil.f16.sp,
                        fontWeight: FontWeightUtil.regular),
                  ),
                  SizedBox(height: AppSize.s35.h),
                ]
              ],
            ),
          ),
          content,
        ],
      ),
    );
  }
}
