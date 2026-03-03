import 'package:flutter/material.dart';
import 'package:mis_mobile/core/definition/route_names.dart';
import 'package:mis_mobile/features/authentication/login/presentation/pages/login_screen.dart';
import 'package:mis_mobile/features/home.dart';
import 'package:mis_mobile/features/marketplace/presentation/pages/marketplace_page.dart';
import 'package:mis_mobile/features/menu/account_management/presentation/pages/account_management.dart';
import 'package:mis_mobile/features/menu/presentation/pages/menu.dart';
import 'package:mis_mobile/features/menu/profile/presentation/pages/profile.dart';
import 'package:mis_mobile/features/menu/security/presentation/pages/security.dart';
import 'package:mis_mobile/features/menu/settings/presentation/pages/settings.dart';
import 'package:mis_mobile/features/menu/settings/themes/presentation/pages/themes.dart';
import 'package:mis_mobile/features/my_reels/presentation/pages/my_reels_page.dart';
import 'package:mis_mobile/features/onboarding/presentation/onboarding.dart';
import 'package:mis_mobile/features/profile/presentation/pages/profile_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.onboarding:
        return MaterialPageRoute(
          builder: (_) => const Onboarding(),
          settings: settings,
        );
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const Home(),
          settings: settings,
        );
      case RouteNames.marketplace:
        return MaterialPageRoute(
          builder: (_) => const MarketplacePage(),
          settings: settings,
        );
      case RouteNames.myReels:
        return MaterialPageRoute(
          builder: (_) => const MyReelsPage(),
          settings: settings,
        );
      case RouteNames.profileTab:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );
      case RouteNames.menu:
        return MaterialPageRoute(
          builder: (_) => const Menu(),
          settings: settings,
        );
      case RouteNames.profile:
        return MaterialPageRoute(
          builder: (_) => const Profile(),
          settings: settings,
        );
      case RouteNames.security:
        return MaterialPageRoute(
          builder: (_) => const Security(),
          settings: settings,
        );
      case RouteNames.settings:
        return MaterialPageRoute(
          builder: (_) => const Settings(),
          settings: settings,
        );
      case RouteNames.themes:
        return MaterialPageRoute(
          builder: (_) => const Themes(),
          settings: settings,
        );
      case RouteNames.accountManagement:
        return MaterialPageRoute(
          builder: (_) => const AccountManagement(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Onboarding(),
          settings: settings,
        );
    }
  }
}
