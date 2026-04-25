import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String type; // 'card', 'paypal', etc.
  final String brand; // 'Visa', 'Mastercard'
  final String last4;
  final String expiryDate;
  final String holderName;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.brand,
    required this.last4,
    required this.expiryDate,
    required this.holderName,
    this.isDefault = false,
  });

  String get brandLabel => brand.toUpperCase();

  Color get brandColor {
    switch (brand.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1A1F71);
      case 'mastercard':
        return const Color(0xFFEB001B);
      case 'amex':
        return const Color(0xFF007BC1);
      default:
        return Colors.white70;
    }
  }

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? brand,
    String? last4,
    String? expiryDate,
    String? holderName,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      expiryDate: expiryDate ?? this.expiryDate,
      holderName: holderName ?? this.holderName,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, type, brand, last4, expiryDate, holderName, isDefault];
}
