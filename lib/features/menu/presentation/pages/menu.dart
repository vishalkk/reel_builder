import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loggy/loggy.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/box_decorations.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';
import 'package:mis_mobile/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mis_mobile/features/menu/presentation/cubit/menu_state.dart';
import 'package:mis_mobile/features/widgets/menu/item_tile.dart';
import 'package:mis_mobile/features/widgets/page_templates/template.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Template(
          text: AppStrings.menu,
          subText: "",
          child: Expanded(
              child: BlocConsumer<MenuCubit, MenuState>(
                  listenWhen: (previous, current) =>
                      previous.selectedRoute != current.selectedRoute,
                  listener: (context, state) {
                    if (state.selectedRoute != null) {
                      logDebug(state.selectedRoute);
                      Navigator.pushNamed(context, state.selectedRoute!);
                      context.read<MenuCubit>().clearRoute();
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: AppSize.s30.h),
                          child: Center(
                            child: Container(
                              width: AppSize.s300.w,
                              height: AppSize.s230.h,
                              decoration: BoxDecorations.tileDecoration(),
                              child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSize.s18.h,
                                  ),
                                  itemCount: state.items.length,
                                  separatorBuilder: (context, index) =>
                                      Divider(),
                                  itemBuilder: (context, index) {
                                    return ItemTile(
                                        icon:
                                            state.items.values.elementAt(index),
                                        title:
                                            state.items.keys.elementAt(index),
                                        onTap: () {
                                          context.read<MenuCubit>().selectItem(
                                              state.items.keys
                                                  .elementAt(index));
                                        });
                                  }),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: AppSize.s300.w,
                          height: AppSize.s60.h,
                          decoration: BoxDecorations.tileDecoration(),
                          child: ItemTile(
                            icon: Icons.logout,
                            title: AppStrings.logout,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          height: AppSize.s16.h,
                        ),
                      ],
                    );
                  }))),
    );
  }
}
