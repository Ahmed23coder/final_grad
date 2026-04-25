import 'package:equatable/equatable.dart';

class ProfileResetPasswordState extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  final bool isCurrentVisible;
  final bool isNewVisible;
  final bool isConfirmVisible;

  final bool isSaving;
  final bool isSaved;

  const ProfileResetPasswordState({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isCurrentVisible = false,
    this.isNewVisible = false,
    this.isConfirmVisible = false,
    this.isSaving = false,
    this.isSaved = false,
  });

  bool get isMatchError =>
      newPassword.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      newPassword != confirmPassword;

  bool get isValid =>
      currentPassword.length >= 6 &&
      newPassword.length >= 6 &&
      newPassword == confirmPassword;

  /// Returns strength logic from 0 to 4
  /// Weak <4 chars, Fair 4-7, Good 8-11, Strong 12+
  int get passwordStrength {
    final len = newPassword.length;
    if (len == 0) return 0;
    if (len < 4) return 1; // Weak
    if (len >= 4 && len <= 7) return 2; // Fair
    if (len >= 8 && len <= 11) return 3; // Good
    return 4; // Strong
  }

  ProfileResetPasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isCurrentVisible,
    bool? isNewVisible,
    bool? isConfirmVisible,
    bool? isSaving,
    bool? isSaved,
  }) {
    return ProfileResetPasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isCurrentVisible: isCurrentVisible ?? this.isCurrentVisible,
      isNewVisible: isNewVisible ?? this.isNewVisible,
      isConfirmVisible: isConfirmVisible ?? this.isConfirmVisible,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [
        currentPassword,
        newPassword,
        confirmPassword,
        isCurrentVisible,
        isNewVisible,
        isConfirmVisible,
        isSaving,
        isSaved,
      ];
}
