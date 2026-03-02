import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:mis_mobile/core/di/di.dart';
import 'package:mis_mobile/core/providers/IndexCubit/index_cubit.dart';
import 'package:mis_mobile/features/authentication/login/presentation/bloc/login_bloc.dart';
import 'package:mis_mobile/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mis_mobile/features/menu/profile/presentation/cubit/profile_cubit.dart';
import 'package:mis_mobile/features/onboarding/presentation/cubit/onboarding_cubit.dart';

List<SingleChildWidget> blocs = [
  BlocProvider<LoginBloc>(
    create: (context) => sl<LoginBloc>(),
  ),
  BlocProvider<IndexCubit>(
    create: (context) => sl<IndexCubit>(),
  ),
  BlocProvider<MenuCubit>(
    create: (context) => sl<MenuCubit>(),
  ),
  BlocProvider<OnboardingCubit>(
    create: (context) => sl<OnboardingCubit>(),
  ),
  BlocProvider<ProfileCubit>(
    create: (context) => sl<ProfileCubit>(),
  ),
];
