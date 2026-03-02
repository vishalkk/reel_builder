import 'package:flutter/material.dart';
import 'package:mis_mobile/features/onboarding/presentation/onboarding.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';
import 'package:mis_mobile/features/widgets/buttons/back_button.dart';

class TemplateWithIcon extends StatelessWidget {
  final String text;
  final String subText;
  final String? backButtonText;
  final Widget child;
  final bool goOnboard;
  final bool sendCode;
  final String iconUrl;

  const TemplateWithIcon({
    Key? key,
    required this.text,
    required this.subText,
    this.backButtonText,
    required this.child,
    this.sendCode = false,
    this.goOnboard = false,
    required this.iconUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        primary: false,
        child: Container(
          height: getProportionateScreenHeight(844.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: CustomColors.white,
                  boxShadow: [CustomColors.customBoxShadow],
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        child: Image.asset(iconUrl),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 34.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: getProportionateScreenHeight(70.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBackButton(
                                text: backButtonText ?? 'Back',
                                onPressed: () => goOnboard
                                    ? Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (_) => const Onboarding()),
                                        (route) => false)
                                    : Navigator.pop(context),
                                color: CustomColors.black,
                              ),
                              sendCode
                                  ? TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xffe0efff),
                                          minimumSize: Size(
                                            getProportionateScreenWidth(104.0),
                                            getProportionateScreenHeight(37.0),
                                          )),
                                      child: Text(
                                        "Resend Code",
                                        style: TextStyle(
                                          color: const Color(0xff2c6ddb),
                                          fontSize:
                                              getProportionateScreenHeight(
                                                  12.0),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(28.0)),
                          Text(
                            text,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontSize: getProportionateScreenHeight(30.0),
                                  fontWeight: FontWeight.w700,
                                  height: 1.17,
                                  letterSpacing: -0.04,
                                ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(11.0)),
                          Text(
                            subText,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontSize: getProportionateScreenHeight(16.0),
                                  fontWeight: FontWeight.w400,
                                  height: 1.31,
                                  letterSpacing: -0.03,
                                ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(36.0)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 34.5),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
