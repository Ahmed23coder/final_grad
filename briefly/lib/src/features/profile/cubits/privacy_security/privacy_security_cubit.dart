import 'package:flutter_bloc/flutter_bloc.dart';
import 'privacy_security_state.dart';

class PrivacySecurityCubit extends Cubit<PrivacySecurityState> {
  PrivacySecurityCubit() : super(const PrivacySecurityState());

  void toggleTwoFactor() {
    emit(state.copyWith(twoFactorEnabled: !state.twoFactorEnabled));
  }

  void toggleLoginAlerts() {
    emit(state.copyWith(loginAlertsEnabled: !state.loginAlertsEnabled));
  }

  void toggleBiometrics() {
    emit(state.copyWith(biometricsEnabled: !state.biometricsEnabled));
  }

  void togglePublicProfile() {
    emit(state.copyWith(publicProfileEnabled: !state.publicProfileEnabled));
  }

  void toggleActivityStatus() {
    emit(state.copyWith(activityStatusEnabled: !state.activityStatusEnabled));
  }

  void toggleReadReceipts() {
    emit(state.copyWith(readReceiptsEnabled: !state.readReceiptsEnabled));
  }

  void toggleAnalytics() {
    emit(state.copyWith(analyticsEnabled: !state.analyticsEnabled));
  }

  void togglePersonalizedAds() {
    emit(state.copyWith(personalizedAdsEnabled: !state.personalizedAdsEnabled));
  }
}
