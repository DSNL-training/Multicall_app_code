import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static SharedPreferences? _prefs;

  static Future<void> load() async {
    _prefs ??= await SharedPreferences.getInstance();

    if (kDebugMode) {
      // Set these values only in debug mode
      // _prefs?.setString(PrefUtils.userEmail, "seenivasan.v@dsnl.in");
      // _prefs?.setString(PrefUtils.userPhoneNumber, "9597051085");
      // _prefs?.setInt(PrefUtils.userRegistrationNumber, 20);
    }
  }

  static Future<void> set(String key, dynamic value) async {
    if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is List<String>) {
      await _prefs?.setStringList(key, value);
    } else {
      await _prefs?.setString(key, value);
    }
  }

  static dynamic get(String key) {
    return _prefs?.get(key);
  }

  static Future<void> removeKey(String keyName) async {
    await _prefs?.remove(keyName);
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}

class PrefUtils {
  static const String userRegistrationNumber = "registration_number";
  static const String userName = "name";
  static const String userEmail = "email";
  static const String userPhoneNumber = "phone";
  static const String selectedCallMeOnNumberPosition =
      "selectedCallMeOnNumberPosition";
  static const String watchedIntro = "watchedIntro";
  static const String isUserRegistered = "isUserRegistered";
  static const String fcmToken = "fcmToken";
  static const String isTutorialStarted = "isTutorialStarted";
}
