import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multicall_mobile/utils/custom_text_selection.dart';

class FeedbackInputField extends StatefulWidget {
  FeedbackInputField({
    Key? key,
    required this.size,
    required this.label,
    required this.controller,
    this.onSubmit,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
  }) : super(key: key);

  final Size size;
  final String label;
  TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final FocusNode? focusNode;

  @override
  _FeedbackInputFieldState createState() => _FeedbackInputFieldState();
}

class _FeedbackInputFieldState extends State<FeedbackInputField> {
  int _remainingCharacters = 240;
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    setState(() {
      _isEmpty = widget.controller.text.isEmpty;
      _remainingCharacters = 240 - widget.controller.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            child: TextFormField(
              controller: widget.controller,
              cursorColor: Colors.blue,
              mouseCursor: SystemMouseCursors.click,
              keyboardType: TextInputType.text,
              focusNode: widget.focusNode,
              maxLength: 240,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              minLines: 6,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: widget.label,
                alignLabelWithHint: true,
                labelStyle: TextStyle(
                  color: _isEmpty
                      ? const Color.fromRGBO(142, 152, 160, 1)
                      : Colors.black,
                  fontSize: 12,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                helperStyle: TextStyle(
                  fontSize: 12,
                  color: _remainingCharacters >= 0 ? Colors.black : Colors.red,
                ),
                contentPadding: const EdgeInsets.fromLTRB(10, 2, 10, 14),
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: _isEmpty
                        ? const Color.fromRGBO(142, 152, 160, 1)
                        : const Color.fromRGBO(47, 56, 63, 1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: _isEmpty
                        ? const Color.fromRGBO(142, 152, 160, 1)
                        : const Color.fromRGBO(47, 56, 63, 1),
                  ),
                ),
                counterText: '',
              ),
              onFieldSubmitted: (value) {
                if (widget.onSubmit != null) {
                  widget.onSubmit!();
                }
              },
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
                setState(() {
                  _remainingCharacters = 240 - value.length;
                });

                if (value.length >= 240) {
                  widget.focusNode?.unfocus();
                  widget.textInputAction = TextInputAction.none;
                } else {
                  widget.textInputAction = TextInputAction.done;
                }
              },
              textInputAction: widget.textInputAction,
              enableInteractiveSelection: true,
              selectionControls: CustomTextSelectionControls(),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '$_remainingCharacters characters remaining',
                style: TextStyle(
                  fontSize: 12,
                  color: _isEmpty
                      ? const Color.fromRGBO(142, 152, 160, 1)
                      : _remainingCharacters >= 0
                          ? Colors.black
                          : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
