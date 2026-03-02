import 'package:flutter/material.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';

class CustomProgressBar extends StatelessWidget {
  final String text;

  const CustomProgressBar({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: getProportionateScreenHeight(70),
        decoration: BoxDecoration(
          color: CustomColors.black,
          boxShadow: [
            BoxShadow(
              color: CustomColors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircularProgressIndicator(),
            SizedBox(width: getProportionateScreenWidth(30)),
            Flexible(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: CustomColors.white,
                    ),
              ),
            ),
          ],
        ));
  }
}
