import 'package:equatable/equatable.dart';

enum AppFontSize { small, defaultSize, large, extraLarge }

enum AppLanguage { english, arabic, french, spanish, german }

enum FeedRefreshRate { fiveMin, fifteenMin, thirtyMin, hourly, manual }

class AppSettingsState extends Equatable {
  // Appearance
  final bool darkMode;
  final bool compactMode;
  final bool showArticleImages;

  // Reading
  final AppFontSize fontSize;

  // Notifications
  final bool breakingNewsAlerts;
  final bool dailyDigest;
  final bool weeklyRecap;
  final bool soundEffects;

  // Language & Region
  final AppLanguage language;

  // Content & Feed
  final bool autoPlayVideos;
  final bool openLinksInApp;
  final FeedRefreshRate refreshRate;

  // Data & Storage
  final bool wifiOnlyMedia;
  final bool autoDownloadArticles;
  final bool offlineReading;

  // Cache
  final String cacheSize;
  final bool isCacheCleared;

  const AppSettingsState({
    this.darkMode = true,
    this.compactMode = false,
    this.showArticleImages = true,
    this.fontSize = AppFontSize.defaultSize,
    this.breakingNewsAlerts = true,
    this.dailyDigest = true,
    this.weeklyRecap = false,
    this.soundEffects = true,
    this.language = AppLanguage.english,
    this.autoPlayVideos = true,
    this.openLinksInApp = true,
    this.refreshRate = FeedRefreshRate.fifteenMin,
    this.wifiOnlyMedia = true,
    this.autoDownloadArticles = false,
    this.offlineReading = false,
    this.cacheSize = '248.5 MB',
    this.isCacheCleared = false,
  });

  AppSettingsState copyWith({
    bool? darkMode,
    bool? compactMode,
    bool? showArticleImages,
    AppFontSize? fontSize,
    bool? breakingNewsAlerts,
    bool? dailyDigest,
    bool? weeklyRecap,
    bool? soundEffects,
    AppLanguage? language,
    bool? autoPlayVideos,
    bool? openLinksInApp,
    FeedRefreshRate? refreshRate,
    bool? wifiOnlyMedia,
    bool? autoDownloadArticles,
    bool? offlineReading,
    String? cacheSize,
    bool? isCacheCleared,
  }) {
    return AppSettingsState(
      darkMode: darkMode ?? this.darkMode,
      compactMode: compactMode ?? this.compactMode,
      showArticleImages: showArticleImages ?? this.showArticleImages,
      fontSize: fontSize ?? this.fontSize,
      breakingNewsAlerts: breakingNewsAlerts ?? this.breakingNewsAlerts,
      dailyDigest: dailyDigest ?? this.dailyDigest,
      weeklyRecap: weeklyRecap ?? this.weeklyRecap,
      soundEffects: soundEffects ?? this.soundEffects,
      language: language ?? this.language,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
      openLinksInApp: openLinksInApp ?? this.openLinksInApp,
      refreshRate: refreshRate ?? this.refreshRate,
      wifiOnlyMedia: wifiOnlyMedia ?? this.wifiOnlyMedia,
      autoDownloadArticles: autoDownloadArticles ?? this.autoDownloadArticles,
      offlineReading: offlineReading ?? this.offlineReading,
      cacheSize: cacheSize ?? this.cacheSize,
      isCacheCleared: isCacheCleared ?? this.isCacheCleared,
    );
  }

  @override
  List<Object?> get props => [
        darkMode,
        compactMode,
        showArticleImages,
        fontSize,
        breakingNewsAlerts,
        dailyDigest,
        weeklyRecap,
        soundEffects,
        language,
        autoPlayVideos,
        openLinksInApp,
        refreshRate,
        wifiOnlyMedia,
        autoDownloadArticles,
        offlineReading,
        cacheSize,
        isCacheCleared,
      ];
}
