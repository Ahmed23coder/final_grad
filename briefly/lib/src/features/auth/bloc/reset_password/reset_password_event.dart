import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordNewPasswordChanged extends ResetPasswordEvent {
  final String password;
  const ResetPasswordNewPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ResetPasswordConfirmChanged extends ResetPasswordEvent {
  final String confirmPassword;
  const ResetPasswordConfirmChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  const ResetPasswordSubmitted();
}
