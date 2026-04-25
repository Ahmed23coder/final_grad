# Profile Feature - Modular Sub-Features

## Architecture Overview

The Profile feature is organized into **5 independent sub-features**, each handling a specific user profile aspect:

### Sub-Features Structure

```
profile/
├── cubits/
│   ├── profile_cubit.dart          # Main profile state (settings)
│   ├── profile_state.dart
│   ├── edit/                       # SUB-FEATURE: Edit Profile
│   │   ├── edit_profile_cubit.dart
│   │   └── edit_profile_state.dart
│   ├── subscription/               # SUB-FEATURE: Subscription Plans
│   │   ├── subscription_cubit.dart
│   │   └── subscription_state.dart
│   ├── reset_password/             # SUB-FEATURE: Password Reset
│   │   ├── profile_reset_password_cubit.dart
│   │   └── profile_reset_password_state.dart
│   ├── privacy_security/           # SUB-FEATURE: Privacy & Security
│   │   ├── privacy_security_cubit.dart
│   │   └── privacy_security_state.dart
│   └── help_support/               # SUB-FEATURE: Help & Support
│       ├── help_support_cubit.dart
│       └── help_support_state.dart
│
├── views/
│   ├── profile_screen.dart         # Main profile view
│   ├── language_screen.dart        # Language selection
│   ├── edit/
│   │   └── edit_profile_screen.dart
│   ├── subscription/
│   │   └── subscription_screen.dart
│   ├── reset_password/
│   │   └── profile_reset_password_screen.dart
│   ├── privacy_security/
│   │   └── privacy_security_screen.dart
│   └── help_support/
│       └── help_support_screen.dart
│
└── models/                         # Feature-scoped models
    ├── plan_type.dart
    └── help_category.dart
```

## Sub-Feature Dependencies

| Sub-Feature | Dependencies | BLoC Count | Complexity |
|---|---|---|---|
| **Edit Profile** | None (local state) | 1 | ⭐⭐ |
| **Subscription** | None (local state) | 1 | ⭐ |
| **Reset Password** | None (local state) | 1 | ⭐⭐ |
| **Privacy Security** | None (local state) | 1 | ⭐⭐ |
| **Help Support** | None (local state) | 1 | ⭐ |

**Total**: 5 independent cubits, 0 cross-feature dependencies

## Implementation Guidelines

### 1. Sub-Feature Isolation
- Each sub-feature has **zero dependencies** on other sub-features
- All sub-features accessed via **route-based navigation** from main profile screen
- State is **not shared** between sub-features

### 2. Data Flow
```
Profile Screen (main)
  ├── Edit Profile Screen → EditProfileCubit
  ├── Subscription Screen → SubscriptionCubit
  ├── Reset Password Screen → ResetPasswordCubit
  ├── Privacy/Security Screen → PrivacySecurityCubit
  └── Help/Support Screen → HelpSupportCubit
```

### 3. Adding New Sub-Features

To add a new sub-feature (e.g., "Notifications Preferences"):

1. Create folder: `cubits/notifications_prefs/`
2. Create `notifications_prefs_cubit.dart` + `notifications_prefs_state.dart`
3. Create folder: `views/notifications_prefs/`
4. Create `notifications_prefs_screen.dart`
5. Add route to `app_router.dart` → `/profile/notifications-prefs`
6. Update `profile_screen.dart` → Add navigation button

### 4. Migration Path (Future)

When the app reaches 25+ features:

```
profile_feature/
├── pubspec.yaml (published separately)
├── lib/
│   └── [same structure]
└── test/
    └── [tests]
```

Then import as: `package:profile_feature`

## Testing Strategy

- Unit tests for each cubit (Edit, Subscription, etc.)
- Integration tests for route navigation
- Mock repositories if/when connected to backend
- No cross-cubit dependencies to test

## Performance Considerations

- ✅ Lazy loading: Sub-features only loaded when routed to
- ✅ No global state: Each cubit is independent
- ✅ Memory efficient: Cubits disposed on route exit
- ⚠️ Future: Consider provider caching for frequent routes

## Notes

- Main `ProfileCubit` handles only app-level profile settings (dark mode, language, notifications)
- Sub-features handle specialized profile sections
- All states are local and immutable
- Use `context.scaleWidth()/scaleHeight()` for responsive sizing
