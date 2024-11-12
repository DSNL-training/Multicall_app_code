import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MultiCallOutLineButtonWidget extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final double borderRadius;
  final Function onTap;
  final double fontSize;
  final FontWeight fontWeight;
  final PhosphorIconData? iconData;
  final double iconSize;
  final Color iconColor;

  const MultiCallOutLineButtonWidget({
    super.key,
    required this.text,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.borderRadius = 4,
    required this.onTap,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.iconData,
    this.iconSize = 16,
    this.iconColor = Colors.white,
  });

  @override
  State<MultiCallOutLineButtonWidget> createState() =>
      _MultiCallOutLineButtonWidgetState();
}

class _MultiCallOutLineButtonWidgetState
    extends State<MultiCallOutLineButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(
            color: widget.borderColor,
            width: 1,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          widget.backgroundColor,
        ),
      ),
      onPressed: () {
        widget.onTap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.text == "Call Later"
              ? SizedBox(
                  child: SvgPicture.asset(
                    'assets/images/call-later.svg',
                    height: 20,
                    width: 20,
                    clipBehavior: Clip.hardEdge,
                  ),
                )
              : const SizedBox.shrink(),
          widget.iconData != null
              ? PhosphorIcon(
                  widget.iconData!,
                  size: widget.iconSize,
                  color: widget.iconColor,
                )
              : const SizedBox.shrink(),
          SizedBox(
            width: (widget.iconData != null && widget.text == "Call Later") ? 4 : 0,
          ),
          Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
