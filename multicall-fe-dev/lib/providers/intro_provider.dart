import 'package:flutter/material.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';

class IntroProvider with ChangeNotifier {
  bool _watchedIntro = false;

  bool get watchedIntro => _watchedIntro;

  IntroProvider() {
    _loadWatchedIntro();
  }

  Future<void> _loadWatchedIntro() async {
    await PreferenceHelper.load();
    _watchedIntro = (PreferenceHelper.get(PrefUtils.watchedIntro) ==
            PreferenceHelper.get(PrefUtils.isTutorialStarted))
        ? false
        : true;
    notifyListeners();
  }

  Future<void> setWatchedIntro(bool value) async {
    await PreferenceHelper.load();
    _watchedIntro = value;
    await PreferenceHelper.set(PrefUtils.watchedIntro, value);
    await PreferenceHelper.set(PrefUtils.isTutorialStarted, !value);
    notifyListeners();
  }
}
