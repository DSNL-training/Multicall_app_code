import 'dart:async';

import 'package:flutter/foundation.dart';

class MultipleClickHandler {
  static final Map<String, bool> _clickTracker = {};

  static void checkClick({
    required String key,
    required VoidCallback onClick,
    int durationInSeconds = 5,
  }) {
    if (_clickTracker[key] == true) return;

    // Execute the callback
    onClick();

    // Set the key to true to block further clicks
    _clickTracker[key] = true;

    // Set a timer to reset the click tracker
    Timer(Duration(seconds: durationInSeconds), () {
      _clickTracker[key] = false;
    });
  }
}
