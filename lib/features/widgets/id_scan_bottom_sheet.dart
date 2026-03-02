import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/font_size.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';
import 'package:mis_mobile/features/widgets/buttons/button.dart';

class IdScanBottomSheet extends StatelessWidget {
  final VoidCallback? onTap;

  const IdScanBottomSheet({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.s236.h,
      padding: EdgeInsets.only(
        left: AppSize.s32.w,
        right: AppSize.s29.w,
        top: AppSize.s32.h,
        bottom: AppSize.s35.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.idScan, style: AppTextStyles.headlineLarge()),
              IconButton(
                onPressed: () => Navigator.pop(context, false),
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Text(
            AppStrings.pleaseScanBackSideOfCard,
            style: AppTextStyles.bodyLarge(fontWeight: FontWeightUtil.regular),
          ),
          SizedBox(height: AppSize.s41.h),
          Button(
            text: AppStrings.ok,
            onPressed: onTap ?? () {},
          ),
        ],
      ),
    );
  }
}
