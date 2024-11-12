import 'package:flutter/material.dart';

class CustomAppBarWithOutTrailing extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarWithOutTrailing({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(
        60,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: const Color.fromRGBO(205, 211, 215, 1),
          height: 1,
        ),
      ),
    );
  }
}
