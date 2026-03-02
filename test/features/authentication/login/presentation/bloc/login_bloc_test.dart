import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mis_mobile/core/Network/failure.dart';
import 'package:mis_mobile/features/authentication/login/domain/entities/user.dart';
import 'package:mis_mobile/features/authentication/login/domain/usecase/login_usecase.dart';
import 'package:mis_mobile/features/authentication/login/presentation/bloc/login_bloc.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class FakeLoginUseCaseInput extends Fake implements LoginUseCaseInput {}

void main() {
  group("login bloc", () {
    late LoginBloc loginBloc;
    late MockLoginUseCase mockLoginUseCase;

    const errorMessage = "Not Found Error";
    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      registerFallbackValue(FakeLoginUseCaseInput());

      loginBloc = LoginBloc(loginUseCase: mockLoginUseCase);
    });

    blocTest<LoginBloc, LoginBlocState>(
      'emits [loading, success] when login is successful',
      build: () {
        when(() => mockLoginUseCase.execute(any())).thenAnswer(
          (_) async => Right(User(
            id: "c33e0f07-46f0-43f3-b9e8-6573eba7c757",
            name: 'Virat Kohli',
            message: 'Succesfully login',
            phone: '+233546089781',
            accessToken:
                'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJiUWM4elktbGhMR2pGYzlJM1FpSWJKc0NTZ0RBWU1PemtmR1QwdWFhZGlBIn0.eyJleHAiOjE3MzI1NDkyOTgsImlhdCI6MTczMjUxMzI5OCwianRpIjoiZDc3Y2JlZGQtMjdlNy00ZjA1LTk4MTgtZWM4ZDc4MWJiYjQzIiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3JlYWxtcy9yZW1jYXNoIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6IjZiM2NhNjJiLWYwZjYtNDM1NC04ZDc5LTY1NjA5MjI1ZmZiMSIsInR5cCI6IkJlYXJlciIsImF6cCI6InJlbWNhc2gtY2xpZW50Iiwic2Vzc2lvbl9zdGF0ZSI6Ijc4YmU2MDY5LWEzNTUtNGY2Ni1iMGVjLTAzY2U0ZWRjODIyMCIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiKiJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsImRlZmF1bHQtcm9sZXMtcmVtY2FzaCJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwiLCJzaWQiOiI3OGJlNjA2OS1hMzU1LTRmNjYtYjBlYy0wM2NlNGVkYzgyMjAiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInByZWZlcnJlZF91c2VybmFtZSI6ImMzM2UwZjA3LTQ2ZjAtNDNmMy1iOWU4LTY1NzNlYmE3Yzc1NyJ9.L-ktplSprv0w8_t_D7mM1lAaSIC4DFtSDq1pedliDN3_yPiU5gzFLhSwu03GklZ4Wr9OcI1JFs5lwG_BBgemEzZsMr4jTPzC1gs7i1lOojAWzRyWMOKoEqAC8eLyVLMYcSGqrVAgJnN5bKd01VfgvCjgOlgpNZYZL9yHTt3XYr0NCckocB9e_xdQUp8UooUgUdF2oSJHwaC6XCdSC5BQeL8jjT0Y1L1lOlEeQ8gDJMZ0tH1Z7apo37XtGouToAaGTv71tqD-Xix54oKxaVBcH9Au_769FLkQ6DRmvltpM0UtkfMV9z6roAytroCQZvjbGUIoj8Ufp1qr7scVudkHSQ',
            refreshToken:
                'eyJhbGciOiJIUzUxMiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI3OGFkYjQ3Mi1mOTEyLTQyMzktOTQzMy00YjhkYTE3OGU3NzcifQ.eyJleHAiOjE3MzI1MTUwOTgsImlhdCI6MTczMjUxMzI5OCwianRpIjoiNTdkZjMyNzctYTk4NC00MGQ5LTg2MzctMmViZDE2NWJiOWZlIiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3JlYWxtcy9yZW1jYXNoIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3JlYWxtcy9yZW1jYXNoIiwic3ViIjoiNmIzY2E2MmItZjBmNi00MzU0LThkNzktNjU2MDkyMjVmZmIxIiwidHlwIjoiUmVmcmVzaCIsImF6cCI6InJlbWNhc2gtY2xpZW50Iiwic2Vzc2lvbl9zdGF0ZSI6Ijc4YmU2MDY5LWEzNTUtNGY2Ni1iMGVjLTAzY2U0ZWRjODIyMCIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwiLCJzaWQiOiI3OGJlNjA2OS1hMzU1LTRmNjYtYjBlYy0wM2NlNGVkYzgyMjAifQ.Pe8N9pQrh6n7MILxRHRA-7C3Mi-US8KNBoq2X1yCSUJVRNCW2kPwDmTZZeVcO-KTvY7_ewg_51KA2tdQXvR-kg',
            expiresIn: 120,
            refreshExpiresIn: 120,
          )),
        );
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginSubmitted(
        countryCode: '+233',
        phoneNumber: '123456789',
        password: 'password123',
      )),
      expect: () => [
        LoginBlocState(status: LoginBlocStatus.loading),
        LoginBlocState(status: LoginBlocStatus.success),
      ],
    );

    blocTest<LoginBloc, LoginBlocState>(
      'emits [loading, failure] when login fails',
      build: () {
        when(() => mockLoginUseCase.execute(any())).thenAnswer(
          (_) async => Left(Failure(
            404,
            errorMessage,
          )),
        );
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginSubmitted(
        countryCode: '+233',
        phoneNumber: '123456789',
        password: 'password123',
      )),
      expect: () => [
        const LoginBlocState(status: LoginBlocStatus.loading),
        const LoginBlocState(
          status: LoginBlocStatus.failure,
          error: errorMessage,
        ),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase.execute(any())).called(1);
      },
    );
  });
}
