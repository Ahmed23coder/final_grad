import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/news_article.dart';
import '../../domain/models/hot_topic_filter.dart';
import '../../features/home/presentation/screens/hot_topics_screen.dart';
import '../../features/auth/presentation/screens/auth_success_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/interests_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/onboarding/presentation/splash_page.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/article_detail_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/ai_tools/presentation/fact_check_screen.dart';
import '../../features/ai_tools/presentation/summarize_screen.dart';
import '../../features/notifications/views/notifications_screen.dart';
import '../../features/profile/views/profile_screen.dart';
import '../../features/saved/presentation/saved_screen.dart';
import '../../features/profile/views/reset_password/profile_reset_password_screen.dart';
import '../../features/profile/views/edit/edit_profile_screen.dart';
import '../../features/profile/views/language_screen.dart';
import '../../features/profile/views/privacy_security/privacy_security_screen.dart';
import '../../features/subscription/subscription_hub_view.dart';
import '../../features/subscription/upgrade_plan_view.dart';
import '../../features/subscription/manage_subscription_view.dart';
import '../../features/subscription/restore_purchases_view.dart';
import '../../features/subscription/payment_methods_view.dart';
import '../../features/subscription/confirmation_view.dart';
import '../../features/profile/views/reading_history/reading_history_screen.dart';
import '../../features/profile/views/help_support/help_support_screen.dart';
import '../../features/profile/cubits/edit/edit_profile_cubit.dart';
import '../../features/profile/cubits/privacy_security/privacy_security_cubit.dart';
import '../../features/profile/cubits/help_support/help_support_cubit.dart';
import '../../domain/repositories/profile_repository.dart';

import '../../features/profile/views/app_settings/app_settings_screen.dart';
import '../../features/profile/views/about/about_screen.dart';
import '../../features/profile/cubits/app_settings/app_settings_cubit.dart';
import '../../features/profile/cubits/about/about_cubit.dart';

import '../../core/widgets/navigation/app_shell.dart';

class AppRouter {
  // Onboarding
  static const String splash = '/splash';
  static const String bootstrap = '/bootstrap';
  static const String onboarding = '/onboarding';

  // Auth
  static const String login = '/auth';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String otp = '/auth/otp';
  static const String resetPassword = '/auth/reset-password';
  static const String interests = '/auth/interests';
  static const String authSuccess = '/auth/success';

  // Notifications
  static const String notifications = '/notifications';
  static const String readingHistory = '/history';
  static const String myChannels = '/channels';
  static const String appSettings = '/settings';
  static const String about = '/about';

  // Main
  static const String shell = '/main';
  static const String search = '/search';
  static const String summarize = '/summarize';
  static const String factCheck = '/fact-check';
  static const String vault = '/vault';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String language = '/profile/language';
  static const String profileResetPassword = '/profile/reset-password';
  static const String privacySecurity = '/profile/privacy-security';
  static const String helpSupport = '/profile/help-support';
  static const String subscription = '/profile/subscription';
  static const String subscriptionUpgrade = '/profile/subscription/upgrade';
  static const String subscriptionManage = '/profile/subscription/manage';
  static const String restore = '/profile/subscription/restore';
  static const String payment = '/profile/subscription/payment';
  static const String confirmation = '/profile/subscription/confirmation';
  static const String saved = '/vault';

  static const String hotTopics = '/hot-topics';

