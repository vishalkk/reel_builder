import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mis_mobile/core/providers/IndexCubit/index_cubit.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';
import 'package:mis_mobile/features/menu/presentation/pages/menu.dart';
import 'package:mis_mobile/features/presentation/dashboard.dart';
import 'package:mis_mobile/features/widgets/custom_bottom_nav.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bottom nav pages
    var pages = const [
      Dashboard(),
      Menu(),
    ];

    return BlocBuilder<IndexCubit, int>(
      builder: (context, currentIndex) {
        final int safeIndex = currentIndex.clamp(0, pages.length - 1);
        return Scaffold(
          body: SafeArea(
            child: Container(
              width: getProportionateScreenWidth(390),
              height: getProportionateScreenHeight(887),
              color: CustomColors.mainBg.withOpacity(0.5),
              child: pages[safeIndex],
            ),
          ),
          bottomNavigationBar: CustomBottomNav(
            currentIndex: safeIndex,
          ),
        );
      },
    );
  }
}
