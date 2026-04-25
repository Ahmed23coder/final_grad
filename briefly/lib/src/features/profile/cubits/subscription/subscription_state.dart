import 'package:equatable/equatable.dart';

import '../../../../domain/models/plan_type.dart';

class SubscriptionState extends Equatable {
  final PlanType selectedPlan;
  final PlanType activePlan;

  const SubscriptionState({
    this.selectedPlan = PlanType.premium,
    this.activePlan = PlanType.premium,
  });

  SubscriptionState copyWith({
    PlanType? selectedPlan,
    PlanType? activePlan,
  }) {
    return SubscriptionState(
      selectedPlan: selectedPlan ?? this.selectedPlan,
      activePlan: activePlan ?? this.activePlan,
    );
  }

  @override
  List<Object?> get props => [selectedPlan, activePlan];
}
