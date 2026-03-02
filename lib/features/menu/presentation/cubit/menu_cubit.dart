import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mis_mobile/core/definition/route_names.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';
import 'package:mis_mobile/features/menu/presentation/cubit/menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuState(items: _getInitialItems()));
  static Map<String, IconData> _getInitialItems() {
    return {
      AppStrings.profile: Icons.person,
      AppStrings.accountManagement: Icons.account_circle_outlined,
      AppStrings.security: Icons.security,
      AppStrings.settings: Icons.settings,
    };
  }

  void selectItem(String title) {
    final route = _getRouteFromTitle(title);
    emit(state.copyWith(selectedRoute: route));
  }

  String _getRouteFromTitle(String title) {
    switch (title) {
      case AppStrings.profile:
        return RouteNames.profile;
      case AppStrings.accountManagement:
        return RouteNames.accountManagement;
      case AppStrings.security:
        return RouteNames.security;
      case AppStrings.settings:
        return RouteNames.settings;
      default:
        return '';
    }
  }

  void clearRoute() => emit(state.copyWith(selectedRoute: null));
}
