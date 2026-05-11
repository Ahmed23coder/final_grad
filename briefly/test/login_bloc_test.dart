import 'package:bloc_test/bloc_test.dart';
import 'package:briefly/src/domain/repositories/auth_repository.dart';
import 'package:briefly/src/features/auth/bloc/login/login_bloc.dart';
import 'package:briefly/src/features/auth/bloc/login/login_event.dart';
import 'package:briefly/src/features/auth/bloc/login/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginBloc', () {
    late AuthRepository repo;

    setUp(() {
      repo = _MockAuthRepository();
    });

    blocTest<LoginBloc, LoginState>(
      'emits loading then success when login succeeds',
      build: () {
        when(
          () => repo.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});
        return LoginBloc(authRepository: repo);
      },
      act: (bloc) {
        bloc.add(const LoginEmailChanged('a@b.com'));
        bloc.add(const LoginPasswordChanged('Abcdef1!'));
        bloc.add(const LoginSubmitted());
      },
      expect: () => [
        isA<LoginState>().having((s) => s.email, 'email', 'a@b.com'),
        isA<LoginState>().having((s) => s.password, 'password', 'Abcdef1!'),
        isA<LoginState>().having(
          (s) => s.status,
          'status',
          LoginStatus.loading,
        ),
        isA<LoginState>().having(
          (s) => s.status,
          'status',
          LoginStatus.success,
        ),
      ],
      verify: (_) {
        verify(
          () => repo.login(email: 'a@b.com', password: 'Abcdef1!'),
        ).called(1);
      },
    );
  });
}
