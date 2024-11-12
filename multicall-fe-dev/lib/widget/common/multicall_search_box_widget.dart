import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multicall_mobile/utils/app_images.dart';

class MultiCallSearchBoxWidget extends StatefulWidget {
  final String hintText;
  final Color backgroundColor;
  final Color borderColor;
  final Function(String) onChanged;

  const MultiCallSearchBoxWidget({
    super.key,
    this.hintText = "",
    this.borderColor = Colors.black,
    this.backgroundColor = Colors.white,
    required this.onChanged,
  });

  @override
  State<MultiCallSearchBoxWidget> createState() => _MultiCallSearchBoxWidgetState();
}

class _MultiCallSearchBoxWidgetState extends State<MultiCallSearchBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        border: Border.all(
          color: widget.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.asset(
              AssetImages.iconSearch,
              height: 24,
              width: 24,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                cursorColor: Colors.black,
                onChanged: (v) {
                  widget.onChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
