import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor {
  dev,
  uat,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'MyApp Dev';
      case Flavor.uat:
        return 'MyApp UAT';
      case Flavor.prod:
        return 'MyApp';
      default:
        return 'title';
    }
  }

  static String get env {
    switch (appFlavor) {
      case Flavor.dev:
        return '.env.dev';
      case Flavor.uat:
        return '.env.uat';
      case Flavor.prod:
        return '.env.prod';
      default:
        return 'title';
    }
  }

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
}
