import 'package:flutter/material.dart';

class GlobalText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final Alignment alignment;
  final EdgeInsets padding; // Add a new property for custom padding
  final String fontFamily;

  const GlobalText(
      {Key? key,
      required this.text,
      this.fontSize = 16,
      this.fontWeight = FontWeight.w400,
      this.color = Colors.black,
      this.textAlign = TextAlign.center,
      this.alignment = Alignment.center,
      this.padding = const EdgeInsets.symmetric(
          horizontal: 15.0, vertical: 8), // Set default padding
      this.fontFamily = "Lato"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding, // Use the provided padding
      child: Align(
        alignment: alignment,
        child: Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily),
        ),
      ),
    );
  }
}
