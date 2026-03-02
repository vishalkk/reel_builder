import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/utils/app_images.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/box_decorations.dart';
import 'package:mis_mobile/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:mis_mobile/features/onboarding/widgets/auth_component.dart';
import 'package:mis_mobile/features/onboarding/widgets/banner_view.dart';
import 'package:mis_mobile/main.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';
import 'package:provider/provider.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with RouteAware {
  @override
  void initState() {
    super.initState();
    // Lock orientation to portrait on initial load
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    // this function is called once the user has pressed the back button / popped back to this screen

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); // set orientation back to portrait

    super.didPopNext();
  }

  @override
  void didPushNext() {
    // this function is called once the user has pushed to another screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]); // set orientation to support both portrait and landscape
    super.didPushNext();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); //initialize size config
    return Scaffold(
      body: BlocProvider(
        create: (context) => OnboardingCubit()..startAutoScroll(),
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            final onborardingCubit = context.read<OnboardingCubit>();
            return Container(
              height: AppSize.s850.h,
              decoration: BoxDecorations.imageDecoration(
                AssetImage(AppImages.onboardingImageString),
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: AppSize.s56.h),
                    SizedBox(height: AppSize.s80.h),
                    BannerView(
                      pageController: state.pageController,
                      currentPage: state.currentPage,
                      onPageChanged: (page) {
                        onborardingCubit.setCurrentPage(page);
                      },
                    ),
                    SizedBox(height: AppSize.s23.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) =>
                            onborardingCubit.buildIndicator(index: index),
                      ),
                    ),
                    SizedBox(height: AppSize.s50.h),
                    AuthComponent()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
