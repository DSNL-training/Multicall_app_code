import 'package:flutter/material.dart';

class CustomTextSelectionControls extends MaterialTextSelectionControls {
  @override
  Widget buildHandle(
      BuildContext context, TextSelectionHandleType type, double textLineHeight,
      [void Function()? onTap]) {
    Color handleColor;

    switch (type) {
      case TextSelectionHandleType.left:
      case TextSelectionHandleType.right:
        handleColor = Colors.lightBlue.shade500; // Custom color for the handle
        break;
      case TextSelectionHandleType.collapsed:
        handleColor = Colors.lightBlue.shade500; // Custom color for the handle
        break;
    }

    return _buildCustomHandle(
        context, type, textLineHeight, handleColor, onTap);
  }

  Widget _buildCustomHandle(BuildContext context, TextSelectionHandleType type,
      double textLineHeight, Color color, void Function()? onTap) {
    final Widget handle =
        super.buildHandle(context, type, textLineHeight, onTap);
    return Container(
      width: 22.0,
      height: 22.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: handle,
      ),
    );
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return const Size(22.0, 22.0); // Custom handle size
  }
}
