import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/press_scale_animation.dart';
import '../../../../core/utils/responsive_util.dart';

enum SocialType { google, facebook, apple }

/// Row/Column of social auth buttons (Google, Facebook, Apple).
class SocialAuthButtons extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;
  final VoidCallback? onAppleTap;

  const SocialAuthButtons({
    super.key,
    this.isSignUp = false,
    this.onGoogleTap,
    this.onFacebookTap,
    this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(type: SocialType.google, onTap: onGoogleTap ?? () {}),
        SizedBox(width: context.scaleWidth(16)),
        _SocialButton(type: SocialType.facebook, onTap: onFacebookTap ?? () {}),
        SizedBox(width: context.scaleWidth(16)),
        _SocialButton(type: SocialType.apple, onTap: onAppleTap ?? () {}),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final SocialType type;
  final VoidCallback onTap;

  const _SocialButton({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      child: Container(
        height: context.scaleWidth(64),
        width: context.scaleWidth(64),
        decoration: BoxDecoration(
          color: AppColors.silver04,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.silverBorder, width: 1.185),
        ),
        alignment: Alignment.center,
        child: _buildIcon(context),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    const String googleSvg = '''
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" width="28" height="28">
        <path fill="#FFC107" d="M43.611,20.083H42V20H24v8h11.303c-1.649,4.657-6.08,8-11.303,8c-6.627,0-12-5.373-12-12c0-6.627,5.373-12,12-12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C12.955,4,4,12.955,4,24c0,11.045,8.955,20,20,20c11.045,0,20-8.955,20-20C40,22.659,39.652,21.342,43.611,20.083z"/>
        <path fill="#FF3D00" d="M6.306,14.691l6.571,4.819C14.655,15.108,18.961,12,24,12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C16.318,4,9.656,8.337,6.306,14.691z"/>
        <path fill="#4CAF50" d="M24,44c5.166,0,9.86-1.977,13.409-5.192l-6.19-5.238C29.211,35.091,26.715,36,24,36c-5.202,0-9.619-3.317-11.283-7.946l-6.522,5.025C9.505,39.556,16.227,44,24,44z"/>
        <path fill="#1976D2" d="M43.611,20.083H42V20H24v8h11.303c-0.792,2.237-2.231,4.166-4.087,5.571l6.19,5.238C36.971,39.205,44,34,44,24C44,22.659,43.652,21.342,43.611,20.083z"/>
      </svg>
    ''';

    const String facebookSvg = '''
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" width="28" height="28">
        <path fill="#1877F2" d="M24 4C12.95 4 4 12.95 4 24c0 9.98 7.33 18.25 16.87 19.74v-13.96h-5.08v-5.78h5.08v-4.41c0-5.01 2.98-7.78 7.55-7.78 2.19 0 4.47.39 4.47.39v4.92h-2.52c-2.48 0-3.26 1.54-3.26 3.12v3.75h5.54l-.89 5.78h-4.65v13.96C36.67 42.25 44 33.98 44 24 44 12.95 35.05 4 24 4z"/>
        <path fill="#fff" d="M30.55 30l.89-5.78h-5.54v-3.75c0-1.58.77-3.12 3.26-3.12h2.52v-4.92s-2.29-.39-4.47-.39c-4.57 0-7.55 2.77-7.55 7.78v4.41h-5.08v5.78h5.08v13.96c1.08.17 2.18.26 3.3.26s2.22-.09 3.3-.26v-13.96h4.65z"/>
      </svg>
    ''';

    const String appleSvg = '''
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" width="32" height="32" fill="#FFFFFF">
        <path d="M318.7 268.7c-.2-36.7 16.4-64.4 50-84.8-18.8-26.9-47.2-41.7-84.7-44.6-35.5-2.8-74.3 20.7-88.5 20.7-15 0-49.4-19.7-76.4-19.7C63.3 141.2 4 184.8 4 273.5q0 39.3 14.4 81.2c12.8 36.7 59 126.7 107.2 125.2 25.2-.6 43-17.9 75.8-17.9 31.8 0 48.3 17.9 76.4 17.9 48.6-.7 90.4-82.5 102.6-119.3-65.2-30.7-61.7-90-61.7-91.9zm-56.6-164.2c27.3-32.4 24.8-61.9 24-72.5-24.1 1.4-52 16.4-67.9 34.9-17.5 19.8-27.8 44.3-25.6 71.9 26.1 2 49.9-11.4 69.5-34.3z"/>
      </svg>
    ''';

    if (type == SocialType.google) {
      return SvgPicture.string(
        googleSvg,
        width: context.scaleWidth(28),
        height: context.scaleWidth(28),
      );
    } else if (type == SocialType.facebook) {
      return SvgPicture.string(
        facebookSvg,
        width: context.scaleWidth(28),
        height: context.scaleWidth(28),
      );
    } else if (type == SocialType.apple) {
      return SvgPicture.string(
        appleSvg,
        width: context.scaleWidth(32),
        height: context.scaleWidth(32),
      );
    }
    return const SizedBox();
  }
}
