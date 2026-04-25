import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/exceptions/auth_exceptions.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/auth_error_mapper.dart';
import '../../../../core/utils/validators.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginGoogleRequested>(_onGoogleRequested);
    on<LoginFacebookRequested>(_onFacebookRequested);
    on<LoginAppleRequested>(_onAppleRequested);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = event.email;
    final error = Validators.validateEmail(email);
    emit(
      state.copyWith(
        email: email,
        emailError: () => error,
        status: LoginStatus.initial,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = event.password;
    final error = Validators.validatePassword(password);
    emit(
      state.copyWith(
        password: password,
        passwordError: () => error,
        status: LoginStatus.initial,
      ),
    );
  }

  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      await _authRepository.login(email: state.email, password: state.password);
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }

  Future<void> _onGoogleRequested(
    LoginGoogleRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authRepository.signInWithGoogle();
    } on AuthCanceledException {
      emit(state.copyWith(status: LoginStatus.cancelled));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }

  Future<void> _onFacebookRequested(
    LoginFacebookRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authRepository.signInWithFacebook();
    } on AuthCanceledException {
      emit(state.copyWith(status: LoginStatus.cancelled));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }

  Future<void> _onAppleRequested(
    LoginAppleRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authRepository.signInWithApple();
    } on AuthCanceledException {
      emit(state.copyWith(status: LoginStatus.cancelled));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }
}
