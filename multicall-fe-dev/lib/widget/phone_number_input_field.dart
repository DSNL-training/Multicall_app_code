import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multicall_mobile/utils/custom_text_selection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PhoneNumberInputField extends StatefulWidget {
  const PhoneNumberInputField({
    super.key,
    required this.size,
    required this.label,
    required this.errorText,
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
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;
  final Function(String)? onSubmit;
  final FocusNode focusNode;
  final Color borderColor;
  final Color placeHolderColor;
  final int? maxLength;

  @override
  _PhoneNumberInputFieldState createState() => _PhoneNumberInputFieldState();
}

class _PhoneNumberInputFieldState extends State<PhoneNumberInputField> {
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
              contentPadding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
              label: Text(widget.label),
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
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(color: widget.borderColor),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                  RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
            ],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            onSubmitted: widget.onSubmit,
            onChanged: widget.onChanged,
            textInputAction: widget.textInputAction,
            enableInteractiveSelection: true,
            selectionControls: CustomTextSelectionControls(),
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

class CustomDropdownField extends StatefulWidget {
  const CustomDropdownField({
    super.key,
    required this.size,
    required this.label,
    this.onChanged,
    required this.items,
    this.isErrorVisible = false,
    this.errorLabel = "Please select one of the options",
  });

  final Size size;
  final String label;
  final ValueChanged<String>? onChanged;
  final List<String> items;
  final bool isErrorVisible;
  final String errorLabel;

  @override
  CustomDropdownFieldState createState() => CustomDropdownFieldState();
}

class CustomDropdownFieldState extends State<CustomDropdownField> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Accordion(
          maxOpenSections: 1,
          scaleWhenAnimating: false,
          headerBorderColor: const Color.fromRGBO(205, 211, 215, 1),
          headerBorderColorOpened: const Color.fromRGBO(205, 211, 215, 1),
          headerBackgroundColorOpened: const Color.fromRGBO(237, 240, 242, 1),
          contentBackgroundColor: Colors.white,
          contentBorderColor: const Color.fromRGBO(205, 211, 215, 1),
          contentBorderWidth: 1,
          contentHorizontalPadding: 0,
          contentVerticalPadding: 0,
          paddingBetweenClosedSections: 0,
          paddingBetweenOpenSections: 0,
          paddingListHorizontal: 0,
          paddingListBottom: 0,
          paddingListTop: 0,
          flipRightIconIfOpen: false,
          headerBorderRadius: 8,
          headerBorderWidth: 0,
          headerPadding: EdgeInsets.zero,
          rightIcon: const SizedBox.shrink(),
          disableScrolling: true,
          children: [
            AccordionSection(
              contentVerticalPadding: 0,
              header: InputDecorator(
                decoration: InputDecoration(
                  labelText: selectedValue == null ? '' : widget.label,
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(142, 152, 160, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0XffCDD3D7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(205, 211, 215, 1),
                    ),
                  ),
                ),
                child: SizedBox(
                  height: 18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          selectedValue ?? widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: (selectedValue == null)
                                  ? const Color.fromRGBO(142, 152, 160, 1)
                                  : Colors.black),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Color(0xff101315),
                        size: 24,
                      )
                    ],
                  ),
                ),
              ),
              content: Column(
                children: widget.items.map((item) {
                  return ListTile(
                    title: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    trailing: selectedValue == item
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedValue = item;
                      });
                      if (widget.onChanged != null) {
                        widget.onChanged!(item);
                      }
                    },
                  );
                }).toList(),
              ),
              isOpen: false,
            ),
          ],
        ),
        if (widget.isErrorVisible)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorLabel,
              style: const TextStyle(
                  color: Color(0XFFFF6666),
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
      ],
    );
  }
}

class DropdownField extends StatefulWidget {
  const DropdownField({
    super.key,
    required this.size,
    required this.label,
    this.onChanged,
    required this.items,
    this.controller,
  });

  final Size size;
  final String label;
  final ValueChanged<String>? onChanged;
  final List<String> items;
  final TextEditingController? controller;

  @override
  DropdownFieldState createState() => DropdownFieldState();
}

class DropdownFieldState extends State<DropdownField> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    // Initialize dropdownValue based on the controller text if available
    dropdownValue = widget.controller?.text.isNotEmpty == true
        ? widget.controller?.text
        : null;
  }

  @override
  void didUpdateWidget(DropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update dropdownValue if the items have changed and current value is not in the new items list
    if (widget.items != oldWidget.items) {
      if (dropdownValue != null && !widget.items.contains(dropdownValue)) {
        setState(() {
          dropdownValue = widget.items.isNotEmpty ? widget.items[0] : null;
          widget.controller?.text =
              dropdownValue ?? ''; // Update the controller
        });
      }
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    return widget.items.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            icon: Icon(
              PhosphorIconsLight.caretDown,
              color: dropdownValue == null
                  ? const Color.fromRGBO(142, 152, 160, 1)
                  : const Color.fromRGBO(47, 56, 63, 1),
            ),
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
                widget.controller?.text =
                    newValue ?? ''; // Update the controller
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue!);
              }
            },
            items: dropdownItems,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
              label: Text(widget.label),
              labelStyle: const TextStyle(
                color: Color.fromRGBO(142, 152, 160, 1),
                fontSize: 14,
              ),
              fillColor: Colors.white,
              filled: true,
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(color: Color.fromRGBO(47, 56, 63, 1)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(color: Color.fromRGBO(205, 211, 215, 1)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
