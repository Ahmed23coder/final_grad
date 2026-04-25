import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../routes/app_router.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../core/utils/responsive_util.dart';

/// The side drawer presented on the Home screen.
class HomeMenuDrawer extends StatelessWidget {
  const HomeMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerWidth = context.scaleWidth(300); // Strict w-[300px]
    final location = GoRouterState.of(context).matchedLocation;
    final user = Supabase.instance.client.auth.currentUser;
    
    // Extract display name or fall back to email prefix
    final String displayName;
    if (user != null) {
      final metaName = user.userMetadata?['full_name'] as String?;
      if (metaName != null && metaName.isNotEmpty) {
        displayName = metaName;
      } else {
        displayName = user.email?.split('@').first ?? 'Member';
      }
    } else {
      displayName = 'Guest Reader';
    }

    final String subText = user != null ? (user.email ?? 'Member') : 'Sign in for full access';

    return Drawer(
      width: drawerWidth,
      backgroundColor: const Color(0xFF0D1B2A), // Exact bg-[#0D1B2A]
      child: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaleWidth(20),
                vertical: context.scaleHeight(24),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.zap, // Match main logo
                    color: AppColors.foreground,
                    size: context.scaleWidth(20),
                  ),
                  SizedBox(width: context.scaleWidth(8)),
                  Text(
                    'Briefly',
                    style: AppTextStyles.h2(context).copyWith(
                      fontSize: context.scaleFontSize(18),
                    ),
                  ),
                ],
              ),
            ),

            // Profile Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaleWidth(20),
                vertical: context.scaleHeight(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: context.scaleWidth(48),
                    height: context.scaleWidth(48),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue.withValues(alpha: 0.2), // bg-[#2979FF]/20
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.user,
                      color: AppColors.accentBlue,
                      size: context.scaleWidth(20),
                    ),
                  ),
                  SizedBox(width: context.scaleWidth(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: AppTextStyles.h4CardHeadline(context).copyWith(
                            fontSize: context.scaleFontSize(15),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.scaleHeight(2)),
                        Text(
                          subText,
                          style: AppTextStyles.caption(context).copyWith(
                            color: AppColors.silverSecondaryLabel, // silver
                            fontSize: context.scaleFontSize(11),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: context.scaleHeight(32)),
            
            // Nav Links
            _SettingsRow(
              isActive: location == AppRouter.readingHistory,
              icon: LucideIcons.clock,
              label: 'Reading History',
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRouter.readingHistory);
              },
            ),

            _SettingsRow(
              isActive: location == AppRouter.myChannels,
              icon: LucideIcons.monitorPlay,
              label: 'My Channels',
              onTap: () {
                context.pop(); // Close drawer
                context.push(AppRouter.myChannels); // myChannels is top level, push is fine
              },
            ),

            _SettingsRow(
              isActive: location == AppRouter.appSettings,
              icon: LucideIcons.settings,
              label: 'App Settings',
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRouter.appSettings);
              },
            ),

            _SettingsRow(
              isActive: location == AppRouter.about,
              icon: LucideIcons.info,
              label: 'About Briefly',
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRouter.about);
              },
            ),
            
            const Spacer(),
            
            // Footer: Sign In / Sign Up
            Padding(
               padding: EdgeInsets.symmetric(
                 horizontal: context.scaleWidth(24),
                 vertical: context.scaleHeight(32),
               ),
               child: GestureDetector(
                 onTap: () async {
                   Navigator.of(context).pop();
                   await Supabase.instance.client.auth.signOut();
                   if (context.mounted) {
                     context.go(AppRouter.login);
                   }
                 },
                 child: Container(
                   width: double.infinity,
                   padding: EdgeInsets.symmetric(
                     vertical: context.scaleHeight(14),
                   ),
                   alignment: Alignment.center,
                   decoration: BoxDecoration(
                     color: const Color(0xFFE86A6A).withValues(alpha: 0.08), // subtle red fill
                     borderRadius: BorderRadius.circular(50), // rounded-[50px]
                     border: Border.all(
                       color: const Color(0xFFE86A6A).withValues(alpha: 0.25), // soft red border
                     ),
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(
                         LucideIcons.logOut,
                         size: context.scaleWidth(16),
                         color: const Color(0xFFE86A6A), // red icon
                       ),
                       SizedBox(width: context.scaleWidth(10)),
                       Text(
                         'Log Out',
                         style: AppTextStyles.buttonLabel(context).copyWith(
                           color: const Color(0xFFE86A6A),
                         ),
                       ),
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

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.primaryAccent.withValues(alpha: 0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: context.scaleWidth(12)),
        padding: EdgeInsets.symmetric(
          horizontal: context.scaleWidth(12),
          vertical: context.scaleHeight(10),
        ),
        child: Row(
          children: [
             Container(
               padding: EdgeInsets.all(context.scaleWidth(8)),
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 color: isActive 
                     ? AppColors.primaryAccent.withValues(alpha: 0.15)
                     : AppColors.foreground.withValues(alpha: 0.03),
               ),
               child: Icon(
                 icon,
                 size: context.scaleWidth(18),
                 color: isActive ? AppColors.primaryAccent : AppColors.silverPlaceholder,
               ),
             ),
            SizedBox(width: context.scaleWidth(16)),
            Text(
              label,
              style: AppTextStyles.body(context).copyWith(
                color: isActive ? AppColors.foreground : AppColors.silverPlaceholder,
                fontSize: context.scaleFontSize(13), // Inter 13px
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
