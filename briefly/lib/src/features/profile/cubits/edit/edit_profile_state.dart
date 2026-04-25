import 'package:equatable/equatable.dart';

class EditProfileState extends Equatable {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String bio;
  final String twitter;
  final String instagram;
  final String website;
  final List<String> selectedInterests;
  final String membership;

  final bool isSaving;
  final bool isSaved;

  const EditProfileState({
    this.fullName = '',
    this.username = '',
    this.email = '',
    this.phone = '',
    this.bio = '',
    this.twitter = '',
    this.instagram = '',
    this.website = '',
    this.selectedInterests = const [],
    this.membership = 'Free Member',
    this.isSaving = false,
    this.isSaved = false,
  });

  EditProfileState copyWith({
    String? fullName,
    String? username,
    String? email,
    String? phone,
    String? bio,
    String? twitter,
    String? instagram,
    String? website,
    List<String>? selectedInterests,
    String? membership,
    bool? isSaving,
    bool? isSaved,
  }) {
    return EditProfileState(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      twitter: twitter ?? this.twitter,
      instagram: instagram ?? this.instagram,
      website: website ?? this.website,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      membership: membership ?? this.membership,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        username,
        email,
        phone,
        bio,
        twitter,
        instagram,
        website,
        selectedInterests,
        membership,
        isSaving,
        isSaved,
      ];
}
