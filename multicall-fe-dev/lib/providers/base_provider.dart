import 'package:flutter/material.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';

class BaseProvider with ChangeNotifier {
  /// getter methods
  int get regNum => PreferenceHelper.get(PrefUtils.userRegistrationNumber) ?? 0;

  String get email => PreferenceHelper.get(PrefUtils.userEmail) ?? '';

  String get telephone => PreferenceHelper.get(PrefUtils.userPhoneNumber) ?? '';

  /// setter methods
  set regNum(int value) =>
      PreferenceHelper.set(PrefUtils.userRegistrationNumber, value);

  set email(String value) => PreferenceHelper.set(PrefUtils.userEmail, value);

  set telephone(String value) =>
      PreferenceHelper.set(PrefUtils.userPhoneNumber, value);

  BaseProvider() {
    reset();
  }

  void reset() {
    regNum = PreferenceHelper.get(PrefUtils.userRegistrationNumber) ?? 0;
    email = PreferenceHelper.get(PrefUtils.userEmail) ?? '';
    telephone = PreferenceHelper.get(PrefUtils.userPhoneNumber) ?? '';

    debugPrint('BaseProvider reset: $regNum - $email - $telephone');

    notifyListeners();
  }
}
