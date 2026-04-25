import 'package:equatable/equatable.dart';

enum OtpStatus {
  initial,
  loading,
  success,
  error,
  resendLoading,
  resendSuccess,
}

class OtpState extends Equatable {
  final String code;
  final int remainingSeconds;
  final OtpStatus status;
  final String? errorMessage;

  const OtpState({
    this.code = '',
    this.remainingSeconds = 60,
    this.status = OtpStatus.initial,
    this.errorMessage,
  });

  bool get isComplete => code.length == 6;
  bool get canResend => remainingSeconds == 0;

  String get formattedTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  OtpState copyWith({
    String? code,
    int? remainingSeconds,
    OtpStatus? status,
    String? Function()? errorMessage,
  }) {
    return OtpState(
      code: code ?? this.code,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [code, remainingSeconds, status, errorMessage];
}
