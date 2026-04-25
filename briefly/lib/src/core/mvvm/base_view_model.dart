import 'package:flutter/material.dart';

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
