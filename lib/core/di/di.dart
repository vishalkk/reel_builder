// service locator

import 'package:get_it/get_it.dart';
import 'package:mis_mobile/core/Network/dio_factory.dart';
import 'package:mis_mobile/core/Network/network_info.dart';
import 'package:mis_mobile/core/providers/IndexCubit/index_cubit.dart';
import 'package:mis_mobile/core/utils/app_prefs.dart';
import 'package:mis_mobile/features/authentication/login/data/datasources/login_remote_data_source.dart';
import 'package:mis_mobile/features/authentication/login/data/network/login_api.dart';
import 'package:mis_mobile/features/authentication/login/data/repository/login_repository_impl.dart';
import 'package:mis_mobile/features/authentication/login/domain/repositories/login_repository.dart';
import 'package:mis_mobile/features/authentication/login/domain/usecase/login_usecase.dart';
import 'package:mis_mobile/features/authentication/login/presentation/bloc/login_bloc.dart';
import 'package:mis_mobile/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mis_mobile/features/menu/profile/presentation/cubit/profile_cubit.dart';
import 'package:mis_mobile/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:mis_mobile/flavors.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  // register dependencies here
  // Features - login
  sl.registerFactory(() => LoginBloc(
        loginUseCase: sl(),
      ));
  // Use case
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<RemoteLoginDataSource>(
      () => RemoteLoginDataImplementer(sl()));

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton<AppPreferences>(() => AppPreferences(sl()));

  sl.registerFactory(() => IndexCubit());

  sl.registerFactory(() => MenuCubit());

  sl.registerFactory(() => OnboardingCubit());

  sl.registerFactory(() => ProfileCubit());
  // dio factory
  sl.registerLazySingleton<DioFactory>(() => DioFactory(sl()));

  // app  service client
  final dio = await sl<DioFactory>().getDio();
  sl.registerLazySingleton<LoginServiceClient>(
      () => LoginServiceClient(dio, baseUrl: F.baseUrl));
}

Future<void> refreshDioForAuthorizationAndRegisterRelatedServiceClient() async {
  // Intentionally no-op after removing register/auth flows.
}

void resetModules() {
  //TODO: implement reset modules
}
