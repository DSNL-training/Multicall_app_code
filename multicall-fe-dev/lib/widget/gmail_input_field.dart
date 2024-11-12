import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multicall_mobile/utils/custom_text_selection.dart';

class GmailInputField extends StatefulWidget {
  const GmailInputField({
    Key? key,
    required this.size,
    required this.controller,
    required this.label,
    required this.errorText,
    this.focusNode,
    this.onSubmit,
    this.textInputAction = TextInputAction.done,
    required this.onChanged,
    this.borderColor = const Color(0XffCDD7D7),
    this.placeHolderColor = const Color.fromRGBO(142, 152, 160, 1),
  }) : super(key: key);
  final double size;
  final String label;
  final String errorText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmit;
  final FocusNode? focusNode;
  final Color borderColor;
  final Color placeHolderColor;

  @override
  State<GmailInputField> createState() => _GmailInputFieldState();
}

class _GmailInputFieldState extends State<GmailInputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: widget.controller,
            focusNode: widget.focusNode,
            cursorColor: Colors.blue,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            mouseCursor: SystemMouseCursors.click,
            buildCounter: (context,
                {required currentLength,
                required isFocused,
                required maxLength}) {
              return const SizedBox.shrink();
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
              label: Text(widget.label),
              labelStyle: TextStyle(
                color: widget.placeHolderColor,
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
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(color: widget.borderColor),
              ),
            ),
            enableInteractiveSelection: true,
            selectionControls: CustomTextSelectionControls(),
            textInputAction: TextInputAction.next,
            onSubmitted: widget.onChanged,
            onChanged: widget.onChanged,
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
                      color: Color(0XFFFF6666),
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class GmailInputFieldWithDropDown extends StatefulWidget {
  const GmailInputFieldWithDropDown({
    Key? key,
    required this.size,
    required this.controller,
    required this.label,
    this.onSubmit,
    this.textInputAction = TextInputAction.done,
    required this.onChanged,
    required this.dropdownValue,
    required this.dropdownItems,
    required this.onDropdownChanged,
    required FocusNode focusNode,
  }) : super(key: key);
  final double size;
  final String label;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmit;
  final String dropdownValue;
  final List<String> dropdownItems;
  final ValueChanged<String> onDropdownChanged;

  @override
  _GmailInputFieldWithDropDownState createState() =>
      _GmailInputFieldWithDropDownState();
}

class _GmailInputFieldWithDropDownState
    extends State<GmailInputFieldWithDropDown> {
  late FocusNode _textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    _textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RawKeyboardListener(
            focusNode: _textFieldFocusNode,
            onKey: (RawKeyEvent event) {
              if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                // Open dropdown when arrow down key is pressed
                _textFieldFocusNode.requestFocus();
                if (widget.dropdownItems.isNotEmpty) {
                  showDropdownMenu(context);
                }
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: widget.controller,
                    focusNode: _textFieldFocusNode,
                    cursorColor: Colors.blue,
                    mouseCursor: SystemMouseCursors.click,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
                      labelText: widget.label,
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(78, 93, 105, 1),
                        fontSize: 12,
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
                        borderSide:
                            BorderSide(color: Color.fromRGBO(47, 56, 63, 1)),
                      ),
                    ),
                    enableInteractiveSelection: true,
                    textInputAction: widget.textInputAction,
                    onSubmitted: (value) {
                      widget.onChanged(value);
                      if (widget.onSubmit != null) {
                        widget.onSubmit!();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: widget.dropdownValue,
                  onChanged: (String? value) {
                    if (value != null) {
                      widget.onDropdownChanged(value);
                    }
                  },
                  items: widget.dropdownItems.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showDropdownMenu(BuildContext context) {
    final RenderBox? textFieldRenderBox =
        context.findRenderObject() as RenderBox?;
    if (textFieldRenderBox != null) {
      final Offset textFieldOffset =
          textFieldRenderBox.localToGlobal(Offset.zero);
      final double dropdownYOffset =
          textFieldOffset.dy + textFieldRenderBox.size.height;

      final RelativeRect dropdownRect = RelativeRect.fromLTRB(
        textFieldOffset.dx,
        dropdownYOffset,
        textFieldOffset.dx + textFieldRenderBox.size.width,
        dropdownYOffset,
      );

      showMenu<String>(
        context: context,
        position: dropdownRect,
        items: widget.dropdownItems.map<PopupMenuEntry<String>>((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ).then((String? result) {
        if (result != null) {
          widget.onDropdownChanged(result);
        }
      });
    }
  }
}
