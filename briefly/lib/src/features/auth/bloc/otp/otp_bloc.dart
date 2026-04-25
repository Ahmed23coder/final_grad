import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/auth_error_mapper.dart';
import '../../../../domain/repositories/auth_repository.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AuthRepository _authRepository;
  StreamSubscription<int>? _timerSubscription;

  OtpBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const OtpState()) {
    on<OtpCodeChanged>(_onCodeChanged);
    on<OtpVerifySubmitted>(_onVerifySubmitted);
    on<OtpResendRequested>(_onResendRequested);
    on<OtpTimerTicked>(_onTimerTicked);

    _startTimer();
  }

  void _startTimer() {
    _timerSubscription?.cancel();
    _timerSubscription =
        Stream.periodic(
          const Duration(seconds: 1),
          (tick) => 59 - tick,
        ).take(60).listen(
          (remaining) {
            if (isClosed) return;
            add(OtpTimerTicked(remaining));
          },
          cancelOnError: true,
        );
  }

  void _onCodeChanged(OtpCodeChanged event, Emitter<OtpState> emit) {
    emit(state.copyWith(code: event.code, status: OtpStatus.initial));
  }

  void _onTimerTicked(OtpTimerTicked event, Emitter<OtpState> emit) {
    emit(state.copyWith(remainingSeconds: event.remainingSeconds));
  }

  Future<void> _onVerifySubmitted(
    OtpVerifySubmitted event,
    Emitter<OtpState> emit,
  ) async {
    if (!state.isComplete) return;

    emit(state.copyWith(status: OtpStatus.loading));

    try {
      await _authRepository.verifyOtp(code: state.code);
      emit(state.copyWith(status: OtpStatus.success));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: OtpStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }

  Future<void> _onResendRequested(
    OtpResendRequested event,
    Emitter<OtpState> emit,
  ) async {
    emit(state.copyWith(status: OtpStatus.resendLoading));
    try {
      await _authRepository.resendOtp();
      emit(
        state.copyWith(status: OtpStatus.resendSuccess, remainingSeconds: 60),
      );
      _startTimer();
      // Reset back to initial so state can be re-triggered later if needed
      emit(state.copyWith(status: OtpStatus.initial));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: OtpStatus.error,
          errorMessage: () => AuthErrorMapper.toUserMessage(e, stackTrace: st),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}
