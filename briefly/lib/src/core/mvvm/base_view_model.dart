import 'package:flutter/material.dart';

/// MVVM scaffolding kept only for legacy subscription view-models.
///
/// New screens MUST use Cubit/Bloc instead — see project README. The remaining
/// uses under `features/profile/cubits/subscription/` will be migrated
/// incrementally.
abstract class BaseViewModel extends ChangeNotifier {
  bool _isBusy = false;
  bool get isBusy => _isBusy;

  void setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  Future<T> runBusyFuture<T>(Future<T> busyFuture) async {
    setBusy(true);
    try {
      return await busyFuture;
    } finally {
      setBusy(false);
    }
  }
}
