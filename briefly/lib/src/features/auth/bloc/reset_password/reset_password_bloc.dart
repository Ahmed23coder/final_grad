import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/auth_error_mapper.dart';
import '../../../../core/utils/validators.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository _authRepository;

  ResetPasswordBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ResetPasswordState()) {
    on<ResetPasswordNewPasswordChanged>(_onPasswordChanged);
    on<ResetPasswordConfirmChanged>(_onConfirmChanged);
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  void _onPasswordChanged(
    ResetPasswordNewPasswordChanged event,
    Emitter<ResetPasswordState> emit,
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
        strength: strength,
        passwordError: () => error,
        confirmError: () => confirmError,
        status: ResetPasswordStatus.initial,
      ),
    );
  }

  void _onConfirmChanged(
    ResetPasswordConfirmChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    final confirm = event.confirmPassword;
    final error = Validators.validateConfirmPassword(state.password, confirm);

    emit(
      state.copyWith(
        confirmPassword: confirm,
        confirmError: () => error,
        status: ResetPasswordStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: ResetPasswordStatus.loading));

    try {
      await _authRepository.resetPassword(newPassword: state.password);
      emit(state.copyWith(status: ResetPasswordStatus.success));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }
}
