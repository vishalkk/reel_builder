import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/font_size.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';
import 'package:mis_mobile/features/widgets/menu/edit_tile.dart';
import 'package:mis_mobile/features/widgets/page_templates/template.dart';

class Security extends StatelessWidget {
  const Security({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Template(
        text: AppStrings.security,
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
                  AppStrings.changeNumber,
                  style: AppTextStyles.bodyMedium(
                      fontWeight: FontWeightUtil.medium),
                ),
                isEdit: false,
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: AppSize.s15.h,
              ),
              EditTile(
                leading: Text(
                  AppStrings.changePass,
                  style: AppTextStyles.bodyMedium(
                      fontWeight: FontWeightUtil.medium),
                ),
                isEdit: false,
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: AppSize.s15.h,
              ),
              EditTile(
                leading: Text(
                  AppStrings.changePin,
                  style: AppTextStyles.bodyMedium(
                      fontWeight: FontWeightUtil.medium),
                ),
                isEdit: false,
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: AppSize.s15.h,
              ),
              EditTile(
                  leading: Text(
                    AppStrings.pin,
                    style: AppTextStyles.bodyMedium(
                        fontWeight: FontWeightUtil.medium),
                  ),
                  isEdit: false,
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                    activeColor: CustomColors.green,
                    thumbColor:
                        WidgetStateProperty.all<Color>(CustomColors.white),
                    inactiveTrackColor: CustomColors.black,
                  )),
              SizedBox(
                height: AppSize.s15.h,
              ),
              EditTile(
                  leading: Text(
                    AppStrings.faceId,
                    style: AppTextStyles.bodyMedium(
                        fontWeight: FontWeightUtil.medium),
                  ),
                  isEdit: false,
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                    thumbColor:
                        WidgetStateProperty.all<Color>(CustomColors.white),
                    inactiveTrackColor: CustomColors.black,
                  )),
              SizedBox(
                height: AppSize.s15.h,
              ),
              EditTile(
                  leading: Text(
                    AppStrings.fingerId,
                    style: AppTextStyles.bodyMedium(
                        fontWeight: FontWeightUtil.medium),
                  ),
                  isEdit: false,
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                    thumbColor:
                        WidgetStateProperty.all<Color>(CustomColors.white),
                    inactiveTrackColor: CustomColors.black,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
