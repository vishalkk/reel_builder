import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/definition/route_names.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/font_size.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';
import 'package:mis_mobile/core/utils/string_utils.dart';
import 'package:mis_mobile/features/widgets/menu/edit_tile.dart';
import 'package:mis_mobile/features/widgets/page_templates/template.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Template(
        text: AppStrings.settings,
        subText: '',
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s40.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppSize.s30.h,
              ),
              EditTile(
                title: AppStrings.accDetails,
                leading: Text(
                  AppStrings.themes,
                  style: AppTextStyles.bodyMedium(
                      fontWeight: FontWeightUtil.medium),
                ),
                onTap: () => Navigator.pushNamed(context, RouteNames.themes),
                isEdit: false,
                trailing: Icon(
                  Icons.chevron_right,
                  color: CustomColors.black,
                ),
              ),
              SizedBox(
                height: AppSize.s15.h,
              ),
              EditTile(
                leading: Text(
                  AppStrings.privacy,
                  style: AppTextStyles.bodyMedium(
                      fontWeight: FontWeightUtil.medium),
                ),
                isEdit: false,
                trailing: Icon(
                  Icons.chevron_right,
                  color: CustomColors.black,
                ),
              ),
              SizedBox(
                height: AppSize.s15.h,
              ),
              EditTile(
                leading: Text(
                  StringUtils.capitalizeFirstLetter(AppStrings.about),
                  style: AppTextStyles.bodyMedium(
                      fontWeight: FontWeightUtil.medium),
                ),
                isEdit: false,
                trailing: Icon(
                  Icons.chevron_right,
                  color: CustomColors.black,
                ),
              ),
              SizedBox(
                height: AppSize.s15.h,
              ),
              EditTile(
                leading: Text(
                  AppStrings.tnc,
                  style: AppTextStyles.bodyMedium(
                      fontWeight: FontWeightUtil.medium),
                ),
                isEdit: false,
                trailing: Icon(
                  Icons.chevron_right,
                  color: CustomColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
