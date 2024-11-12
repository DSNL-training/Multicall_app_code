import 'dart:async';

import 'package:flutter/material.dart';

class OTPTimer extends StatefulWidget {
  final Function onTap;

  const OTPTimer({super.key, required this.onTap});

  @override
  _OTPTimerState createState() => _OTPTimerState();
}

class _OTPTimerState extends State<OTPTimer> {
  late Timer _timer;
  int _secondsRemaining = 30; // Initial timer duration in seconds
  bool _timerEnded = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _timerEnded = true;
        });
      }
    });
  }

  void _resetTimer() {
    widget.onTap();
    setState(() {
      _secondsRemaining = 30; // Set your desired timer duration in seconds
      _timerEnded = false;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _timerEnded
        ? GestureDetector(
            onTap: () {
              _resetTimer();
              debugPrint("Tapped in Timer...");
            },
            child: const Text(
              'Resend',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(98, 180, 20, 1),
              ),
              textAlign: TextAlign.end,
            ),
          )
        : RichText(
            text: TextSpan(
              text: 'Resend in ',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Roboto",
                color: Color.fromRGBO(111, 122, 131, 1),
              ),
              children: [
                TextSpan(
                  text: '${_secondsRemaining}s',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "Roboto",
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.end,
          );
  }
}
