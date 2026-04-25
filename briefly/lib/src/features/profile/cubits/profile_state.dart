import 'package:equatable/equatable.dart';
import 'package:briefly/src/domain/models/user_profile.dart';

/// Lightweight UI state for the Profile tab.
class ProfileState extends Equatable {
  final UserProfile profile;
  final bool darkModeEnabled;
  final bool notificationsEnabled;
  final String language;

  const ProfileState({
    this.profile = const UserProfile(),
    this.darkModeEnabled = true,
    this.notificationsEnabled = false,
    this.language = 'English',
  });

  ProfileState copyWith({
    UserProfile? profile,
    bool? darkModeEnabled,
    bool? notificationsEnabled,
    String? language,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [darkModeEnabled, notificationsEnabled, language];
}