  static GoRouter createRouter(SharedPreferences prefs) {
    return GoRouter(
      initialLocation: splash,
      redirect: (context, state) {
        try {
          final session = Supabase.instance.client.auth.currentSession;
          final location = state.matchedLocation;
          final onboardingComplete =
              prefs.getBool('onboarding_complete') ?? false;

          // Splash is visual-only; let it proceed to bootstrap
          if (location == splash) return null;

          // Bootstrap determines the actual destination
          if (location == bootstrap) {
            if (session != null) return shell;
            return onboardingComplete ? login : onboarding;
          }

          // Always allow onboarding
          if (location == onboarding) return null;

          // Auth routes allowed without session
          if (location.startsWith('/auth')) return null;

          // No session -> go to login (except already on auth routes)
          if (session == null) {
            return login;
          }

          // Logged in -> redirect away from login
          if (location == login) return shell;

          return null;
        } catch (e) {
          // On any error (including auth issues), go to login
          final location = state.matchedLocation;
          if (location == splash || location == bootstrap) {
            final onboardingComplete =
                prefs.getBool('onboarding_complete') ?? false;
            return onboardingComplete ? login : onboarding;
          }
          return login;
        }
      },
      routes: [
        GoRoute(path: splash, builder: (context, state) => const SplashPage()),
        GoRoute(
          path: bootstrap,
          builder: (context, state) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(path: login, builder: (context, state) => const LoginScreen()),
        GoRoute(
          path: signup,
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: otp,
          builder: (context, state) {
            final isFromSignup = state.extra as bool? ?? false;
            return OtpScreen(isFromSignup: isFromSignup);
          },
        ),
        GoRoute(
          path: resetPassword,
          builder: (context, state) => const ResetPasswordScreen(),
        ),
        GoRoute(
          path: interests,
          builder: (context, state) => const InterestsScreen(),
        ),
        GoRoute(
          path: authSuccess,
          builder: (context, state) => const AuthSuccessScreen(),
        ),

        // Stateful Shell for Main App
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShell(navigationShell: navigationShell);
          },
          branches: [
            // Branch 0: Home
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: shell,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            // Branch 1: Search
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: search,
                  builder: (context, state) => const SearchScreen(),
                ),
              ],
            ),
            // Branch 2: Summarize
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: summarize,
                  builder: (context, state) => const SummarizeScreen(),
                ),
              ],
            ),
            // Branch 3: Fact Check
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: factCheck,
                  builder: (context, state) => const FactCheckScreen(),
                ),
              ],
            ),
            // Branch 4: Vault
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: vault,
                  builder: (context, state) => const SavedScreen(isTab: true),
                ),
              ],
            ),
            // Branch 5: Profile
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: profile,
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),

        GoRoute(
          path: hotTopics,
          builder: (context, state) {
            final filterName = state.extra as String?;
            final filter = filterName != null
                ? HotTopicFilter.values.firstWhere(
                    (e) => e.name == filterName,
                    orElse: () => HotTopicFilter.all,
                  )
                : HotTopicFilter.all;
            return HotTopicsView(initialFilter: filter);
          },
        ),
        GoRoute(
          path: '/article/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final article = state.extra as NewsArticle?;
            return ArticleDetailScreen(id: id, article: article);
          },
        ),
        GoRoute(
          path: notifications,
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: readingHistory,
          builder: (context, state) => const ReadingHistoryScreen(),
        ),
        GoRoute(
          path: myChannels,
          builder: (context, state) => const Center(
            child: Text(
              'My Channels - Coming Soon',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        GoRoute(
          path: appSettings,
          builder: (context, state) => BlocProvider(
            create: (context) => AppSettingsCubit(),
            child: const AppSettingsScreen(),
          ),
        ),
        GoRoute(
          path: about,
          builder: (context, state) => BlocProvider(
            create: (context) => AboutCubit(),
            child: const AboutScreen(),
          ),
        ),

        // Profile Sub-routes
        GoRoute(
          path: editProfile,
          builder: (context, state) => BlocProvider(
            create: (context) =>
                EditProfileCubit(context.read<ProfileRepository>()),
            child: const EditProfileScreen(),
          ),
        ),
        GoRoute(
          path: language,
          builder: (context, state) => const LanguageScreen(),
        ),
        GoRoute(
          path: profileResetPassword,
          builder: (context, state) => const ProfileResetPasswordScreen(),
        ),
        GoRoute(
          path: privacySecurity,
          builder: (context, state) => BlocProvider(
            create: (context) => PrivacySecurityCubit(),
            child: const PrivacySecurityScreen(),
          ),
        ),
        GoRoute(
          path: helpSupport,
          builder: (context, state) => BlocProvider(
            create: (context) => HelpSupportCubit(Supabase.instance.client),
            child: const HelpSupportScreen(),
          ),
        ),
        GoRoute(
          path: subscription,
          builder: (context, state) => const SubscriptionHubView(),
        ),
        GoRoute(
          path: subscriptionUpgrade,
          builder: (context, state) => const UpgradePlanView(),
        ),
        GoRoute(
          path: subscriptionManage,
          builder: (context, state) => const ManageSubscriptionView(),
        ),
        GoRoute(
          path: restore,
          builder: (context, state) => const RestorePurchasesView(),
        ),
        GoRoute(
          path: payment,
          builder: (context, state) => const PaymentMethodsView(),
        ),
        GoRoute(
          path: confirmation,
          builder: (context, state) => const ConfirmationView(),
        ),
      ],
    );
  }
}
