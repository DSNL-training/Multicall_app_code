import 'package:flutter/material.dart';

class MultiCallTextWidget extends StatelessWidget {
  const MultiCallTextWidget({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.textColor = Colors.black,
    this.textAlign = TextAlign.start,
    this.lineHeight = 1.2,
    this.textOverflow = TextOverflow.visible,
  });

  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double lineHeight;
  final TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: lineHeight,
      ),
      overflow: textOverflow,
    );
  }
}
