import 'package:briefly/src/core/mvvm/base_view_model.dart';
import 'package:briefly/src/domain/repositories/profile_repository.dart';
import 'package:briefly/src/domain/models/subscription_plan.dart';

class ManageSubscriptionViewModel extends BaseViewModel {
  final ProfileRepository _repository;
  late SubscriptionPlan currentPlan;
  bool get isAnnual => currentPlan.id == 'premium_annual';

  // Cancel flow state
  String? selectedCancelReason;
  bool cancelConfirmed = false;

  ManageSubscriptionViewModel(this._repository);

  Future<void> init() async {
    currentPlan = SubscriptionPlan.findById(_repository.currentProfile.subscriptionPlanId);
    await Future.delayed(const Duration(milliseconds: 400));
    notifyListeners();
  }

  void selectCancelReason(String reason) {
    selectedCancelReason = reason;
    notifyListeners();
  }

  Future<void> confirmCancel() async {
    cancelConfirmed = true;
    notifyListeners();
    // Auto-dismiss handled by the sheet caller
  }

  void resetCancel() {
    selectedCancelReason = null;
    cancelConfirmed = false;
    notifyListeners();
  }
}



