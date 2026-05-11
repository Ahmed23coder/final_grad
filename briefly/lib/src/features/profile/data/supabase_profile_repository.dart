import 'dart:developer' as developer;
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/models/subscription_plan.dart';
import '../../../domain/models/payment_method.dart';
import '../../../domain/models/purchase_record.dart';
import '../../../domain/repositories/profile_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  final SupabaseClient _client;

  SupabaseProfileRepository(this._client);

  @override
  UserProfile get currentProfile {
    final user = _client.auth.currentUser;
    if (user == null) return const UserProfile();

    final metadata = user.userMetadata ?? {};
    
    return UserProfile(
      id: user.id,
      name: metadata['full_name'] ?? metadata['name'] ?? '',
      email: user.email ?? '',
      fullName: metadata['full_name'] ?? '',
      phone: metadata['phone'] ?? '',
      username: metadata['username'] ?? user.email?.split('@').first ?? '',
      avatarUrl: metadata['avatar_url'] ?? '',
      bio: metadata['bio'],
      membership: metadata['membership'] ?? 'Basic Member',
      subscriptionPlanId: metadata['subscription_plan_id'] ?? 'free',
      articlesRead: metadata['articles_read'] ?? 0,
      vaultSaved: metadata['vault_saved'] ?? 0,
      aiSummaries: metadata['ai_summaries'] ?? 0,
      selectedInterests: List<String>.from(metadata['interests'] ?? []),
      twitter: metadata['twitter_handle'] ?? '',
      instagram: metadata['instagram_handle'] ?? '',
      website: metadata['website_url'] ?? '',
    );
  }

  @override
  Future<UserProfile> getProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return const UserProfile();

    try {
      final dataFuture = _client.from('profiles').select().eq('id', user.id).single();
      
      final readingHistoryFuture = _client
          .from('reading_history')
          .select('id')
          .eq('user_id', user.id);
          
      final savedArticlesFuture = _client
          .from('saved_articles')
          .select('id')
          .eq('user_id', user.id);

      final subscriptionFuture = _client
          .from('user_subscriptions')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      final interestsFuture = _client
          .from('user_interests')
          .select('categories(name)')
          .eq('user_id', user.id);

      final results = await Future.wait<dynamic>([
        dataFuture,
        readingHistoryFuture,
        savedArticlesFuture,
        subscriptionFuture,
        interestsFuture,
      ]);

      final data = results[0] as Map<String, dynamic>;
      final readingHistoryResponse = results[1] as List;
      final savedArticlesResponse = results[2] as List;
      final subscriptionData = results[3] as Map<String, dynamic>?;
      final interestsData = results[4] as List;

      // Fetch ai_summaries count separately so a failure doesn't break other counters
      int aiSummariesCount = 0;
      try {
        final aiSummariesResponse = await _client
            .from('ai_summaries')
            .select('id')
            .eq('user_id', user.id);
        aiSummariesCount = (aiSummariesResponse as List).length;
      } catch (_) {}
      
      final interests = interestsData
          .map((item) => (item['categories'] as Map)['name'] as String)
          .toList();

      return UserProfile(
        id: data['id'],
        name: data['display_name'] ?? '',
        email: data['email'] ?? '',
        fullName: data['display_name'] ?? '',
        phone: data['phone'] ?? '',
        username: data['username'] ?? '',
        avatarUrl: data['avatar_url'] ?? '',
        bio: data['bio'],
        membership: subscriptionData != null 
            ? (subscriptionData['tier'] == 'free' ? 'Basic Member' : 'Premium Member')
            : 'Basic Member',
        subscriptionPlanId: subscriptionData?['tier'] ?? 'free',
        articlesRead: readingHistoryResponse.length,
        vaultSaved: savedArticlesResponse.length,
        aiSummaries: aiSummariesCount,
        selectedInterests: interests,
        twitter: data['twitter_handle'] ?? '',
        instagram: data['instagram_handle'] ?? '',
        website: data['website_url'] ?? '',
        location: data['location'],
        dateOfBirth: data['date_of_birth'] != null ? DateTime.parse(data['date_of_birth']) : null,
        isNotificationsEnabled: data['is_notifications_enabled'] ?? true,
        isDarkMode: data['is_dark_mode'] ?? true,
        textSize: data['text_size'] ?? 'medium',
        autoPlayVideos: data['auto_play_videos'] ?? true,
        downloadOverWifiOnly: data['download_over_wifi_only'] ?? true,
        isBiometricEnabled: data['is_biometric_enabled'] ?? false,
        isTwoFactorEnabled: data['is_two_factor_enabled'] ?? false,
        isDataSharingEnabled: data['is_data_sharing_enabled'] ?? false,
        isProfilePublic: data['is_profile_public'] ?? true,
        onboardingStatus: data['onboarding_status'] ?? 'not_started',
        onboardingStep: data['onboarding_step'] ?? 0,
        language: data['language'] ?? 'en',
      );
    } catch (e) {
      return currentProfile; // Fallback to auth metadata
    }
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    // Update profiles table.
    //
    // This can fail with PostgrestException 42501 (RLS) when the row does not
    // yet exist for this user and the INSERT policy is missing on the
    // `profiles` table. Swallow the failure here so that toggles / preference
    // saves never crash the UI — the auth metadata update below still
    // persists the change for the current session, and a server-side trigger
    // (recommended) should backfill the row on signup.
    try {
      await _client.from('profiles').upsert({
        'id': user.id,
        'display_name': profile.fullName,
        'phone': profile.phone,
        'username': profile.username,
        'bio': profile.bio,
        'avatar_url': profile.avatarUrl,
        'twitter_handle': profile.twitter,
        'instagram_handle': profile.instagram,
        'website_url': profile.website,
        'location': profile.location,
        'date_of_birth':
            profile.dateOfBirth?.toIso8601String().split('T').first,
        'is_notifications_enabled': profile.isNotificationsEnabled,
        'is_dark_mode': profile.isDarkMode,
        'text_size': profile.textSize,
        'auto_play_videos': profile.autoPlayVideos,
        'download_over_wifi_only': profile.downloadOverWifiOnly,
        'is_biometric_enabled': profile.isBiometricEnabled,
        'is_two_factor_enabled': profile.isTwoFactorEnabled,
        'is_data_sharing_enabled': profile.isDataSharingEnabled,
        'is_profile_public': profile.isProfilePublic,
        'onboarding_status': profile.onboardingStatus,
        'onboarding_step': profile.onboardingStep,
        'language': profile.language,
      }, onConflict: 'id');
    } on PostgrestException catch (e, st) {
      developer.log(
        'profiles upsert failed (likely RLS) — falling back to auth metadata',
        name: 'profile',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      developer.log(
        'profiles upsert failed unexpectedly',
        name: 'profile',
        error: e,
        stackTrace: st,
      );
    }

    // Also update auth metadata for redundancy/legacy support.
    try {
      await _client.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': profile.fullName,
            'phone': profile.phone,
            'username': profile.username,
            'bio': profile.bio,
            'avatar_url': profile.avatarUrl,
            'twitter_handle': profile.twitter,
            'instagram_handle': profile.instagram,
            'website_url': profile.website,
            'is_notifications_enabled': profile.isNotificationsEnabled,
            'is_dark_mode': profile.isDarkMode,
            'text_size': profile.textSize,
            'language': profile.language,
          },
        ),
      );
    } catch (e, st) {
      developer.log(
        'auth.updateUser failed',
        name: 'profile',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    return SubscriptionPlan.plans;
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods() async {
    return [];
  }

  @override
  Future<void> addPaymentMethod(PaymentMethod method) async {}

  @override
  Future<void> deletePaymentMethod(String id) async {}

  @override
  Future<void> setDefaultPaymentMethod(String id) async {}

  @override
  Future<List<PurchaseRecord>> getPurchaseHistory() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client
        .from('user_subscriptions')
        .select()
        .eq('user_id', user.id);

    return (data as List).map((json) {
      return PurchaseRecord(
        id: json['id'],
        planId: json['tier'],
        planName: json['tier'] == 'premium' ? 'Premium Plan' : (json['tier'] == 'annual' ? 'Annual Plan' : 'Free Plan'),
        amount: json['tier'] == 'premium' ? 9.99 : (json['tier'] == 'annual' ? 99.99 : 0.0),
        purchaseDate: DateTime.parse(json['start_date']),
        status: json['status'],
      );
    }).toList();
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final file = File(filePath);
    final ext = filePath.split('.').last;
    final path = '${user.id}/avatar.$ext';

    await _client.storage.from('avatars').upload(
      path,
      file,
      fileOptions: const FileOptions(upsert: true),
    );

    final publicUrl = _client.storage.from('avatars').getPublicUrl(path);

    // Persist the new URL to the profiles table and auth metadata
    await saveProfile(currentProfile.copyWith(avatarUrl: publicUrl));

    return publicUrl;
  }

  @override
  Future<void> upgradePlan(String planId) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    // Upsert subscription
    await _client.from('user_subscriptions').upsert({
      'user_id': user.id,
      'tier': planId,
      'status': 'active',
      'start_date': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id');

    await _client.auth.updateUser(
      UserAttributes(data: {'subscription_plan_id': planId, 'membership': planId == 'free' ? 'Basic Member' : 'Premium Member'}),
    );
  }
}
