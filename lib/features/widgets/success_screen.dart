import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mis_mobile/features/authentication/login/presentation/pages/login_screen.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';
import 'package:mis_mobile/features/widgets/buttons/rounded_button.dart';

class SuccessScreen extends StatefulWidget {
  final String? text;
  final String? subText;
  final String? image;

  const SuccessScreen(
      {Key? key,
      required this.text,
      required this.subText,
      required this.image})
      : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    // lock screen orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    // unlock screen orientation after leaving screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/${widget.image}.png'),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(400.0)),
            SizedBox(
              width: getProportionateScreenWidth(318.0),
              child: Text(
                widget.text!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: getProportionateScreenHeight(30.0),
                      fontWeight: FontWeight.w700,
                      height: 1.07,
                      letterSpacing: -0.04,
                    ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(31.0)),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(34.0)),
              width: getProportionateScreenWidth(335.0),
              child: Text(
                widget.subText!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      letterSpacing: -0.03,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: getProportionateScreenHeight(18.0),
                    ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: getProportionateScreenWidth(327.0),
              child: RoundedButton(
                text: "Log into your account",
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(33.0)),
          ],
        ),
      ),
    );
  }
}
