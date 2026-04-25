import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus { initial, loading, success, error }

class ForgotPasswordState extends Equatable {
  final String email;
  final String? emailError;
  final ForgotPasswordStatus status;
  final String? errorMessage;

  const ForgotPasswordState({
    this.email = '',
    this.emailError,
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
  });

  bool get isFormValid => email.isNotEmpty && emailError == null;

  ForgotPasswordState copyWith({
    String? email,
    String? Function()? emailError,
    ForgotPasswordStatus? status,
    String? Function()? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailError: emailError != null ? emailError() : this.emailError,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, emailError, status, errorMessage];
}
