import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class PurchaseRecord extends Equatable {
  final String id;
  final String planId;
  final String planName;
  final DateTime purchaseDate;
  final double amount;
  final String status;
  final String platform;
  final String txnId;

  const PurchaseRecord({
    required this.id,
    required this.planId,
    required this.planName,
    required this.purchaseDate,
    required this.amount,
    required this.status,
    this.platform = 'App Store',
    this.txnId = '',
  });

  // Aliases for RestorePurchaseCard
  String get name => planName;
  double get price => amount;
  DateTime get date => purchaseDate;

  String get displayDate => DateFormat('MMM dd, yyyy').format(purchaseDate);
  String get displayAmount => '\$${amount.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [id, planId, planName, purchaseDate, amount, status, platform, txnId];
}
