import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// Common Widgets for the app

IconButton customIconButton({
  Key? key,
  required PhosphorIconData iconData,
  required VoidCallback onPressed,
  double? size,
  EdgeInsets? padding,
}) {
  return padding != null
      ? IconButton(
          key: key,
          padding: padding,
          onPressed: onPressed,
          icon: PhosphorIcon(
            iconData,
            size: size,
          ),
        )
      : IconButton(
          key: key,
          onPressed: onPressed,
          icon: PhosphorIcon(
            iconData,
            size: size,
          ),
        );
}

//Common Classes for the widgets
class RowWithTextButtons extends StatelessWidget {
  final double buttonWidth;
  final VoidCallback callLaterAction;
  final VoidCallback callNowAction;

  const RowWithTextButtons({
    super.key,
    required this.buttonWidth,
    required this.callLaterAction,
    required this.callNowAction,
  });

  @override
  Widget build(BuildContext context) {
    const PhosphorIconData iconData = PhosphorIconsLight.phoneCall;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconButton(
          title: 'Call Later',
          action: callLaterAction,
          color: const Color.fromRGBO(218, 239, 198, 1),
          textColor: const Color.fromRGBO(98, 180, 20, 1),
          iconData: iconData,
          iconColor: const Color.fromRGBO(98, 180, 20, 1),
          border: Border.all(
            width: 1,
            color: const Color.fromRGBO(98, 180, 20, 1),
          ),
          image: 'assets/images/notch.svg',
        ),
        const SizedBox(
          width: 10,
        ),
        CustomIconButton(
          title: 'Call Now',
          action: callNowAction,
          color: const Color.fromRGBO(98, 180, 20, 1),
          textColor: Colors.white,
          iconData: iconData,
          iconColor: Colors.white,
          border: Border.all(
            width: 1,
            color: const Color.fromRGBO(98, 180, 20, 1),
          ),
        ),
      ],
    );
  }
}

class MyModalBottomSheet extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;

  const MyModalBottomSheet({
    super.key,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: const Wrap(
        children: <Widget>[
          Text("data"),
          Text("  TEsts"),
        ],
      ),
    );
  }
}

void showMyModalBottomSheet(
  BuildContext context, {
  double? height,
  double? width,
  Color? backgroundColor,
  BorderRadiusGeometry? borderRadius,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return MyModalBottomSheet(
        height: height,
        width: width,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
      );
    },
  );
}

class NavigatorOption extends StatelessWidget {
  const NavigatorOption({
    super.key,
    required this.title,
    required this.route,
    this.iconData,
    required this.isClicked,
    this.duotoneSecondaryColor = Colors.black,
    this.color = Colors.black,
    this.size = 30,
  });

  final String title;
  final String route;
  final IconData? iconData;
  final Function isClicked;
  final Color duotoneSecondaryColor;
  final Color color;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          isClicked();
          // check if route is not null or blank
          if (route.isNotEmpty) {
            Navigator.pushNamed(context, route);
          }
        },
        child: Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: iconData != null
                    ? PhosphorIcon(
                        duotoneSecondaryColor: duotoneSecondaryColor,
                        iconData as IconData,
                        size: size,
                        color: color,
                      )
                    : Container(),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.title,
    required this.action,
    required this.color,
    required this.textColor,
    required this.iconData,
    required this.iconColor,
    required this.border,
    this.image = "",
  });

  final String title;
  final VoidCallback action;
  final Color color;
  final Color textColor;
  final PhosphorIconData iconData;
  final Color iconColor;
  final Border border;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: action,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            border: border,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image == ""
                  ? Icon(
                      iconData,
                      color: iconColor,
                      size: 16,
                    )
                  : SizedBox(
                      child: SvgPicture.asset(
                        'assets/images/call-later.svg',
                        height: 16,
                        width: 16,
                        clipBehavior: Clip.hardEdge,
                      ),
                    ),
              const SizedBox(
                width: 4,
              ),
              GlobalText(
                text: title,
                fontSize: 16,
                padding: EdgeInsets.zero,
                color: textColor,
                fontWeight: FontWeight.w700,
              )
            ],
          ),
        ),
      ),
    );
  }
}
