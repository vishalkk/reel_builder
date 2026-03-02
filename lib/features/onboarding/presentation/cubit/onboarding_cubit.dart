import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/box_decorations.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'dart:async';

// State class
class OnboardingState {
  final int currentPage;
  final PageController pageController;

  const OnboardingState({
    required this.currentPage,
    required this.pageController,
  });

  OnboardingState copyWith({
    int? currentPage,
    PageController? pageController,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      pageController: pageController ?? this.pageController,
    );
  }
}

// Cubit class
class OnboardingCubit extends Cubit<OnboardingState> {
  Timer? _timer;

  OnboardingCubit()
      : super(OnboardingState(
          currentPage: 0,
          pageController: PageController(initialPage: 0),
        ));

  void setCurrentPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  void startAutoScroll() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      int nextPage;
      if (state.currentPage < 2) {
        nextPage = state.currentPage + 1;
      } else {
        nextPage = 0;
      }

      state.pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );

      emit(state.copyWith(currentPage: nextPage));
    });
  }

  void stopAutoScroll() {
    _timer?.cancel();
    _timer = null;
  }

  void nextPage() {
    int nextPage = state.currentPage < 2 ? state.currentPage + 1 : 0;
    state.pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );
    emit(state.copyWith(currentPage: nextPage));
  }

  void previousPage() {
    int prevPage = state.currentPage > 0 ? state.currentPage - 1 : 2;
    state.pageController.animateToPage(
      prevPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );
    emit(state.copyWith(currentPage: prevPage));
  }

  AnimatedContainer buildIndicator({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 10),
      margin: EdgeInsets.symmetric(horizontal: AppSize.s5.w),
      height: (5.0).h,
      width: state.currentPage == index ? AppSize.s29.w : AppSize.s7.w,
      decoration: BoxDecorations.animatedDecoration(
          state.currentPage == index ? CustomColors.black : CustomColors.grey),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    state.pageController.dispose();
    return super.close();
  }
}
