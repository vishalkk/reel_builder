import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/utils/app_images.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/box_decorations.dart';
import 'package:mis_mobile/core/utils/font_size.dart';

class BannerView extends StatefulWidget {
  final PageController pageController;
  final int currentPage;
  final Function(int)? onPageChanged;

  const BannerView({
    super.key,
    required this.pageController,
    required this.currentPage,
    this.onPageChanged,
  });

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  // List of pages
  List<Map<dynamic, dynamic>> data = [
    {
      "text": "Secure digital\nwallet",
      "subText":
          "MyApp provides a fully secure digital wallet to ease everyday transactions",
      "imgUrl": AppImages.cardImageString,
      "buttonText": "Continue",
    },
    {
      "text": "Instant money\ntransfer",
      "subText":
          "MyApp provides fast, secure and instant money transfers across the globe",
      "imgUrl": AppImages.globeImageString,
      "buttonText": "Continue",
    },
    {
      "text": "Pay the bills\neasily",
      "subText":
          "With MyApp, paying bills is quick and easy,fully secure and convenient",
      "imgUrl": AppImages.billsImageString,
      "buttonText": "Continue",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppSize.s438.h,
          child: PageView.builder(
            itemCount: data.length,
            physics: const BouncingScrollPhysics(),
            controller: widget.pageController,
            onPageChanged: (page) {
              // Call the callback function if provided
              widget.onPageChanged?.call(page);
            },
            itemBuilder: (context, itemIndex) {
              return Column(
                children: <Widget>[
                  Container(
                      height: AppSize.s191.h,
                      width: AppSize.s290.w,
                      decoration: BoxDecorations.imageDecoration(
                        AssetImage(
                          data[itemIndex]["imgUrl"],
                        ),
                      )),
                  SizedBox(height: AppSize.s35.h),
                  SizedBox(
                    height: AppSize.s35.h,
                    width: AppSize.s270.w,
                    child: FittedBox(
                      child: Text(
                        data[itemIndex]["text"],
                        style: AppTextStyles.bodyLarge(
                            fontSize: AppSize.s34,
                            fontWeight: FontWeightUtil.regular),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    width: AppSize.s230.w,
                    height: AppSize.s120.h,
                    alignment: Alignment.center,
                    child: Text(data[itemIndex]["subText"],
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge(
                            fontSize: AppSize.s18,
                            fontWeight: FontWeightUtil.regular)),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
