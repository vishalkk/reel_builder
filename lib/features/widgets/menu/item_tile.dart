import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';

class ItemTile extends StatelessWidget {
  const ItemTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s7.h,
        horizontal: AppSize.s10.w,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: AppSize.s20.sp),
            SizedBox(width: AppSize.s10.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium(),
              ),
            ),
            Icon(Icons.chevron_right, size: AppSize.s20.sp)
          ],
        ),
      ),
    );
  }
}
