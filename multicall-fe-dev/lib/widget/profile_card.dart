import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileCard extends StatelessWidget {
  final String itemName;
  final bool isLastItem;
  final VoidCallback? onPressed;
  final Color textColor;
  final EdgeInsets padding;
  final bool isActive;
  final bool isDefault;

  const ProfileCard({
    super.key,
    required this.itemName,
    required this.isLastItem,
    this.onPressed,
    this.textColor = Colors.black,
    this.padding = const EdgeInsets.only(left: 14),
    this.isActive = false,
    this.isDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed!();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          itemName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        if (isActive)
                          const Icon(
                            PhosphorIconsFill.checkCircle,
                            color: Color.fromRGBO(98, 180, 20, 1),
                            size: 16,
                          ),
                      ],
                    ),
                    Icon(
                      PhosphorIcons.caretRight(),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                if (isDefault)
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(237, 240, 242, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    width: 60,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: const Text(
                      "Default",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(62, 74, 84, 1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!isLastItem)
            const Divider(
              color: Color.fromRGBO(221, 225, 228, 1),
              thickness: 2,
              // indent: 16,
              // endIndent: 16,
            ),
        ],
      ),
    );
  }
}
