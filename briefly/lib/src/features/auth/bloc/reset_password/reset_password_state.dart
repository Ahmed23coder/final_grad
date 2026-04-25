import 'package:equatable/equatable.dart';

enum ResetPasswordStatus { initial, loading, success, error }

class ResetPasswordState extends Equatable {
  final String password;
  final String confirmPassword;
  final int strength;
  final String? passwordError;
  final String? confirmError;
  final ResetPasswordStatus status;
  final String? errorMessage;

  const ResetPasswordState({
    this.password = '',
    this.confirmPassword = '',
    this.strength = 0,
    this.passwordError,
    this.confirmError,
    this.status = ResetPasswordStatus.initial,
    this.errorMessage,
  });

  bool get isFormValid =>
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      passwordError == null &&
      confirmError == null &&
      password == confirmPassword;

  ResetPasswordState copyWith({
    String? password,
    String? confirmPassword,
    int? strength,
    String? Function()? passwordError,
    String? Function()? confirmError,
    ResetPasswordStatus? status,
    String? Function()? errorMessage,
  }) {
    return ResetPasswordState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      strength: strength ?? this.strength,
      passwordError: passwordError != null
          ? passwordError()
          : this.passwordError,
      confirmError: confirmError != null ? confirmError() : this.confirmError,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    password,
    confirmPassword,
    strength,
    passwordError,
    confirmError,
    status,
    errorMessage,
  ];
}
