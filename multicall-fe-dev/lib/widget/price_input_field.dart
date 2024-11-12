import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multicall_mobile/utils/custom_text_selection.dart';

class PriceInputField extends StatefulWidget {
  const PriceInputField({
    super.key,
    required this.size,
    required this.label,
    required this.errorText,
    required this.hintText,
    required this.hintTextColor,
    required this.controller,
    this.onSubmit,
    required this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.borderColor = const Color(0XffCDD7D7),
    this.placeHolderColor = const Color.fromRGBO(142, 152, 160, 1),
    this.maxLength = 15,
  });

  final Size size;
  final String label;
  final String errorText;
  final String hintText;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;
  final Function(String)? onSubmit;
  final FocusNode focusNode;
  final Color borderColor;
  final Color placeHolderColor;
  final Color hintTextColor;
  final int? maxLength;

  @override
  PriceInputFieldState createState() => PriceInputFieldState();
}

class PriceInputFieldState extends State<PriceInputField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    // Listen to the focus changes
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    // Remove the focus listener when the widget is disposed
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            cursorColor: Colors.blue,
            mouseCursor: SystemMouseCursors.click,
            focusNode: widget.focusNode,
            maxLength: widget.maxLength,
            buildCounter: (context,
                {required currentLength,
                required isFocused,
                required maxLength}) {
              return const SizedBox.shrink();
            },
            decoration: InputDecoration(
              prefixIcon: AnimatedContainer(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: _isFocused
                      ? const Color.fromRGBO(72, 82, 90, 1)
                      : const Color.fromRGBO(205, 211, 215, 1),
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(10)),
                ),
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.currency_rupee,
                  size: 14,
                  color: _isFocused
                      ? const Color.fromRGBO(205, 211, 215, 1)
                      : const Color.fromRGBO(72, 82, 90, 1),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                left: 20.0,
                right: 10.0,
              ), // 10px extra on the left
              label: Text(widget.label),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              floatingLabelAlignment: null,
              labelStyle: TextStyle(
                color: widget.placeHolderColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: "Lato",
              ),
              fillColor: Colors.white,
              filled: true,
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Color.fromRGBO(47, 56, 63, 1),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Color.fromRGBO(205, 211, 215, 1),
                ),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onSubmitted: widget.onSubmit,
            onChanged: widget.onChanged,
            textInputAction: widget.textInputAction,
            enableInteractiveSelection: true,
            selectionControls: CustomTextSelectionControls(),
          ),
          widget.errorText != ""
              ? Text(
                  widget.errorText,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                )
              : Text(
                  widget.hintText,
                  style: TextStyle(
                      color: widget.hintTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
        ],
      ),
    );
  }
}
