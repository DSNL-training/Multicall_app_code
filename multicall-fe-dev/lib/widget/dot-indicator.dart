// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    this.isActive = false,
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color.fromRGBO(62, 74, 84, 1) : const Color.fromRGBO(205, 211, 215, 1),
          ),
          height: isActive ? 8 : 6,
          width: isActive ? 8 : 6,
          margin: const EdgeInsets.only(right: 8),
        ),
      ],
    );
  }
}
