import 'package:equatable/equatable.dart';
import 'package:country_picker/country_picker.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupFullNameChanged extends SignupEvent {
  final String fullName;
  const SignupFullNameChanged(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class SignupEmailChanged extends SignupEvent {
  final String email;
  const SignupEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class SignupPhoneChanged extends SignupEvent {
  final String phone;
  const SignupPhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class SignupCountryChanged extends SignupEvent {
  final Country country;
  const SignupCountryChanged(this.country);

  @override
  List<Object?> get props => [country];
}

class SignupGenderChanged extends SignupEvent {
  final String gender;
  const SignupGenderChanged(this.gender);

  @override
  List<Object?> get props => [gender];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;
  const SignupPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class SignupConfirmPasswordChanged extends SignupEvent {
  final String confirmPassword;
  const SignupConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class SignupPasswordVisibilityToggled extends SignupEvent {
  const SignupPasswordVisibilityToggled();
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();
}

class SignupGoogleRequested extends SignupEvent {
  const SignupGoogleRequested();
}

class SignupFacebookRequested extends SignupEvent {
  const SignupFacebookRequested();
}

class SignupAppleRequested extends SignupEvent {
  const SignupAppleRequested();
}
