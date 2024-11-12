import 'package:flutter/material.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MenuOptions extends StatelessWidget {
  final String itemName;
  final bool isLastItem;
  final VoidCallback? onPressed;
  final Color textColor;
  final EdgeInsets padding;
  final double diverStartIndent;
  final double diverEndIndent;
  final bool isActive;

  const MenuOptions({
    super.key,
    required this.itemName,
    required this.isLastItem,
    this.onPressed,
    this.textColor = Colors.black,
    this.padding = const EdgeInsets.only(left: 14),
    this.diverStartIndent = 0,
    this.diverEndIndent = 0,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed!();
      },
      child: Column(
        children: [
          ListTile(
            contentPadding: padding,
            trailing: customIconButton(
              iconData: PhosphorIcons.caretRight(),
              onPressed: onPressed!,
              padding: EdgeInsets.zero,
            ),
            title: Row(
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
                    size: 18,
                  ),
              ],
            ),
          ),
          if (!isLastItem)
            Divider(
              color: const Color.fromRGBO(221, 225, 228, 1),
              indent: diverStartIndent,
              endIndent: diverEndIndent,
              thickness: 1,
            ),
        ],
      ),
    );
  }
}
