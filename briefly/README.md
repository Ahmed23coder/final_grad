# briefly

Flutter app.

## Getting Started

### Supabase configuration (required)

This app reads Supabase config from Dart defines.

Run with:

```bash
flutter run --dart-define=SUPABASE_URL=YOUR_URL --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Or using a file:

```bash
flutter run --dart-define-from-file=supabase.json
```

Copy `supabase.json.example` → `supabase.json` and fill in your values.

### Tests

```bash
flutter test
```

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
