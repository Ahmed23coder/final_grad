import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SubscriptionPlan extends Equatable {
  final String id;
  final String name;
  final double price;
  final String displayPrice;
  final String interval;
  final List<String> features;
  final Color color;
  final IconData icon;
  final bool isPopular;
  final bool isBestValue;
  final String? discountText;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.displayPrice,
    required this.interval,
    required this.features,
    required this.color,
    required this.icon,
    this.isPopular = false,
    this.isBestValue = false,
    this.discountText,
  });

  static List<SubscriptionPlan> get plans => [
        const SubscriptionPlan(
          id: 'free',
          name: 'Free',
          price: 0,
          displayPrice: '\$0',
          interval: '/mo',
          features: ['10 AI Summaries per day', '5 Fact Checks per day', 'Standard support'],
          color: Colors.grey,
          icon: LucideIcons.user,
        ),
        const SubscriptionPlan(
          id: 'pro_monthly',
          name: 'Pro Monthly',
          price: 9.99,
          displayPrice: '\$9.99',
          interval: '/mo',
          features: ['Unlimited AI Summaries', 'Unlimited Fact Checks', 'Priority support', 'Offline reading'],
          color: Color(0xFF2979FF),
          icon: LucideIcons.zap,
          isPopular: true,
        ),
        const SubscriptionPlan(
          id: 'pro_annual',
          name: 'Pro Annual',
          price: 79.99,
          displayPrice: '\$79.99',
          interval: '/yr',
          features: ['All Pro features', 'Save 33%', 'Exclusive intelligence reports'],
          color: Color(0xFFa78bfa),
          icon: LucideIcons.award,
          isBestValue: true,
          discountText: 'SAVE 33%',
        ),
      ];

  static SubscriptionPlan findById(String id) {
    return plans.firstWhere((p) => p.id == id, orElse: () => plans.first);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        displayPrice,
        interval,
        features,
        color,
        icon,
        isPopular,
        isBestValue,
        discountText,
      ];
}
