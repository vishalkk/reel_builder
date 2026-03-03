import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mis_mobile/core/providers/IndexCubit/index_cubit.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';

class CustomBottomNav extends StatefulWidget {
  int currentIndex;

  CustomBottomNav({Key? key, required this.currentIndex}) : super(key: key);

  @override
  CustomBottomNavState createState() => CustomBottomNavState();
}

class CustomBottomNavState extends State<CustomBottomNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: getProportionateScreenHeight(70),
      color: CustomColors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: getProportionateScreenHeight(70),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: widget.currentIndex == 0
                            ? CustomColors.primary
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        widget.currentIndex == 0
                            ? Icons.home_filled
                            : Icons.home_outlined,
                        color: widget.currentIndex == 0
                            ? CustomColors.primary
                            : CustomColors.black,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: widget.currentIndex == 0
                              ? CustomColors.primary
                              : CustomColors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    widget.currentIndex = 0;
                  });
                  context.read<IndexCubit>().updateIndex(0);
                }),
          ),
          Expanded(
            child: GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: getProportionateScreenHeight(70),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: widget.currentIndex == 1
                            ? CustomColors.primary
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        widget.currentIndex == 1
                            ? Icons.video_collection
                            : Icons.video_collection_outlined,
                        color: widget.currentIndex == 1
                            ? CustomColors.primary
                            : CustomColors.black,
                      ),
                      Text(
                        'My Reels',
                        style: TextStyle(
                          color: widget.currentIndex == 1
                              ? CustomColors.primary
                              : CustomColors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    widget.currentIndex = 1;
                  });
                  context.read<IndexCubit>().updateIndex(1);
                }),
          ),
          Expanded(
            child: GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: getProportionateScreenHeight(70),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: widget.currentIndex == 2
                            ? CustomColors.primary
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        widget.currentIndex == 2
                            ? Icons.person
                            : Icons.person_outline,
                        color: widget.currentIndex == 2
                            ? CustomColors.primary
                            : CustomColors.black,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: widget.currentIndex == 2
                              ? CustomColors.primary
                              : CustomColors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    widget.currentIndex = 2;
                  });
                  context.read<IndexCubit>().updateIndex(2);
                }),
          ),
        ],
      ),
    );
  }
}
