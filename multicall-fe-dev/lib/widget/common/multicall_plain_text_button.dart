import 'package:flutter/material.dart';

class MultiCallPlainTextButtonWidget extends StatefulWidget {

  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double buttonHeight;
  final VoidCallback onPressed;

  const MultiCallPlainTextButtonWidget({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.textColor = Colors.black,
    this.textAlign = TextAlign.start,
    this.buttonHeight = 20,
    required this.onPressed,
  });

  @override
  State<MultiCallPlainTextButtonWidget> createState() => _MultiCallPlainTextButtonWidgetState();
}

class _MultiCallPlainTextButtonWidgetState extends State<MultiCallPlainTextButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(
        Colors.transparent,
      ), padding: MaterialStateProperty.all(EdgeInsets.zero)),
      child: Text(
        widget.text,
        style: TextStyle(
          color: widget.textColor,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),
      ),
    );
  }
}
