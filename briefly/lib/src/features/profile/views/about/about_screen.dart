import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_text_styles.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import 'package:briefly/src/core/utils/app_animations.dart';

import '../../cubits/about/about_cubit.dart';
import '../../cubits/about/about_state.dart';

import '../../widget/about/about_info_card.dart';
import '../../widget/about/about_link_row.dart';
import '../../widget/about/about_footer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocBuilder<AboutCubit, AboutState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaleWidth(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // App Info Card
                          PageEntranceAnimation(
                            delay: const Duration(milliseconds: 50),
                            slideOffset: 15.0,
                            child: AboutInfoCard(
                              appName: state.appName,
                              tagline: state.tagline,
                              version: state.version,
                              buildNumber: state.buildNumber,
                            ),
                          ),
                          
                          SizedBox(height: context.scaleHeight(24)),
                          
                          // Description Section
                          PageEntranceAnimation(
                            delay: const Duration(milliseconds: 100),
                            slideOffset: 15.0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(4)),
                              child: Text(
                                state.description,
                                style: AppTextStyles.aboutDescription(context),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: context.scaleHeight(32)),
                          
                          // Info Links Section
                          PageEntranceAnimation(
                            delay: const Duration(milliseconds: 150),
                            slideOffset: 15.0,
                            child: Column(
                              children: state.links.map((link) {
                                return AboutLinkRow(
                                  label: link.label,
                                  icon: link.icon,
                                  iconColor: link.iconColor,
                                  onTap: () => context.read<AboutCubit>().handleLinkAction(link.actionId),
                                );
                              }).toList(),
                            ),
                          ),
                          
                          const AboutFooter(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(20),
        right: context.scaleWidth(20),
        top: context.scaleHeight(14),
        bottom: context.scaleHeight(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildGlassBackButton(context),
              SizedBox(width: context.scaleWidth(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: AppTextStyles.h1(context), // Newsreader Bold
                    ),
                    SizedBox(height: context.scaleHeight(4)),
                    Text(
                      'Rasseny Intelligence',
                      style: AppTextStyles.tagline(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBackButton(BuildContext context) {
    return PressScaleAnimation(
      onTap: () => context.pop(),
      child: Container(
        width: context.scaleWidth(40),
        height: context.scaleWidth(40),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Icon(
          LucideIcons.arrowLeft,
          size: context.scaleWidth(18),
          color: AppColors.primaryAccent,
        ),
      ),
    );
  }
}


