import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loggy/loggy.dart';
import 'package:quickalert/quickalert.dart';
import 'package:mis_mobile/core/di/di.dart';
import 'package:mis_mobile/core/utils/app_prefs.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';
import 'package:mis_mobile/features/authentication/login/presentation/bloc/login_bloc.dart';
import 'package:mis_mobile/features/home.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';
import 'package:mis_mobile/features/widgets/buttons/custom_swipe_button.dart';
import 'package:mis_mobile/features/widgets/custom_textfield.dart';
import 'package:mis_mobile/features/widgets/page_templates/template.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return BlocConsumer<LoginBloc, LoginBlocState>(
      listener: (context, state) {
        if (state.status == LoginBlocStatus.failure) {
          if (state.error != null && state.error!.isNotEmpty) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: AppStrings.oops,
              text: state.error,
            );
          }
          logDebug("error ${state.error}");
        }
        if (state.status == LoginBlocStatus.success) {
          logDebug("sate ${state.status}");
          sl<AppPreferences>().setAccessToken(state.user?.accessToken ?? '');
          sl<AppPreferences>().setRefreshToken(state.user?.refreshToken ?? '');
          sl<AppPreferences>().setUserId(state.user?.id ?? '');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const Home(),
            ));
          });
        }
      },
      builder: (context, state) {
        return Template(
          goOnboard: true,
          text: AppStrings.logIn,
          subText: AppStrings.loginSub,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: AppSize.s34.h),
                CustomTextField(
                    text: AppStrings.phoneNum,
                    textEditingController: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    hintText: AppStrings.forExample,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9)
                    ]),
                SizedBox(height: AppSize.s28.h),
                CustomTextField(
                  text: AppStrings.passwordTitle,
                  obscureText: true,
                  hintText: AppStrings.yourPassword,
                  textEditingController: _passwordController,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: AppSize.s195.h),
                CustomSwipeButton(
                  text: AppStrings.logIntoYourAccount,
                  onSwipe: () {
                    debugPrint(_phoneNumberController.text);
                    debugPrint(_passwordController.text);
                    final countryCode = "+233";
                    final phoneNumber = _phoneNumberController.text;
                    final password = _passwordController.text;
                    context.read<LoginBloc>().add(
                          LoginSubmitted(
                            countryCode: countryCode,
                            phoneNumber: phoneNumber,
                            password: password,
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
