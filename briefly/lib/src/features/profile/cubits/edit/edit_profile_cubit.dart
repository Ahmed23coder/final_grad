import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_profile_state.dart';
import 'package:briefly/src/domain/repositories/profile_repository.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ProfileRepository _repository;

  EditProfileCubit(this._repository)
      : super(EditProfileState(
          fullName: _repository.currentProfile.fullName,
          username: _repository.currentProfile.username,
          email: _repository.currentProfile.email,
          phone: _repository.currentProfile.phone,
          bio: _repository.currentProfile.bio ?? '',
          twitter: _repository.currentProfile.twitter,
          instagram: _repository.currentProfile.instagram,
          website: _repository.currentProfile.website,
          selectedInterests: _repository.currentProfile.selectedInterests,
          membership: _repository.currentProfile.membership,
          avatarUrl: _repository.currentProfile.avatarUrl,
        ));

  void updateFullName(String value) => emit(state.copyWith(fullName: value));
  void updateUsername(String value) => emit(state.copyWith(username: value));
  void updateEmail(String value) => emit(state.copyWith(email: value));
  void updatePhone(String value) => emit(state.copyWith(phone: value));
  void updateBio(String value) => emit(state.copyWith(bio: value));
  void updateTwitter(String value) => emit(state.copyWith(twitter: value));
  void updateInstagram(String value) =>
      emit(state.copyWith(instagram: value));
  void updateWebsite(String value) => emit(state.copyWith(website: value));

  void toggleInterest(String interest) {
    final list = List<String>.from(state.selectedInterests);
    if (list.contains(interest)) {
      list.remove(interest);
    } else {
      list.add(interest);
    }
    emit(state.copyWith(selectedInterests: list));
  }

  Future<void> uploadAvatar(String filePath) async {
    emit(state.copyWith(isUploadingAvatar: true));
    try {
      final url = await _repository.uploadAvatar(filePath);
      emit(state.copyWith(isUploadingAvatar: false, avatarUrl: url));
    } catch (e, st) {
      developer.log('avatar upload failed', name: 'edit_profile', error: e, stackTrace: st);
      emit(state.copyWith(isUploadingAvatar: false));
    }
  }

  Future<void> saveProfile() async {
    emit(state.copyWith(isSaving: true));

    final updatedProfile = _repository.currentProfile.copyWith(
      fullName: state.fullName,
      username: state.username,
      email: state.email,
      phone: state.phone,
      bio: state.bio,
      twitter: state.twitter,
      instagram: state.instagram,
      website: state.website,
      selectedInterests: state.selectedInterests,
    );

    await _repository.saveProfile(updatedProfile);

    emit(state.copyWith(isSaving: false, isSaved: true));
  }
}
