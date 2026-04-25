import 'package:briefly/src/core/mvvm/base_view_model.dart';
import 'package:briefly/src/domain/repositories/profile_repository.dart';
import 'package:briefly/src/domain/models/subscription_plan.dart';

class UpgradePlanViewModel extends BaseViewModel {
  final ProfileRepository _repository;
  List<SubscriptionPlan> plans = [];
  SubscriptionPlan? selectedPlan;
  late SubscriptionPlan currentPlan;
  bool isComparisonExpanded = false;

  UpgradePlanViewModel(this._repository);

  void init() {
    plans = SubscriptionPlan.plans;
    currentPlan = SubscriptionPlan.findById(_repository.currentProfile.subscriptionPlanId);
    selectedPlan = currentPlan;
    notifyListeners();
  }

  bool get canContinue =>
      selectedPlan != null && selectedPlan!.id != currentPlan.id && selectedPlan!.id != 'free';

  void selectPlan(SubscriptionPlan plan) {
    if (selectedPlan?.id == plan.id) return;
    selectedPlan = plan;
    notifyListeners();
  }

  void toggleComparison() {
    isComparisonExpanded = !isComparisonExpanded;
    notifyListeners();
  }
}



