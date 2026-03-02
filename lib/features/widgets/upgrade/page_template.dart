import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/features/widgets/buttons/back_button.dart';

class UpgradePageTemplate extends StatelessWidget {
  final String text;
  final Widget subText;
  final Widget body;
  final Widget? extension;
  final bool removePadding;
  final bool removeBodyPadding;
  final Color? backgroundColor;
  final VoidCallback? onBackButtonClick;

  const UpgradePageTemplate({
    Key? key,
    required this.text,
    required this.subText,
    required this.body,
    this.extension,
    this.removePadding = false,
    this.removeBodyPadding = false,
    this.backgroundColor,
    this.onBackButtonClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        primary: false,
        child: Container(
          height: AppSize.s1000.h,
          color: backgroundColor ?? CustomColors.mainBg.withOpacity(0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: removePadding
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(horizontal: 34.0),
                decoration: const BoxDecoration(
                  color: CustomColors.white,
                  boxShadow: [CustomColors.customBoxShadow],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSize.s70.h),
                    Container(
                      padding: removePadding
                          ? const EdgeInsets.symmetric(horizontal: 34.0)
                          : EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomBackButton(
                            text: 'Back',
                            onPressed: () {
                              onBackButtonClick?.call();
                              Navigator.pop(context);
                            },
                            color: CustomColors.black,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSize.s28.h),
                    Container(
                      padding: removePadding
                          ? const EdgeInsets.symmetric(horizontal: 34.0)
                          : EdgeInsets.zero,
                      child: Text(
                        text,
                        style: AppTextStyles.headlineLarge().copyWith(
                          fontSize: AppSize.s30.h,
                          height: 1.17,
                          letterSpacing: -0.04,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSize.s11.h),
                    Container(
                      padding: removePadding
                          ? const EdgeInsets.symmetric(horizontal: 34.0)
                          : EdgeInsets.zero,
                      child: subText,
                    ),
                    extension != null
                        ? SizedBox(height: AppSize.s30.h)
                        : Container(),
                    Container(
                      // padding: removePadding
                      //     ? EdgeInsets.zero
                      //     : const EdgeInsets.symmetric(horizontal: 4.0),
                      child: extension ?? Container(),
                    ),
                    removePadding
                        ? Container()
                        : SizedBox(height: AppSize.s36.h),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: removeBodyPadding
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(horizontal: 34.5),
                  child: body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
