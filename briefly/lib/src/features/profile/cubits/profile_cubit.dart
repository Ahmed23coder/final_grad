import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:briefly/src/domain/repositories/profile_repository.dart';
import 'package:briefly/src/domain/models/user_profile.dart';
import 'profile_state.dart';

/// Cubit managing profile-specific lightweight UI states.
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository)
      : super(ProfileState(profile: _repository.currentProfile)) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    final profile = await _repository.getProfile();
    emit(state.copyWith(profile: profile));
  }

  void toggleDarkMode() async {
    final newStatus = !state.darkModeEnabled;
    emit(state.copyWith(darkModeEnabled: newStatus));
    
    // Persist to repository
    final updatedProfile = state.profile.copyWith(isDarkMode: newStatus);
    await _repository.saveProfile(updatedProfile);
  }

  void toggleNotifications() async {
    final newStatus = !state.notificationsEnabled;
    emit(state.copyWith(notificationsEnabled: newStatus));
    
    // Persist to repository
    final updatedProfile = state.profile.copyWith(isNotificationsEnabled: newStatus);
    await _repository.saveProfile(updatedProfile);
  }

  void setLanguage(String lang) async {
    emit(state.copyWith(language: lang));
    // Persist to repository if needed
    final updatedProfile = state.profile.copyWith(onboardingStatus: lang); // Or add language field
    await _repository.saveProfile(updatedProfile);
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _repository.saveProfile(profile);
    emit(state.copyWith(profile: profile));
  }
}
