import 'package:flutter/material.dart';

class IconWithBorder extends StatelessWidget {
  const IconWithBorder({
    super.key,
    required this.icon,
    required this.onClick,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onClick;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: const Color.fromRGBO(205, 211, 215, 1),
        ),
      ),
      child: Center(
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            size: 16,
            icon,
            color: color,
          ),
          onPressed: onClick,
        ),
      ),
    );
  }
}
