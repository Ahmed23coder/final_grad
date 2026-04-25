import 'package:briefly/src/core/mvvm/base_view_model.dart';
import 'package:briefly/src/domain/repositories/profile_repository.dart';
import 'package:briefly/src/domain/models/purchase_record.dart';

enum RestoreState { idle, scanning, found, notFound, restored }

class RestorePurchasesViewModel extends BaseViewModel {
  final ProfileRepository _repository;

  RestoreState state = RestoreState.idle;
  int? selectedPurchaseIndex;
  List<PurchaseRecord> foundPurchases = [];

  RestorePurchasesViewModel(this._repository);

  void startScan() async {
    state = RestoreState.scanning;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 3));

    foundPurchases = List<PurchaseRecord>.from(_repository.currentProfile.purchaseHistory);
    if (foundPurchases.isEmpty) {
      state = RestoreState.notFound;
    } else {
      state = RestoreState.found;
      selectedPurchaseIndex = 0;
    }
    notifyListeners();
  }

  void selectPurchase(int index) {
    selectedPurchaseIndex = index;
    notifyListeners();
  }

  void restore() async {
    setBusy(true);
    await Future.delayed(const Duration(seconds: 2));

    state = RestoreState.restored;
    setBusy(false);
    notifyListeners();
  }
}
