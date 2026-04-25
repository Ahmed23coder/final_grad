import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  AboutCubit() : super(const AboutState()) {
    _initLinks();
  }

  void _initLinks() {
    final links = [
      const AboutLink(
        label: 'Privacy Policy',
        icon: LucideIcons.shieldCheck,
        iconColor: Color(0xFF34C759), // Green
        actionId: 'privacy_policy',
      ),
      const AboutLink(
        label: 'Terms of Service',
        icon: LucideIcons.fileText,
        iconColor: Color(0xFF5AC8FA), // Light Blue
        actionId: 'terms_of_service',
      ),
      const AboutLink(
        label: 'Open Source Licenses',
        icon: LucideIcons.code,
        iconColor: Color(0xFFFF9500), // Orange
        actionId: 'open_source_licenses',
      ),
      const AboutLink(
        label: 'Contact Us',
        icon: LucideIcons.mail,
        iconColor: Color(0xFF2979FF), // Accent Blue
        actionId: 'contact_us',
      ),
      const AboutLink(
        label: 'Rate App',
        icon: LucideIcons.star,
        iconColor: Color(0xFFFFCC00), // Gold
        actionId: 'rate_app',
      ),
      const AboutLink(
        label: 'Share App',
        icon: LucideIcons.share2,
        iconColor: Color(0xFFAF52DE), // Purple
        actionId: 'share_app',
      ),
    ];
    emit(AboutState(links: links));
  }

  void handleLinkAction(String actionId) {
    // Logic for navigation or external links handled here (stub for now)
    debugPrint('About Action: $actionId');
  }
}
