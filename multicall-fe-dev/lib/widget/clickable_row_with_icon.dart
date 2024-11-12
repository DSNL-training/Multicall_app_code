import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ClickableRowWithIcon extends StatelessWidget {
  ClickableRowWithIcon({
    super.key,
    required this.clickFunction,
    this.leftIconClickFunction,
    required this.title,
    this.subTitle,
    this.leftIcon,
    this.rightIcon,
    this.rightDualToneIcon,
    this.titleWeight,
    this.iconColor,
    this.titleSize = 16,
    this.subTitleSize = 16,
    this.titleColor = Colors.black,
    this.subTitleColor = const Color.fromARGB(255, 147, 147, 147),
    this.toolTipText,
  });
  final VoidCallback clickFunction;
  final VoidCallback? leftIconClickFunction;
  final String title;
  final String? subTitle;
  final IconData? leftIcon;
  final FontWeight? titleWeight;
  final IconData? rightIcon;
  final PhosphorDuotoneIconData? rightDualToneIcon;
  final Color? iconColor;
  final double titleSize;
  final double subTitleSize;
  final Color titleColor;
  final Color subTitleColor;
  final _controller = SuperTooltipController();
  final String? toolTipText;
  Future<bool>? _willPopCallback() async {
    // If the tooltip is open we don't pop the page on a backbutton press
    // but close the ToolTip
    if (_controller.isVisible) {
      await _controller.hideTooltip();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: clickFunction,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: titleWeight ?? FontWeight.w400,
                      fontSize: titleSize,
                      color: titleColor),
                ),
                const SizedBox(
                  width: 5,
                ),
                if (subTitle != null)
                  Text(
                    subTitle ?? "",
                    style: TextStyle(
                      color: subTitleColor,
                      fontSize: subTitleSize,
                    ),
                  ),
                if (subTitle != null)
                  const SizedBox(
                    width: 5,
                  ),
                (toolTipText != null)
                    ? SuperTooltip(
                        showBarrier: true,
                        controller: _controller,
                        popupDirection: TooltipDirection.down,
                        backgroundColor: const Color(0xff2f2d2f),
                        left: 30,
                        right: 30,
                        arrowTipDistance: 15.0,
                        arrowBaseWidth: 10.0,
                        arrowLength: 5.0,
                        borderWidth: 2.0,
                        constraints: const BoxConstraints(
                          minHeight: 0.0,
                          maxHeight: 100,
                          minWidth: 0.0,
                          maxWidth: 100,
                        ),
                        touchThroughAreaShape: ClipAreaShape.rectangle,
                        touchThroughAreaCornerRadius: 30,
                        barrierColor: const Color.fromARGB(26, 47, 45, 47),
                        content: Text(
                          toolTipText ?? "",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Icon(
                          leftIcon,
                          size: 18,
                          weight: 400,
                        ),
                      )
                    : Icon(
                        leftIcon,
                        size: 18,
                        weight: 400,
                      ),
              ],
            ),
            if (rightIcon != null)
              InkWell(
                onTap: () {
                  clickFunction();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    rightIcon,
                    size: 18,
                    weight: 400,
                    color: iconColor,
                  ),
                ),
              ),
            if (rightDualToneIcon != null)
              InkWell(
                onTap: () {
                  // Navigator.of(context).pushNamed(ChooseProfileScreen.routeName);
                  clickFunction();
                },
                child: DualToneIcon(
                  press: () {
                    clickFunction();
                  },
                  margin: 0,
                  iconSrc: rightDualToneIcon,
                  duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                  color: iconColor ?? Colors.black,
                  size: 14,
                  padding: const Padding(padding: EdgeInsets.all(5)),
                ),
              )
          ],
        ),
      ),
    );
  }
}
