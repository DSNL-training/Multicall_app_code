import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multicall_mobile/models/instant_call/response_conferee_speaking.dart';

class SpeakingProvider extends ChangeNotifier {
  final Map<String, Timer?> _speakingTimers = {};
  final Set<String> _speakingConferees = {};

  bool isSpeaking(String phoneNumber) =>
      _speakingConferees.contains(phoneNumber);

  void updateConfereeState(String phoneNumber, bool isSpeaking) {
    if (isSpeaking) {
      _speakingConferees.add(phoneNumber);
      _speakingTimers[phoneNumber]?.cancel(); // Cancel any existing timer
      _speakingTimers[phoneNumber] = Timer(const Duration(seconds: 2), () {
        _speakingConferees.remove(phoneNumber);
        notifyListeners(); // Notify listeners when speaking state changes
      });
    } else {
      _speakingConferees.remove(phoneNumber);
      _speakingTimers[phoneNumber]?.cancel();
    }

    notifyListeners();
  }

  void handleConfereeSpeakingStatusResponse(
      ConfereeSpeakingStatusResponse response) {
    for (var phone in response.confereePhones) {
      updateConfereeState(phone, true);
    }
  }

  @override
  void dispose() {
    _speakingTimers.forEach((_, timer) => timer?.cancel());
    super.dispose();
  }
}
