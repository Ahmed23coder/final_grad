import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit() : super(const AppSettingsState());

  // Appearance
  void toggleDarkMode(bool value) => emit(state.copyWith(darkMode: value));
  void toggleCompactMode(bool value) => emit(state.copyWith(compactMode: value));
  void toggleShowArticleImages(bool value) => emit(state.copyWith(showArticleImages: value));

  // Font Size
  void updateFontSize(AppFontSize fontSize) => emit(state.copyWith(fontSize: fontSize));

  // Notifications
  void toggleBreakingNewsAlerts(bool value) => emit(state.copyWith(breakingNewsAlerts: value));
  void toggleDailyDigest(bool value) => emit(state.copyWith(dailyDigest: value));
  void toggleWeeklyRecap(bool value) => emit(state.copyWith(weeklyRecap: value));
  void toggleSoundEffects(bool value) => emit(state.copyWith(soundEffects: value));

  // Language
  void updateLanguage(AppLanguage language) => emit(state.copyWith(language: language));

  // Content & Feed
  void toggleAutoPlayVideos(bool value) => emit(state.copyWith(autoPlayVideos: value));
  void toggleOpenLinksInApp(bool value) => emit(state.copyWith(openLinksInApp: value));
  void updateRefreshRate(FeedRefreshRate rate) => emit(state.copyWith(refreshRate: rate));

  // Data & Storage
  void toggleWifiOnlyMedia(bool value) => emit(state.copyWith(wifiOnlyMedia: value));
  void toggleAutoDownloadArticles(bool value) => emit(state.copyWith(autoDownloadArticles: value));
  void toggleOfflineReading(bool value) => emit(state.copyWith(offlineReading: value));

  // Cache
  Future<void> clearCache() async {
    // Simulate cache clearing process
    emit(state.copyWith(isCacheCleared: true, cacheSize: '0.0 MB'));
    
    // Auto-hide success state after 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(isCacheCleared: false));
  }
}
