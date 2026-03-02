import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/font_size.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';
import 'package:mis_mobile/features/widgets/buttons/button.dart';

class PhoneNumberErrorAlert extends StatelessWidget {
  final String? errorTitle;
  final VoidCallback? onTap;
  const PhoneNumberErrorAlert({super.key, this.errorTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.s375.h,
      padding: EdgeInsets.only(
        left: AppSize.s32.w,
        right: AppSize.s29.w,
        top: AppSize.s32.h,
        bottom: AppSize.s35.h,
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppSize.s270.w,
                child: Text(AppStrings.phAlreadyInUse,
                    style: AppTextStyles.headlineLarge(fontSize: AppSize.s30)),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: AppSize.s32.h),
          RichText(
            text: TextSpan(
                text: errorTitle ?? AppStrings.phoneNumProv,
                style:
                    AppTextStyles.bodyLarge(fontWeight: FontWeightUtil.regular),
                children: [
                  TextSpan(
                    text: AppStrings.egNumber,
                    style: AppTextStyles.bodyLarge(
                        fontWeight: FontWeightUtil.bold),
                  ),
                  TextSpan(
                    text: AppStrings.alreadyLinked,
                    style: AppTextStyles.bodyLarge(
                        fontWeight: FontWeightUtil.regular),
                  ),
                ]),
          ),
          SizedBox(height: AppSize.s41.h),
          Button(
            text: AppStrings.changeNum,
            onPressed: onTap ?? () {},
          ),
        ],
      ),
    );
  }
}
