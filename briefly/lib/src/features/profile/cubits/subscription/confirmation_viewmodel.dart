import 'package:briefly/src/core/mvvm/base_view_model.dart';

class ConfirmationViewModel extends BaseViewModel {
  bool isAgreed = false;
  bool isProcessing = false;
  bool isSuccess = false;

  void toggleAgreement(bool? value) {
    isAgreed = value ?? false;
    notifyListeners();
  }

  void processPayment() async {
    if (!isAgreed) return;
    
    isProcessing = true;
    notifyListeners();

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));
    
    isProcessing = false;
    isSuccess = true;
    notifyListeners();
  }
}
