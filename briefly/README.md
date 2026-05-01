# briefly

Flutter news app with AI summarisation, TTS reading, and Supabase auth.

## Getting Started

### Supabase configuration (required)

The app reads Supabase config from Dart defines. The OAuth web redirect must
also be supplied via `SUPABASE_REDIRECT_URL` (mobile uses the
`io.supabase.briefly://login-callback/` deep link declared in
`AndroidManifest.xml` / `Info.plist`).

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY \
  --dart-define=SUPABASE_REDIRECT_URL=https://YOUR_PROJECT.supabase.co/auth/callback
```

Or using a file:

```bash
flutter run --dart-define-from-file=supabase.json
```

Copy `supabase.json.example` → `supabase.json` (gitignored) and fill in
your values.

### Tests

```bash
flutter test
```

## Architecture

```
lib/
  main.dart                 — wiring (Supabase init, MultiRepositoryProvider)
  src/
    core/                   — theming, routing, utils, constants
    domain/                 — models, exceptions, repository interfaces
    features/<feature>/
      data/                 — Supabase-backed repository implementations
      bloc/ or cubits/      — state management
      presentation/         — screens & widgets
```

State management convention:
- **Bloc** for explicit user-action flows (auth, subscription).
- **Cubit** for derived/state-only screens (notifications, profile).

The `lib/src/core/mvvm/` scaffolding is `@deprecated` and used only by
existing subscription view-models; do not add new ones.

## Security checklist (before release)

- [ ] Verify Supabase Row Level Security is **on** for every user-owned
  table (`profiles`, `saved_articles`, `reading_history`) with
  `auth.uid() = user_id` policies for SELECT/INSERT/UPDATE/DELETE.
- [ ] Replace the OAuth custom-scheme deep link with an Android App Link
  (`autoVerify="true"` + `/.well-known/assetlinks.json`) and an iOS
  Universal Link (apple-app-site-association). The current scheme works
  but is hijackable by any app that registers `io.supabase.briefly://`.
- [ ] Confirm `supabase.json` has never been committed:
  `git log -- supabase.json`.
- [ ] Confirm `flutter analyze` is clean (`use_build_context_synchronously`,
  `avoid_print`, `unawaited_futures` are enabled in
  `analysis_options.yaml`).

## Notes

- OTP-flow values (email, type) live in `flutter_secure_storage`
  (Keychain / EncryptedSharedPreferences), not SharedPreferences.
- The app subscribes to `auth.onAuthStateChange` in `_BrieflyAppState` and
  routes back to `/auth` on remote sign-out.
