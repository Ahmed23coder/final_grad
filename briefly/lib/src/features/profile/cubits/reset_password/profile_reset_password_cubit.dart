import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_reset_password_state.dart';

class ProfileResetPasswordCubit extends Cubit<ProfileResetPasswordState> {
  ProfileResetPasswordCubit() : super(const ProfileResetPasswordState());

  void updateCurrentPassword(String value) =>
      emit(state.copyWith(currentPassword: value));

  void updateNewPassword(String value) =>
      emit(state.copyWith(newPassword: value));

  void updateConfirmPassword(String value) =>
      emit(state.copyWith(confirmPassword: value));

  void toggleCurrentVisible() =>
      emit(state.copyWith(isCurrentVisible: !state.isCurrentVisible));

  void toggleNewVisible() =>
      emit(state.copyWith(isNewVisible: !state.isNewVisible));

  void toggleConfirmVisible() =>
      emit(state.copyWith(isConfirmVisible: !state.isConfirmVisible));

  Future<void> submit() async {
    if (!state.isValid) return;

    emit(state.copyWith(isSaving: true));

    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 1500));

    emit(state.copyWith(isSaving: false, isSaved: true));
  }
}
