import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';

class CustomTextField extends StatelessWidget {
  final String? text;
  final String hintText;
  final bool obscureText;
  final Color? color;
  final BoxBorder? border;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.textEditingController,
    this.suffixIcon,
    this.keyboardType,
    this.color,
    this.border,
    this.onChanged,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text != null) Text(text!, style: AppTextStyles.bodyMedium()),
        SizedBox(height: AppSize.s8.h),
        Container(
          height: AppSize.s60.h,
          width: AppSize.s320.w,
          decoration: BoxDecoration(
            color: color ?? CustomColors.white,
            border: border ?? Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(AppSize.s10.h),
            boxShadow: const [CustomColors.customBoxShadow],
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            onChanged: onChanged,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            controller: textEditingController,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                left: 20.0,
                right: 10.0,
                top: 15.25,
                bottom: 15.25,
              ),
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: AppSize.s16.sp,
                color: CustomColors.black.withOpacity(0.5),
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
