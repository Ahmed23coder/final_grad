import 'package:briefly/src/core/mvvm/base_view_model.dart';
import 'package:briefly/src/domain/repositories/profile_repository.dart';
import 'package:briefly/src/domain/models/subscription_plan.dart';

class SubscriptionHubViewModel extends BaseViewModel {
  final ProfileRepository _repository;
  List<SubscriptionPlan> plans = [];
  SubscriptionPlan? selectedPlan;
  late SubscriptionPlan currentPlan;

  SubscriptionHubViewModel(this._repository);

  Future<void> init() async {
    await runBusyFuture(_fetchPlans());
  }

  Future<void> _fetchPlans() async {
    await Future.delayed(const Duration(milliseconds: 600));
    plans = SubscriptionPlan.plans;
    currentPlan = SubscriptionPlan.findById(_repository.currentProfile.subscriptionPlanId);
    selectedPlan = currentPlan;
  }

  void selectPlan(SubscriptionPlan plan) {
    if (selectedPlan?.id == plan.id) return;
    selectedPlan = plan;
    notifyListeners();
  }
}



