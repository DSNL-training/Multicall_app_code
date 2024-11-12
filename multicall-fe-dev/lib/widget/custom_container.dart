import 'package:flutter/material.dart';

class CustomStyledContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final double radius;
  final double verticalPadding;
  final double horizontalPadding;

  const CustomStyledContainer({
    super.key,
    required this.child,
    this.height = 562.0,
    this.width = 328.0,
    this.radius = 16.0,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
