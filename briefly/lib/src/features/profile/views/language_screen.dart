import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_radius.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import '../cubits/profile_cubit.dart';
import '../cubits/profile_state.dart';

/// Available application languages (Hardcoded per spec).
const List<Map<String, String>> _availableLanguages = [
  {
    'code': 'en',
    'flag': '🇺🇸',
    'name': 'English',
    'native': 'English',
  },
  {
    'code': 'ar',
    'flag': '🇸🇦',
    'name': 'Arabic',
    'native': 'العربية',
  },
];

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1️⃣ Header
            _Header(),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: context.scaleHeight(32), // pb-32 clearance
                ),
                child: PageEntranceAnimation(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2️⃣ Info Text
                      _InfoText(),

                      // 3️⃣ Language List (Single Card)
                      _LanguageList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// 1️⃣ HEADER
// ─────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(20),
        right: context.scaleWidth(20),
        top: context.scaleHeight(14), // pt-14
        bottom: context.scaleHeight(8), // pb-2
      ),
      child: Row(
        children: [
          // Back Button
          PressScaleAnimation(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.all(context.scaleWidth(8)), // p-2
              decoration: BoxDecoration(
                color: AppColors.foreground.withValues(alpha: 0.05), // bg-white/5
                border: Border.all(
                  color: AppColors.foreground.withValues(alpha: 0.08), // border-white/8
                ),
                borderRadius: BorderRadius.circular(AppRadius.pillValue), // 50px
              ),
              child: Icon(
                LucideIcons.arrowLeft,
                size: context.scaleWidth(18),
                color: const Color(0xFFC0C0C0), // Explicit design spec #C0C0C0
              ),
            ),
          ),
          SizedBox(width: context.scaleWidth(12)), // gap-3
          // Title
          Text(
            'Language',
            style: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.w700,
              fontSize: context.scaleFontSize(24),
              color: AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// 2️⃣ INFO TEXT
// ─────────────────────────────────────────────────────────────────

class _InfoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(28), // px-5 + inner px-2 from outer scope
        right: context.scaleWidth(28),
        bottom: context.scaleHeight(16), // mb-4
      ),
      child: Text(
        'Select the language for app interface.',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: context.scaleFontSize(10),
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// 3️⃣ LANGUAGE LIST
// ─────────────────────────────────────────────────────────────────

class _LanguageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppRadius.settingsGroupValue), // 28px
              border: Border.all(color: AppColors.borderColor),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.settingsGroupValue),
              child: Column(
                children: _availableLanguages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final lang = entry.value;
                  final isLast = index == _availableLanguages.length - 1;
                  final isSelected = state.language == lang['name'];

                  return Column(
                    children: [
                      _LanguageRow(
                        flag: lang['flag']!,
                        name: lang['name']!,
                        nativeName: lang['native']!,
                        isSelected: isSelected,
                        onTap: () {
                          context.read<ProfileCubit>().setLanguage(lang['name']!);
                        },
                      ),
                      if (!isLast)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.borderColor,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final String flag;
  final String name;
  final String nativeName;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageRow({
    required this.flag,
    required this.name,
    required this.nativeName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.foreground.withValues(alpha: 0.05),
        highlightColor: AppColors.foreground.withValues(alpha: 0.03), // hover:bg-white/3 approximation
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.scaleWidth(20), // px-5
            vertical: context.scaleHeight(16), // py-4
          ),
          child: Row(
            children: [
              // Left: Flag emoji
              Text(
                flag,
                style: TextStyle(
                  fontSize: context.scaleFontSize(20), // text-xl approx
                ),
              ),
              SizedBox(width: context.scaleWidth(16)), // gap-4

              // Center: Names
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: context.scaleFontSize(14), // text-sm
                        color: AppColors.foreground, // white
                      ),
                    ),
                    Text(
                      nativeName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: context.scaleFontSize(11), // text-[11px]
                        color: AppColors.mutedForeground, // text-muted-foreground
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Selected Indicator
              if (isSelected)
                Container(
                  width: context.scaleWidth(24), // w-6
                  height: context.scaleWidth(24), // h-6
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFC0C0C0), // bg-[#C0C0C0]
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    LucideIcons.check,
                    size: context.scaleWidth(14), // size-14
                    color: const Color(0xFF102A43), // text-[#102A43]
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


