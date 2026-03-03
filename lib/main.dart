import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loggy/loggy.dart';
import 'package:mis_mobile/blocs.dart';
import 'package:mis_mobile/core/definition/route_names.dart';
import 'package:mis_mobile/core/definition/routes.dart';
import 'package:mis_mobile/core/di/di.dart';
import 'package:mis_mobile/core/theme/premium_theme.dart';
// import 'package:mis_mobile/firebase.dart';
import 'package:mis_mobile/flavors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeFirebaseApp(F.appFlavor);
  await dotenv.load(fileName: F.env);
  // initialize DI
  await init();

  Loggy.initLoggy();

  runApp(
    DevicePreview(
      enabled: false,
      // enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<
    PageRoute>(); //will be used to listen to the routes, mainly for the onboarding

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocs,
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: F.title,
            theme: PremiumTheme.theme,
            initialRoute: RouteNames.onboarding,
            navigatorObservers: [routeObserver],
            onGenerateRoute: RouteGenerator.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
