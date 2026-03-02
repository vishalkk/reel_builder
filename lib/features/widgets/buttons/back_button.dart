import 'package:flutter/material.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';

import 'package:mis_mobile/core/utils/screen_util.dart';

class CustomBackButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;

  const CustomBackButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Row(
        children: [
          Container(
            height: getProportionateScreenHeight(37.0),
            width: getProportionateScreenHeight(37.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
                  color: CustomColors.grey,
                  width: 1.5,
                ),
                borderRadius:
                    BorderRadius.circular(getProportionateScreenHeight(6.0))),
            child: Icon(
              Icons.chevron_left,
              size: getProportionateScreenHeight(20.0),
              color: color,
            ),
          ),
          const SizedBox(width: 15.0),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: getProportionateScreenHeight(14.0),
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: -0.51,
                ),
          )
        ],
      ),
    );
  }
}
