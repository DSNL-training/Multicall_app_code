import 'package:flutter/material.dart';
import 'package:multicall_mobile/utils/custom_text_selection.dart';

class NameInputField extends StatefulWidget {
  const NameInputField({
    Key? key,
    required this.size,
    required this.label,
    required this.controller,
    this.onSubmit,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.color = const Color.fromRGBO(142, 152, 160, 1),
    this.maxLength,
    this.errorText = "",
  }) : super(key: key);

  final Size size;
  final String label;
  final String errorText;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;
  final Function(String)? onSubmit;
  final FocusNode? focusNode;
  final int? maxLength;
  final Color color;

  @override
  _NameInputFieldState createState() => _NameInputFieldState();
}

class _NameInputFieldState extends State<NameInputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            cursorColor: Colors.blue,
            mouseCursor: SystemMouseCursors.click,
            keyboardType: TextInputType.name,
            focusNode: widget.focusNode,
            textCapitalization: TextCapitalization.words,
            selectionControls: CustomTextSelectionControls(),
            enableInteractiveSelection: true,
            maxLength: widget.maxLength,
            buildCounter: (context,
                    {required currentLength,
                    required isFocused,
                    required maxLength}) =>
                const SizedBox.shrink(),
            // Ensure interactive selection is enabled
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
              label: Text(widget.label),
              labelStyle: TextStyle(
                color: widget.color,
                fontSize: 14,
                fontWeight: FontWeight.w400,
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
                borderSide: BorderSide(color: Color.fromRGBO(205, 211, 215, 1)),
              ),
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            onSubmitted: widget.onSubmit,
            onChanged: widget.onChanged,
            textInputAction: widget.textInputAction,
          ),
          widget.errorText != ""
              ? const SizedBox(
                  height: 4,
                )
              : const SizedBox.shrink(),
          widget.errorText != ""
              ? Text(
                  widget.errorText,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
