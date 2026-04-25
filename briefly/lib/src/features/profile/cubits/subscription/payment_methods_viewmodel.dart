import 'package:briefly/src/core/mvvm/base_view_model.dart';
import 'package:briefly/src/domain/repositories/profile_repository.dart';
import 'package:briefly/src/domain/models/payment_method.dart';

class PaymentMethodsViewModel extends BaseViewModel {
  final ProfileRepository _repository;
  List<PaymentMethod> paymentMethods = [];
  String? selectedMethodId;

  PaymentMethodsViewModel(this._repository);

  void init() async {
    await runBusyFuture(_fetchPaymentMethods());
  }

  Future<void> _fetchPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: 600));
    paymentMethods = List<PaymentMethod>.from(_repository.currentProfile.paymentMethods);
    if (paymentMethods.isNotEmpty) {
      selectedMethodId = paymentMethods.firstWhere(
        (m) => m.isDefault,
        orElse: () => paymentMethods.first,
      ).id;
    }
  }

  void selectMethod(String id) {
    selectedMethodId = id;
    notifyListeners();
  }

  void deletePaymentMethod(String id) {
    paymentMethods.removeWhere((m) => m.id == id);
    if (selectedMethodId == id && paymentMethods.isNotEmpty) {
      selectedMethodId = paymentMethods.first.id;
    }
    notifyListeners();
  }

  void setDefault(String id) {
    paymentMethods = paymentMethods.map((m) {
      return m.copyWith(isDefault: m.id == id);
    }).toList();
    notifyListeners();
  }

  void addPaymentMethod(PaymentMethod method) {
    paymentMethods.add(method);
    selectedMethodId = method.id;
    notifyListeners();
  }
}



