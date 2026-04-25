import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class OtpCodeChanged extends OtpEvent {
  final String code;
  const OtpCodeChanged(this.code);

  @override
  List<Object?> get props => [code];
}

class OtpVerifySubmitted extends OtpEvent {
  const OtpVerifySubmitted();
}

class OtpResendRequested extends OtpEvent {
  const OtpResendRequested();
}

class OtpTimerTicked extends OtpEvent {
  final int remainingSeconds;
  const OtpTimerTicked(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}
