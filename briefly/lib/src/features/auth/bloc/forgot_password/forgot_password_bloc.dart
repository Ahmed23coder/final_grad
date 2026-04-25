import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/auth_error_mapper.dart';
import '../../../../core/utils/validators.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ForgotPasswordState()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    final email = event.email;
    final error = Validators.validateEmail(email);
    emit(
      state.copyWith(
        email: email,
        emailError: () => error,
        status: ForgotPasswordStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    try {
      await _authRepository.sendPasswordResetCode(email: state.email);
      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }
}
