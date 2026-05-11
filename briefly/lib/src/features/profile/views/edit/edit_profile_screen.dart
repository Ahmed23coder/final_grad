import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_radius.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import '../../cubits/edit/edit_profile_cubit.dart';
import '../../cubits/edit/edit_profile_state.dart';
import 'package:briefly/src/core/widgets/avatar_fallback.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Midnight Navy
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 2ï¸âƒ£ Header
            _Header(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: context.scaleWidth(20),
                  right: context.scaleWidth(20),
                  bottom: context.scaleHeight(40), // pb-10
                ),
                child: Column(
                  children: [
                    // 3ï¸âƒ£ Avatar Section (Delay 0s)
                    PageEntranceAnimation(
                      delay: Duration.zero,
                      slideOffset: 10,
                      child: _AvatarSection(),
                    ),
                    SizedBox(height: context.scaleHeight(24)),

                    // 4ï¸âƒ£ Personal Info Section (Delay 0.07s)
                    PageEntranceAnimation(
                      delay: const Duration(milliseconds: 70),
                      slideOffset: 12,
                      child: _PersonalInfoSection(),
                    ),
                    SizedBox(height: context.scaleHeight(24)),

                    // 5ï¸âƒ£ Bio Section (Delay 0.12s)
                    PageEntranceAnimation(
                      delay: const Duration(milliseconds: 120),
                      slideOffset: 12,
                      child: _BioSection(),
                    ),
                    SizedBox(height: context.scaleHeight(24)),

                    // 6ï¸âƒ£ Social Links Section (Delay 0.16s)
                    PageEntranceAnimation(
                      delay: const Duration(milliseconds: 160),
                      slideOffset: 12,
                      child: _SocialLinksSection(),
                    ),
                    SizedBox(height: context.scaleHeight(24)),

                    // 7ï¸âƒ£ Interests Section (Delay 0.20s)
                    PageEntranceAnimation(
                      delay: const Duration(milliseconds: 200),
                      slideOffset: 12,
                      child: _InterestsSection(),
                    ),
                    SizedBox(height: context.scaleHeight(32)),

                    // 8ï¸âƒ£ Save Button (Delay 0.25s)
                    PageEntranceAnimation(
                      delay: const Duration(milliseconds: 250),
                      slideOffset: 12,
                      child: _SaveButton(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// HEADER
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(20),
        right: context.scaleWidth(20),
        top: context.scaleHeight(14),
        bottom: context.scaleHeight(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Back Button
          PressScaleAnimation(
            onTap: () => context.pop(),
            child: Container(
              width: context.scaleWidth(40),
              height: context.scaleWidth(40),
              decoration: BoxDecoration(
                color: AppColors.foreground.withValues(alpha: 0.06), // bg-white/6
                border: Border.all(
                  color: AppColors.foreground.withValues(alpha: 0.10), // border-white/10
                ),
                borderRadius: BorderRadius.circular(AppRadius.pillValue),
              ),
              alignment: Alignment.center,
              child: Icon(
                LucideIcons.arrowLeft,
                size: context.scaleWidth(18),
                color: const Color(0xFFC0C0C0), // silver
              ),
            ),
          ),

          // Center: Title
          Text(
            'Edit Profile',
            style: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.w700,
              fontSize: context.scaleFontSize(20),
              color: AppColors.foreground,
            ),
          ),

          // Right: Save Status Button
          BlocBuilder<EditProfileCubit, EditProfileState>(
            builder: (context, state) {
              return Container(
                width: context.scaleWidth(40),
                height: context.scaleWidth(40),
                decoration: BoxDecoration(
                  color: const Color(0xFFC0C0C0).withValues(alpha: 0.15),
                  border: Border.all(
                    color: const Color(0xFFC0C0C0).withValues(alpha: 0.20),
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.pillValue),
                ),
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Icon(
                    LucideIcons.check,
                    key: ValueKey<bool>(state.isSaved),
                    size: context.scaleWidth(18),
                    color: state.isSaved
                        ? const Color(0xFFC0C0C0)
                        : const Color(0xFFC0C0C0).withValues(alpha: 0.5),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// AVATAR SECTION
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _AvatarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.scaleHeight(24)), // py-6
      child: Column(
        children: [
          // Avatar Stack
          Stack(
            clipBehavior: Clip.none,
            children: [
              BlocBuilder<EditProfileCubit, EditProfileState>(
                buildWhen: (a, b) =>
                    a.fullName != b.fullName ||
                    a.email != b.email ||
                    a.avatarUrl != b.avatarUrl ||
                    a.isUploadingAvatar != b.isUploadingAvatar,
                builder: (context, state) {
                  if (state.isUploadingAvatar) {
                    return SizedBox(
                      width: context.scaleWidth(96),
                      height: context.scaleWidth(96),
                      child: const CircularProgressIndicator(),
                    );
                  }
                  return AvatarFallback(
                    name: state.fullName.isNotEmpty
                        ? state.fullName
                        : state.email,
                    avatarUrl: state.avatarUrl.isNotEmpty ? state.avatarUrl : null,
                    size: context.scaleWidth(96),
                    borderColor:
                        const Color(0xFFC0C0C0).withValues(alpha: 0.3),
                  );
                },
              ),
              // Camera Button
              Positioned(
                bottom: -context.scaleHeight(4), // -bottom-1
                right: -context.scaleWidth(4), // -right-1
                child: PressScaleAnimation(
                  onTap: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );
                    if (picked != null && context.mounted) {
                      unawaited(context.read<EditProfileCubit>().uploadAvatar(picked.path));
                    }
                  },
                  scaleOnPress: 0.95,
                  child: Container(
                    width: context.scaleWidth(32), // w-8
                    height: context.scaleWidth(32), // h-8
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFC0C0C0), // solid silver
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      LucideIcons.camera,
                      size: context.scaleWidth(14),
                      color: const Color(0xFF102A43), // navy
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaleHeight(12)),

          // Helper Text
          Text(
            'Tap to change photo',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: context.scaleFontSize(12), // text-xs
              color: const Color(0xFFC0C0C0).withValues(alpha: 0.5), // silver/50
            ),
          ),
          SizedBox(height: context.scaleHeight(16)),

          // Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.scaleWidth(12),
              vertical: context.scaleHeight(4),
            ),
            decoration: BoxDecoration(
              color: AppColors.foreground.withValues(alpha: 0.05), // bg-white/5
              border: Border.all(
                color: AppColors.foreground.withValues(alpha: 0.08), // border-white/8
              ),
              borderRadius: BorderRadius.circular(AppRadius.pillValue), // 50px
            ),
            child: Text(
              context.watch<EditProfileCubit>().state.membership,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: context.scaleFontSize(10), // 10px
                color: const Color(0xFFC0C0C0).withValues(alpha: 0.6), // silver/60
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// SHARED FIELD COMPONENTS
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(12),
        bottom: context.scaleHeight(10),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: context.scaleFontSize(10),
          letterSpacing: 1.5, // tracking-widest approx
          color: const Color(0xFFC0C0C0).withValues(alpha: 0.5), // silver/50
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(12),
        bottom: context.scaleHeight(6),
        top: context.scaleHeight(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: context.scaleFontSize(12),
          color: AppColors.foreground.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class _PillInput extends StatelessWidget {
  final String placeholder;
  final String initialValue;
  final IconData? prefixIcon;
  final ValueChanged<String> onChanged;

  const _PillInput({
    required this.placeholder,
    required this.initialValue,
    this.prefixIcon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: context.scaleFontSize(14), // text-sm
        color: AppColors.foreground, // white
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
          color: AppColors.foreground.withValues(alpha: 0.3),
        ),
        filled: true,
        fillColor: AppColors.foreground.withValues(alpha: 0.05), // bg-white/5
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: const Color(0xFFC0C0C0).withValues(alpha: 0.6),
                size: context.scaleWidth(18),
              )
            : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.scaleWidth(prefixIcon != null ? 16 : 20), // pl-9 roughly via icon padding natively
          vertical: context.scaleHeight(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pillValue),
          borderSide: BorderSide(
            color: AppColors.foreground.withValues(alpha: 0.10), // border-white/10
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pillValue),
          borderSide: BorderSide(
            color: const Color(0xFFC0C0C0).withValues(alpha: 0.5), // border-silver/50
          ),
        ),
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.scaleWidth(16)), // p-4
      decoration: BoxDecoration(
        color: AppColors.foreground.withValues(alpha: 0.04), // bg-white/4
        border: Border.all(
          color: AppColors.foreground.withValues(alpha: 0.08), // border-white/8
        ),
        borderRadius: BorderRadius.circular(AppRadius.settingsGroupValue), // rounded-28
      ),
      child: child,
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// PERSONAL INFO SECTION
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _PersonalInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => false, // Only renders inputs initially
      builder: (context, state) {
        final cubit = context.read<EditProfileCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('Personal Info'),
            _CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FieldLabel('Full Name'),
                  _PillInput(
                    placeholder: 'Full Name',
                    initialValue: state.fullName,
                    onChanged: cubit.updateFullName,
                  ),
                  const _FieldLabel('Username'),
                  _PillInput(
                    placeholder: 'username',
                    initialValue: state.username,
                    prefixIcon: LucideIcons.atSign,
                    onChanged: cubit.updateUsername,
                  ),
                  const _FieldLabel('Email'),
                  _PillInput(
                    placeholder: 'Email Address',
                    initialValue: state.email,
                    onChanged: cubit.updateEmail,
                  ),
                  const _FieldLabel('Phone'),
                  _PillInput(
                    placeholder: 'Phone Number',
                    initialValue: state.phone,
                    onChanged: cubit.updatePhone,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// BIO SECTION
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _BioSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('Bio'),
            _CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    initialValue: state.bio,
                    maxLines: 3,
                    maxLength: 160,
                    onChanged: context.read<EditProfileCubit>().updateBio,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      height: 1.6, // relaxed leading
                      fontSize: context.scaleFontSize(14),
                      color: AppColors.foreground,
                    ),
                    buildCounter: (_, {required currentLength, required isFocused, required maxLength}) => null, // Custom rendered below
                    decoration: InputDecoration(
                      hintText: 'Tell the world about yourselfâ€¦',
                      hintStyle: TextStyle(
                        color: AppColors.foreground.withValues(alpha: 0.3),
                      ),
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(8)),
                  Text(
                    '${state.bio.length}/160',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.scaleFontSize(10), // 10px
                      color: const Color(0xFFC0C0C0).withValues(alpha: 0.3), // silver/30
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// SOCIAL LINKS SECTION
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SocialLinksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        final cubit = context.read<EditProfileCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('Social Links'),
            _CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FieldLabel('Twitter / X'),
                  _PillInput(
                    placeholder: 'Twitter handle',
                    initialValue: state.twitter,
                    prefixIcon: LucideIcons.hash,
                    onChanged: cubit.updateTwitter,
                  ),
                  const _FieldLabel('Instagram'),
                  _PillInput(
                    placeholder: 'Instagram username',
                    initialValue: state.instagram,
                    prefixIcon: LucideIcons.camera,
                    onChanged: cubit.updateInstagram,
                  ),
                  const _FieldLabel('Website'),
                  _PillInput(
                    placeholder: 'URL',
                    initialValue: state.website,
                    prefixIcon: LucideIcons.link2,
                    onChanged: cubit.updateWebsite,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// INTERESTS SECTION
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

const List<String> _poolInterests = [
  'World News', 'Technology', 'AI', 'Business', 'Finance',
  'Politics', 'Sports', 'Entertainment', 'Health', 'Science',
  'Crypto', 'Environment', 'Lifestyle', 'Education', 'Cars'
];

class _InterestsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Interests'),
        _CardContainer(
          child: BlocBuilder<EditProfileCubit, EditProfileState>(
            builder: (context, state) {
              return Wrap(
                spacing: context.scaleWidth(8), // gap-2
                runSpacing: context.scaleHeight(8), // gap-2
                children: _poolInterests.map((interest) {
                  final isSelected = state.selectedInterests.contains(interest);

                  return GestureDetector(
                    onTap: () => context.read<EditProfileCubit>().toggleInterest(interest),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaleWidth(14),
                        vertical: context.scaleHeight(8),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFC0C0C0).withValues(alpha: 0.15) // bg-[#C0C0C0]/15
                            : AppColors.foreground.withValues(alpha: 0.03), // bg-white/3
                        borderRadius: BorderRadius.circular(AppRadius.pillValue),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFC0C0C0).withValues(alpha: 0.40) // border-[#C0C0C0]/40
                              : AppColors.foreground.withValues(alpha: 0.08), // border-white/8
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected) ...[
                            Icon(
                              LucideIcons.check,
                              size: context.scaleWidth(12),
                              color: AppColors.foreground,
                            ),
                            SizedBox(width: context.scaleWidth(6)),
                          ],
                          Text(
                            interest,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: context.scaleFontSize(11),
                              color: isSelected
                                  ? AppColors.foreground // white
                                  : const Color(0xFFC0C0C0).withValues(alpha: 0.5), // silver/50
                            ),
                          ),
                          if (!isSelected) ...[
                            SizedBox(width: context.scaleWidth(6)),
                            Icon(
                              LucideIcons.plus,
                              size: context.scaleWidth(12),
                              color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// SAVE BUTTON
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listenWhen: (prev, curr) => !prev.isSaved && curr.isSaved,
      listener: (context, state) {
        if (state.isSaved) {
          // The cubit handles the 1200ms delay. We just pop immediately here after transition.
          // Wait, the prompt says "wait 1200ms -> navigate back". 
          // If the cubit did the wait, it emits isSaved. So we can just pop.
          context.pop();
        }
      },
      builder: (context, state) {
        if (state.isSaving) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: context.scaleHeight(14)), // py-3.5
            decoration: BoxDecoration(
              color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.pillValue),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF102A43)),
              ),
            ),
          );
        }

        return PressScaleAnimation(
          onTap: () {
            if (!state.isSaved) {
              context.read<EditProfileCubit>().saveProfile();
            }
          },
          scaleOnPress: 0.95, // active:scale-95
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: context.scaleHeight(14)), // py-3.5
            decoration: BoxDecoration(
              color: const Color(0xFFC0C0C0), // Solid silver background
              borderRadius: BorderRadius.circular(AppRadius.pillValue), // 50px
            ),
            alignment: Alignment.center,
            child: Text(
              state.isSaved ? 'âœ” Saved!' : 'Save',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: context.scaleFontSize(14), // text-sm
                color: const Color(0xFF102A43), // navy
              ),
            ),
          ),
        );
      },
    );
  }
}


