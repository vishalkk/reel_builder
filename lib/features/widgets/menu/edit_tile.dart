import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/box_decorations.dart';
import 'package:mis_mobile/core/utils/font_size.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';

class EditTile extends StatelessWidget {
  final String? title;
  final Widget leading;
  final Widget? trailing;
  final bool isEdit;
  final VoidCallback? onTap;

  const EditTile({
    super.key,
    required this.leading,
    required this.isEdit,
    this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style:
                  AppTextStyles.bodyMedium(fontWeight: FontWeightUtil.medium),
            ),
            SizedBox(
              height: AppSize.s10.h,
            ),
          ],
          Container(
            width: AppSize.s320.w,
            height: AppSize.s60.h,
            decoration: BoxDecorations.tileDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s15.w),
                  child: leading,
                ),
                SizedBox(width: AppSize.s12.w),
                if (isEdit) ...[
                  Container(
                    width: AppSize.s80.w,
                    height: AppSize.s35.h,
                    margin: EdgeInsets.only(right: AppSize.s10.w),
                    decoration: BoxDecorations.editDecoration(),
                    child: Center(
                      child: Text(AppStrings.edit,
                          style: AppTextStyles.bodyMedium(
                            fontWeight: FontWeightUtil.bold,
                            color: CustomColors.darkTextBlue,
                          )),
                    ),
                  ),
                ],
                if (trailing != null) ...[
                  Padding(
                    padding: EdgeInsets.only(right: AppSize.s10.w),
                    child: trailing!,
                  ),
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}
