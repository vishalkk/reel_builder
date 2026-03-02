import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loggy/loggy.dart';
import 'package:mis_mobile/core/Network/failure.dart';
import 'package:mis_mobile/features/authentication/login/domain/entities/user.dart';
import 'package:mis_mobile/features/authentication/login/domain/usecase/login_usecase.dart';

part 'login_bloc_events.dart';
part 'login_bloc_state.dart';

class LoginBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  final LoginUseCase loginUseCase;
  LoginBloc({required this.loginUseCase})
      : super(const LoginBlocState(
          status: LoginBlocStatus.initial,
        )) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginBlocState> emit) async {
    emit(state.copyWith(status: LoginBlocStatus.loading));

    final Either<Failure, User> result = await loginUseCase.execute(
        LoginUseCaseInput(
            event.countryCode, event.phoneNumber, event.password));

    result.fold(
      (failure) {
        logDebug(
            "this is the failure $result  \n this is the failure message ${failure.message}");
        emit(state.copyWith(
          status: LoginBlocStatus.failure,
          error: failure.message,
        ));
      },
      (user) {
        emit(state.copyWith(status: LoginBlocStatus.success, user: user));
      },
    );
  }
}
