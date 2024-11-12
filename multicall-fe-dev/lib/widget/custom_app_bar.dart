import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final Color? backgroundColor;
  final double? borderWidth;
  final Color? borderColor;
  final bool? showBackButton;
  final VoidCallback? onBackIconTap;

  const CustomAppBar({
    super.key,
    this.leading,
    this.middle,
    this.trailing,
    this.backgroundColor,
    this.borderWidth,
    this.borderColor,
    this.showBackButton = true,
    this.onBackIconTap,
  });

  Widget _applyTextStyleIfNeeded(Widget? widget,
      {double? fontSize, Color? textColor}) {
    if (widget is Text) {
      return Text(
        widget.data!,
        style: TextStyle(
          fontFamily: ThemeData().primaryTextTheme.titleLarge?.fontFamily,
          decoration: widget.style?.decoration,
          fontSize: fontSize ?? widget.style?.fontSize ?? 20.0,
          fontWeight: FontWeight.w700,
          color: textColor ?? widget.style?.color,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
        softWrap: false,
      );
    } else {
      return widget ?? const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor ?? const Color.fromRGBO(205, 211, 215, 1),
            width: borderWidth ?? 1.0,
          ),
        ),
      ),
      child: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            // Leading Widget (back button and custom leading widget)
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showBackButton ?? false)
                    BackIcon(onBackIconTap: onBackIconTap),
                  if (leading != null)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 2,
                      ),
                      child: _applyTextStyleIfNeeded(leading),
                    ),
                ],
              ),
            ),

            // Middle Widget (title)
            Center(
              child: _applyTextStyleIfNeeded(
                middle,
                fontSize: 20.0, // Adjusted font size for better fit
              ),
            ),

            // Trailing Widget
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [if (trailing != null) trailing!],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BackIcon extends StatelessWidget {
  final VoidCallback? onBackIconTap;

  const BackIcon({super.key, this.onBackIconTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16),
      color: Colors.transparent,
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: onBackIconTap ??
            () {
              Navigator.pop(context);
            },
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            border: Border.all(
              color: const Color(0XFFCDD3D7),
              width: 1,
            ),
          ),
          child: const Icon(
            PhosphorIconsRegular.arrowLeft,
            color: Colors.black,
            size: 22,
          ),
        ),
      ),
    );
  }
}
