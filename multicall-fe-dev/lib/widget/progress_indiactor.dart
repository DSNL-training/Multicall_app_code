import 'package:flutter/material.dart';

class MyProgressBar extends StatelessWidget {
  final double progressValue; // Set your progress value between 0.0 and 1.0
  final Color color; // Set your custom color

  const MyProgressBar(
      {super.key, this.progressValue = 0.96, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progressValue,
                  color: color,
                  minHeight: 2,
                ),
              ),
              Expanded(
                child: LinearProgressIndicator(
                  value: progressValue,
                  color: Colors.grey,
                  minHeight: 2,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 0, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Email ID',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(98, 180, 20, 1)),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(12, 0, 34, 0)),
              Text(
                'Mobile number',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w400, color: color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
