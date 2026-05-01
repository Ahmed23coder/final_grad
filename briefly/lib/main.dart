import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/core/theme/app_colors.dart';
import 'src/core/routes/app_router.dart';
import 'src/domain/repositories/auth_repository.dart';
import 'src/features/auth/data/supabase_auth_repository.dart';
import 'src/domain/repositories/news_repository.dart';
import 'src/features/home/data/supabase_news_repository.dart';
import 'src/features/notifications/cubits/notifications_cubit.dart';
import 'src/domain/repositories/profile_repository.dart';
import 'src/features/profile/data/supabase_profile_repository.dart';
import 'src/features/profile/cubits/profile_cubit.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    debugPaintSizeEnabled = false;
    debugPaintBaselinesEnabled = false;
    debugPaintPointersEnabled = false;
    debugPaintLayerBordersEnabled = false;

    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      runApp(
        const _MisconfiguredApp(
          message:
              'Missing Supabase config.\n\nRun with:\n'
              'flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...\n\n'
              'Or:\nflutter run --dart-define-from-file=supabase.json',
        ),
      );
      return;
    }

    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

    final prefs = await SharedPreferences.getInstance();
    runApp(BrieflyApp(prefs: prefs));
  } catch (e, stackTrace) {
    String errorMessage = e.toString();
    if (stackTrace.toString().length > 500) {
      errorMessage = '${e.toString()}\n\nStack trace truncated. Check logs for details.';
    }
    runApp(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Initialization Error:\n$errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BrieflyApp extends StatefulWidget {
  final SharedPreferences prefs;
  const BrieflyApp({super.key, required this.prefs});

  @override
  State<BrieflyApp> createState() => _BrieflyAppState();
}

class _BrieflyAppState extends State<BrieflyApp> {
  late final router = AppRouter.createRouter(widget.prefs);
  late final _textTheme = GoogleFonts.interTextTheme(
    ThemeData.dark().textTheme,
  );
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        router.go(AppRouter.login);
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => SupabaseAuthRepository(prefs: widget.prefs),
        ),
        RepositoryProvider<NewsRepository>(
          create: (context) => SupabaseNewsRepository(Supabase.instance.client),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => SupabaseProfileRepository(Supabase.instance.client),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NotificationsCubit>(
            create: (context) => NotificationsCubit(),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(context.read<ProfileRepository>()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Briefly',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.background,
              brightness: Brightness.dark,
              primary: AppColors.accentBlue,
              secondary: AppColors.primaryAccent,
              error: AppColors.error,
              surface: AppColors.background,
            ),
            scaffoldBackgroundColor: AppColors.background,
            textTheme: _textTheme,
            useMaterial3: true,
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}

class _MisconfiguredApp extends StatelessWidget {
  final String message;
  const _MisconfiguredApp({required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.background,
          brightness: Brightness.dark,
          primary: AppColors.accentBlue,
          secondary: AppColors.primaryAccent,
          error: AppColors.error,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App not configured',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.silverPlaceholder,
                        height: 1.35,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
