import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TextButtonWithBG extends StatelessWidget {
  TextButtonWithBG({
    super.key,
    required this.title,
    required this.action,
    required this.width,
    required this.color,
    this.isLoading = false,
    this.fontSize = 24,
    this.borderRadius = 8.0,
    this.iconData,
    this.size = 16,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.fontWeight = FontWeight.w700,
    this.border,
    this.isDisabled = false,
    this.padding = const EdgeInsets.all(16),
    this.height = 45,
  });

  final String title;
  final VoidCallback action;
  final double width;
  final Color color;
  final double fontSize;
  final bool isLoading;
  final double size;
  final PhosphorIconData? iconData;
  final Color textColor;
  final Color iconColor;
  final FontWeight fontWeight;
  Border? border;
  final double borderRadius;
  final bool isDisabled;
  final EdgeInsets padding;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: TextButton.icon(
        onPressed: () {
          isDisabled
              ? () {}
              : isLoading
                  ? () {}
                  : action();
        },
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontFamily:
                Theme.of(context).primaryTextTheme.titleLarge?.fontFamily,
          )),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: border != null ? border!.top.color : Colors.transparent,
              width: border != null ? border!.top.width : 0,
            ),
          )),
          minimumSize: MaterialStateProperty.all(Size(width, height)),
          backgroundColor: MaterialStateProperty.all(color),
          padding: MaterialStateProperty.resolveWith(
            (states) => padding,
          ),
        ),
        icon: iconData != null
            ? PhosphorIcon(
                iconData!,
                size: size,
                color: iconColor,
              )
            : const SizedBox(),
        label: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: fontWeight,
                  fontSize: fontSize, // Use custom fontSize here
                ),
              ),
      ),
    );
  }
}

class BorderTextButton extends StatelessWidget {
  const BorderTextButton({
    super.key,
    required this.title,
    required this.action,
    required this.borderColor,
    required this.textColor,
  });

  final String title;
  final VoidCallback action;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(4), // adjust the value as needed
            ),
          ),
        ),
        onPressed: () {
          action();
        },
        child: Text(
          title,
          style: TextStyle(color: textColor, fontSize: 14),
        ),
      ),
    );
  }
}

class TextPlainButton extends StatelessWidget {
  const TextPlainButton({
    super.key,
    required this.size,
    required this.title,
    required this.action,
    required this.fontSize,
    required this.color,
  });

  final Size size;
  final String title;
  final VoidCallback action;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.w500, color: color)),
        minimumSize: MaterialStateProperty.all(Size(size.width * 0.9, 56)),
      ),
      onPressed: action,
      child: Text(
        title,
        style: TextStyle(color: color),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor = const Color.fromRGBO(0, 134, 181, 1),
    this.alignment = Alignment.topLeft,
  });

  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class TextButtonOnlyBorder extends StatelessWidget {
  const TextButtonOnlyBorder({
    super.key,
    required this.title,
    required this.action,
    required this.borderColor,
    required this.textColor,
    required this.width,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 16,
  });

  final String title;
  final VoidCallback action;
  final Color borderColor;
  final double width;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        ),
        minimumSize: MaterialStateProperty.all(Size(width, 45)),
        side: MaterialStateProperty.all(
          BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(4), // adjust the value as needed
          ),
        ),
      ),
      onPressed: () {
        action();
      },
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
