import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DualToneIcon extends StatelessWidget {
  final dynamic iconSrc;
  final VoidCallback? press;
  final double size;
  final Padding padding;
  final Color color;
  final Color duotoneSecondaryColor;
  final String? name;
  final Color fillColor;
  final Color? borderColor;
  final double? margin;

  const DualToneIcon({
    Key? key,
    this.iconSrc,
    this.press,
    this.size = 30,
    this.padding = const Padding(padding: EdgeInsets.all(10)),
    this.color = Colors.black,
    this.duotoneSecondaryColor = Colors.black,
    this.name,
    this.fillColor = Colors.white,
    this.margin = 10,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press ?? () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: margin ?? 10),
            padding: padding.padding,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: borderColor ?? const Color.fromRGBO(205, 211, 215, 1),
              ),
              shape: BoxShape.circle,
              color: fillColor,
            ),
            child: (iconSrc is IconData)
                ? PhosphorIcon(
                    duotoneSecondaryColor: duotoneSecondaryColor,
                    iconSrc as IconData,
                    size: size,
                    color: color,
                  )
                : Image.asset(
                    iconSrc as String,
                    height: 30,
                    width: 30,
                  ),
          ),
          if (name != null)
            Text(
              name!,
              style: const TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }
}
