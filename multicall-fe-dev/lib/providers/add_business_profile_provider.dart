import 'package:flutter/material.dart';

class AddBusinessProfileProvider extends ChangeNotifier {
  String _phone = "";
  String _email = "";
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String get phone => _phone;
  String get email => _email;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }
}
