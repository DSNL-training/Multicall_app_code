import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({
    super.key,
    this.color = const Color.fromRGBO(205, 211, 215, 1),
  });
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color,
            width: 1,
          ),
        ),
      ),
    );
  }
}
