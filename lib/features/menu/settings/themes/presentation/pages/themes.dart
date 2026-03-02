import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/utils/app_images.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';
import 'package:mis_mobile/features/widgets/page_templates/template.dart';
import 'package:mis_mobile/features/widgets/themes/theme_card.dart';

class Themes extends StatelessWidget {
  const Themes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Template(
        text: AppStrings.themes,
        subText: '',
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppSize.s30.h,
              ),
              Text(
                AppStrings.selectTheme,
                style: AppTextStyles.bodyMedium(),
              ),
              SizedBox(
                height: AppSize.s10.h,
              ),
              Row(
                children: [
                  ThemeCard(
                    imagePath: AppImages.themes01String,
                    text: AppStrings.theme01,
                    value: true,
                    onChanged: (val) {},
                  ),
                  SizedBox(
                    width: AppSize.s30.w,
                  ),
                  ThemeCard(
                    imagePath: AppImages.themes02String,
                    text: AppStrings.theme02,
                    value: false,
                    onChanged: (val) {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
