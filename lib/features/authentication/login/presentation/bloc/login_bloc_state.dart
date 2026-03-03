part of 'login_bloc.dart';

enum LoginBlocStatus { initial, loading, success, failure }

class LoginBlocState extends Equatable {
  const LoginBlocState({
    required this.status,
    this.user,
    this.error,
  });

  final LoginBlocStatus status;
  final User? user;
  final String? error;

  @override
  List<Object?> get props => [status, error];

  LoginBlocState copyWith({
    LoginBlocStatus? status,
    User? user,
    String? error,
  }) {
    return LoginBlocState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
