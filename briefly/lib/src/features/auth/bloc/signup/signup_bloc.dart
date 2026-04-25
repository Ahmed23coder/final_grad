import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/exceptions/auth_exceptions.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/auth_error_mapper.dart';
import '../../../../core/utils/validators.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository _authRepository;

  SignupBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const SignupState()) {
    on<SignupFullNameChanged>(_onFullNameChanged);
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPhoneChanged>(_onPhoneChanged);
    on<SignupCountryChanged>(_onCountryChanged);
    on<SignupGenderChanged>(_onGenderChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignupPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<SignupSubmitted>(_onSubmitted);
    on<SignupGoogleRequested>(_onGoogleRequested);
    on<SignupFacebookRequested>(_onFacebookRequested);
    on<SignupAppleRequested>(_onAppleRequested);
  }

  void _onFullNameChanged(
    SignupFullNameChanged event,
    Emitter<SignupState> emit,
  ) {
    final name = event.fullName;
    final error = Validators.validateName(name);
    emit(
      state.copyWith(
        fullName: name,
        fullNameError: () => error,
        status: SignupStatus.initial,
      ),
    );
  }

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) {
    final email = event.email;
    final error = Validators.validateEmail(email);
    emit(
      state.copyWith(
        email: email,
        emailError: () => error,
        status: SignupStatus.initial,
      ),
    );
  }

  void _onPhoneChanged(SignupPhoneChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(phone: event.phone));
  }

  void _onCountryChanged(
    SignupCountryChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(country: event.country));
  }

  void _onGenderChanged(SignupGenderChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(gender: event.gender));
  }

  void _onPasswordChanged(
    SignupPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final password = event.password;
    final strength = Validators.calculatePasswordStrength(password);
    final error = Validators.validatePassword(password);
    final confirmError = Validators.validateConfirmPassword(
      password,
      state.confirmPassword,
    );
    emit(
      state.copyWith(
        password: password,
        passwordStrength: strength,
        passwordError: () => error,
        confirmPasswordError: () => confirmError,
        status: SignupStatus.initial,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    SignupConfirmPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final confirm = event.confirmPassword;
    final error = Validators.validateConfirmPassword(state.password, confirm);
    emit(
      state.copyWith(
        confirmPassword: confirm,
        confirmPasswordError: () => error,
        status: SignupStatus.initial,
      ),
    );
  }

  void _onPasswordVisibilityToggled(
    SignupPasswordVisibilityToggled event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: SignupStatus.loading));

    try {
      await _authRepository.signup(
        fullName: state.fullName,
        email: state.email,
        phone: state.phone,
        country: state.country?.name ?? '',
        gender: state.gender,
        password: state.password,
      );
      emit(state.copyWith(status: SignupStatus.success));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: SignupStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }

  Future<void> _onGoogleRequested(
    SignupGoogleRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.loading));
    try {
      await _authRepository.signInWithGoogle();
    } on AuthCanceledException {
      emit(state.copyWith(status: SignupStatus.cancelled));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: SignupStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }

  Future<void> _onFacebookRequested(
    SignupFacebookRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.loading));
    try {
      await _authRepository.signInWithFacebook();
    } on AuthCanceledException {
      emit(state.copyWith(status: SignupStatus.cancelled));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: SignupStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }

  Future<void> _onAppleRequested(
    SignupAppleRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.loading));
    try {
      await _authRepository.signInWithApple();
    } on AuthCanceledException {
      emit(state.copyWith(status: SignupStatus.cancelled));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: SignupStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }
}
