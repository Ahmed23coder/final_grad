import 'package:equatable/equatable.dart';
import 'package:country_picker/country_picker.dart';

enum SignupStatus { initial, loading, success, error, cancelled }

class SignupState extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final Country? country;
  final String gender;
  final String password;
  final String confirmPassword;
  final int passwordStrength;
  final bool isPasswordVisible;
  final String? fullNameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final SignupStatus status;
  final String? errorMessage;

  const SignupState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.country,
    this.gender = '',
    this.password = '',
    this.confirmPassword = '',
    this.passwordStrength = 0,
    this.isPasswordVisible = false,
    this.fullNameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.status = SignupStatus.initial,
    this.errorMessage,
  });

  bool get isFormValid =>
      fullName.isNotEmpty &&
      email.isNotEmpty &&
      phone.isNotEmpty &&
      country != null &&
      gender.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      fullNameError == null &&
      emailError == null &&
      passwordError == null &&
      confirmPasswordError == null;

  SignupState copyWith({
    String? fullName,
    String? email,
    String? phone,
    Country? country,
    String? gender,
    String? password,
    String? confirmPassword,
    int? passwordStrength,
    bool? isPasswordVisible,
    String? Function()? fullNameError,
    String? Function()? emailError,
    String? Function()? passwordError,
    String? Function()? confirmPasswordError,
    SignupStatus? status,
    String? Function()? errorMessage,
  }) {
    return SignupState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      passwordStrength: passwordStrength ?? this.passwordStrength,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      fullNameError: fullNameError != null
          ? fullNameError()
          : this.fullNameError,
      emailError: emailError != null ? emailError() : this.emailError,
      passwordError: passwordError != null
          ? passwordError()
          : this.passwordError,
      confirmPasswordError: confirmPasswordError != null
          ? confirmPasswordError()
          : this.confirmPasswordError,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    country,
    gender,
    password,
    confirmPassword,
    passwordStrength,
    isPasswordVisible,
    fullNameError,
    emailError,
    passwordError,
    confirmPasswordError,
    status,
    errorMessage,
  ];
}
