import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  const DropDown({
    Key? key,
    required this.size,
    required this.controller,
    required this.label,
    this.focusNode,
    this.onSubmit,
    this.textInputAction = TextInputAction.done,
    required this.onChanged,
    required this.dropdownValue,
    required this.dropdownItems,
    required this.onDropdownChanged,
  }) : super(key: key);
  final double size;
  final String label;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmit;
  final FocusNode? focusNode;
  final String dropdownValue;
  final List<String> dropdownItems;
  final ValueChanged<String> onDropdownChanged;
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: widget.controller,
                  focusNode: widget.focusNode,
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
                  textInputAction: TextInputAction.next,
                  onSubmitted: widget.onChanged,
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
        ],
      ),
    );
  }
}
