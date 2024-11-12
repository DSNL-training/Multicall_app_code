import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomSheetOptionWithIcon extends StatelessWidget {
  const BottomSheetOptionWithIcon({
    super.key,
    required this.iconSrc,
    required this.title,
    required this.action,
    this.isEnabled = false,
    this.isChecked = false,
    this.isSwitchPresent = false,
    this.isCheckboxPresent = false,
    this.selectedText = '',
  });

  final PhosphorIconData iconSrc;
  final String title;
  final VoidCallback action;
  final bool isEnabled;
  final bool isChecked;
  final bool isSwitchPresent;
  final bool isCheckboxPresent;
  final String selectedText;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        action();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(
          const Size(0, 0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                DualToneIcon(
                  iconSrc: iconSrc,
                  duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                  color: Colors.black,
                  size: 20,
                  fillColor: Colors.transparent,
                  margin: 0,
                  borderColor: Colors.transparent,
                  padding: const Padding(
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(16, 19, 21, 1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    selectedText,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(16, 19, 21, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isSwitchPresent)
            Switch(
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
              activeTrackColor: const Color(0XFF62B414),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0XFFDDE1E4),
              thumbColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              trackOutlineWidth: MaterialStateProperty.all(0.0),
              value: isChecked,
              onChanged: (value) => action(),
              activeColor: const Color.fromRGBO(98, 180, 20, 1),
            ),
          if (isCheckboxPresent)
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                action();
              },
              activeColor: const Color.fromRGBO(98, 180, 20, 1),
            ),
        ],
      ),
    );
  }
}
