import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class AboutLink extends Equatable {
  final String label;
  final IconData icon;
  final Color iconColor;
  final String actionId;

  const AboutLink({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.actionId,
  });

  @override
  List<Object?> get props => [label, icon, iconColor, actionId];
}

class AboutState extends Equatable {
  final String appName;
  final String tagline;
  final String description;
  final String version;
  final String buildNumber;
  final List<AboutLink> links;

  const AboutState({
    this.appName = 'Rasseny Intelligence',
    this.tagline = 'The Future of Real-Time News and Analysis',
    this.description = 'Experience the next generation of intelligent news reader. Rasseny brings you real-time global news, deep analytical reports, and cross-source verification powered by advanced AI. Our mission is to empower informed global citizens with unparalleled depth and speed.',
    this.version = '1.0.0',
    this.buildNumber = '42',
    this.links = const [],
  });

  @override
  List<Object?> get props => [
        appName,
        tagline,
        description,
        version,
        buildNumber,
        links,
      ];
}
