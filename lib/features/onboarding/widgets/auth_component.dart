import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/definition/route_names.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';
import 'package:mis_mobile/features/widgets/buttons/custom_swipe_button.dart';

class AuthComponent extends StatelessWidget {
  const AuthComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSwipeButton(
          text: AppStrings.logIntoYourAccount,
          isEnabled: true,
          onSwipe: () async {
            Navigator.of(context).pushReplacementNamed(RouteNames.login);
          },
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, RouteNames.login);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppStrings.alreadyAcc, style: AppTextStyles.bodyLarge()),
              Text(AppStrings.logIn, style: AppTextStyles.bodyLarge()),
            ],
          ),
        ),
        SizedBox(height: AppSize.s36.h),
      ],
    );
  }
}
