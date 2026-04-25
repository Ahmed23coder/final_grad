import 'package:equatable/equatable.dart';

class PrivacySecurityState extends Equatable {
  final bool twoFactorEnabled;
  final bool loginAlertsEnabled;
  final bool biometricsEnabled;
  
  final bool publicProfileEnabled;
  final bool activityStatusEnabled;
  final bool readReceiptsEnabled;
  
  final bool analyticsEnabled;
  final bool personalizedAdsEnabled;

  const PrivacySecurityState({
    this.twoFactorEnabled = false,
    this.loginAlertsEnabled = true,
    this.biometricsEnabled = true,
    this.publicProfileEnabled = false,
    this.activityStatusEnabled = true,
    this.readReceiptsEnabled = true,
    this.analyticsEnabled = true,
    this.personalizedAdsEnabled = false,
  });

  PrivacySecurityState copyWith({
    bool? twoFactorEnabled,
    bool? loginAlertsEnabled,
    bool? biometricsEnabled,
    bool? publicProfileEnabled,
    bool? activityStatusEnabled,
    bool? readReceiptsEnabled,
    bool? analyticsEnabled,
    bool? personalizedAdsEnabled,
  }) {
    return PrivacySecurityState(
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      loginAlertsEnabled: loginAlertsEnabled ?? this.loginAlertsEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      publicProfileEnabled: publicProfileEnabled ?? this.publicProfileEnabled,
      activityStatusEnabled: activityStatusEnabled ?? this.activityStatusEnabled,
      readReceiptsEnabled: readReceiptsEnabled ?? this.readReceiptsEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      personalizedAdsEnabled: personalizedAdsEnabled ?? this.personalizedAdsEnabled,
    );
  }

  @override
  List<Object?> get props => [
        twoFactorEnabled,
        loginAlertsEnabled,
        biometricsEnabled,
        publicProfileEnabled,
        activityStatusEnabled,
        readReceiptsEnabled,
        analyticsEnabled,
        personalizedAdsEnabled,
      ];
}
