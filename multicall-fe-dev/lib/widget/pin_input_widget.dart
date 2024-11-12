import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final PinTheme defaultPinTheme;
  final Widget cursor;
  final int length;
  final void Function(String)? onChanged;
  final EdgeInsets padding;

  const PinInputWidget({
    required this.controller,
    required this.focusNode,
    required this.defaultPinTheme,
    required this.cursor,
    required this.length,
    this.onChanged,
    this.padding = const EdgeInsets.all(10.0),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Pinput(
          onChanged: onChanged,
          length: length,
          controller: controller,
          focusNode: focusNode,
          defaultPinTheme: defaultPinTheme,
          androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
          smsCodeMatcher: '\\d{4}',
          separatorBuilder: (index) => const SizedBox(width: 8),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0XFF2F383F)),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                  offset: Offset(0, 3),
                  blurRadius: 16,
                ),
              ],
            ),
          ),
          submittedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              color: Colors.white,
              border: Border.all(color: const Color(0XFF2F383F)),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                  offset: Offset(0, 3),
                  blurRadius: 16,
                ),
              ],
            ),
          ),
          showCursor: true,
          cursor: cursor,
        ),
      ),
    );
  }
}
