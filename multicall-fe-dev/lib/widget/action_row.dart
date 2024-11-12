import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/text_button.dart';

class ActionRow extends StatelessWidget {
  const ActionRow({
    super.key,
    required this.cancelFunction,
    required this.approveFunction,
  });

  final VoidCallback cancelFunction;
  final VoidCallback approveFunction;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButtonOnlyBorder(
            title: 'Cancel',
            borderColor: const Color.fromRGBO(205, 211, 215, 1),
            action: cancelFunction,
            textColor: const Color.fromRGBO(16, 19, 21, 1),
            width: size.width * 0.4,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          TextButtonWithBG(
            title: 'OK',
            action: approveFunction,
            color: const Color.fromRGBO(0, 134, 181, 1),
            textColor: Colors.white,
            fontSize: 16,
            // iconData: iconData,
            padding: EdgeInsets.zero,
            iconColor: Colors.white,
            width: size.width * 0.4,
          ),
        ],
      ),
    );
  }
}
