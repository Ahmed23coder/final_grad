import 'package:equatable/equatable.dart';
import 'package:briefly/src/domain/models/payment_method.dart';
import 'package:briefly/src/domain/models/purchase_record.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String? bio;
  final String fullName;
  final String membership;
  final String subscriptionPlanId;
  final int articlesRead;
  final int vaultSaved;
  final int aiSummaries;
  final String username;
  final String phone;
  final String twitter;
  final String instagram;
  final String website;
  final String? location;
  final DateTime? dateOfBirth;
  final List<String> selectedInterests;
  final List<PaymentMethod> paymentMethods;
  final List<PurchaseRecord> purchaseHistory;
  
  // Preferences
  final bool isNotificationsEnabled;
  final bool isDarkMode;
  final String textSize;
  final bool autoPlayVideos;
  final bool downloadOverWifiOnly;
  
  // Security & Privacy
  final bool isBiometricEnabled;
  final bool isTwoFactorEnabled;
  final bool isDataSharingEnabled;
  final bool isProfilePublic;
  
  // Onboarding
  final String onboardingStatus;
  final int onboardingStep;
  final String language;

  const UserProfile({
    this.id = '',
    this.name = '',
    this.email = '',
    this.avatarUrl = '',
    this.bio,
    this.fullName = '',
    this.membership = 'Basic Member',
    this.subscriptionPlanId = 'free',
    this.articlesRead = 0,
    this.vaultSaved = 0,
    this.aiSummaries = 0,
    this.username = '',
    this.phone = '',
    this.twitter = '',
    this.instagram = '',
    this.website = '',
    this.location,
    this.dateOfBirth,
    this.selectedInterests = const [],
    this.paymentMethods = const [],
    this.purchaseHistory = const [],
    this.isNotificationsEnabled = true,
    this.isDarkMode = true,
    this.textSize = 'medium',
    this.autoPlayVideos = true,
    this.downloadOverWifiOnly = true,
    this.isBiometricEnabled = false,
    this.isTwoFactorEnabled = false,
    this.isDataSharingEnabled = false,
    this.isProfilePublic = true,
    this.onboardingStatus = 'not_started',
    this.onboardingStep = 0,
    this.language = 'en',
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? bio,
    String? fullName,
    String? membership,
    String? subscriptionPlanId,
    int? articlesRead,
    int? vaultSaved,
    int? aiSummaries,
    String? username,
    String? phone,
    String? twitter,
    String? instagram,
    String? website,
    String? location,
    DateTime? dateOfBirth,
    List<String>? selectedInterests,
    List<PaymentMethod>? paymentMethods,
    List<PurchaseRecord>? purchaseHistory,
    bool? isNotificationsEnabled,
    bool? isDarkMode,
    String? textSize,
    bool? autoPlayVideos,
    bool? downloadOverWifiOnly,
    bool? isBiometricEnabled,
    bool? isTwoFactorEnabled,
    bool? isDataSharingEnabled,
    bool? isProfilePublic,
    String? onboardingStatus,
    int? onboardingStep,
    String? language,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      fullName: fullName ?? this.fullName,
      membership: membership ?? this.membership,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
      articlesRead: articlesRead ?? this.articlesRead,
      vaultSaved: vaultSaved ?? this.vaultSaved,
      aiSummaries: aiSummaries ?? this.aiSummaries,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      twitter: twitter ?? this.twitter,
      instagram: instagram ?? this.instagram,
      website: website ?? this.website,
      location: location ?? this.location,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      purchaseHistory: purchaseHistory ?? this.purchaseHistory,
      isNotificationsEnabled: isNotificationsEnabled ?? this.isNotificationsEnabled,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      textSize: textSize ?? this.textSize,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
      downloadOverWifiOnly: downloadOverWifiOnly ?? this.downloadOverWifiOnly,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      isDataSharingEnabled: isDataSharingEnabled ?? this.isDataSharingEnabled,
      isProfilePublic: isProfilePublic ?? this.isProfilePublic,
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
      onboardingStep: onboardingStep ?? this.onboardingStep,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        bio,
        fullName,
        membership,
        subscriptionPlanId,
        articlesRead,
        vaultSaved,
        aiSummaries,
        username,
        phone,
        twitter,
        instagram,
        website,
        location,
        dateOfBirth,
        selectedInterests,
        paymentMethods,
        purchaseHistory,
        isNotificationsEnabled,
        isDarkMode,
        textSize,
        autoPlayVideos,
        downloadOverWifiOnly,
        isBiometricEnabled,
        isTwoFactorEnabled,
        isDataSharingEnabled,
        isProfilePublic,
        onboardingStatus,
        onboardingStep,
        language,
      ];
}
