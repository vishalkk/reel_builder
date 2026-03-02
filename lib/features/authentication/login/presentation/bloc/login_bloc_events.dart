part of 'login_bloc.dart';

abstract class LoginBlocEvent extends Equatable {
  const LoginBlocEvent();

  @override
  List<Object?> get props => [];
}
class LoginSubmitted extends LoginBlocEvent {
  final String countryCode;
  final String phoneNumber;
  final String password;

  const LoginSubmitted({
    required this.countryCode,
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [countryCode, phoneNumber, password];
}
