import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/screens/settings_section_screens/verify_phone_number_screen.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/phone_number_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class AddPhoneNumberWithoutLabelScreen extends StatefulWidget {
  static const routeName = '/add-phone-without-label';
  final String headerText;

  const AddPhoneNumberWithoutLabelScreen({
    super.key,
    this.headerText = "Add Phone Number",
  });

  @override
  AddPhoneNumberWithoutLabelScreenState createState() =>
      AddPhoneNumberWithoutLabelScreenState();
}

class AddPhoneNumberWithoutLabelScreenState
    extends State<AddPhoneNumberWithoutLabelScreen> {
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _phoneNumberFocus = FocusNode();
  String strPhoneError = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: CustomAppBar(
          leading: Text(widget.headerText),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CustomStyledContainer(
                    height: size.height - math.max(size.height * 0.28, 240),
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PhoneNumberInputField(
                            focusNode: _phoneNumberFocus,
                            size: size,
                            label: "Enter your mobile number",
                            errorText: strPhoneError,
                            controller: _numberController,
                            onChanged: (v) {
                              strPhoneError = "";
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: TextButtonWithBG(
                  title: 'Add',
                  action: () {
                    requestToAddNewPhoneNumber();
                  },
                  color: const Color.fromRGBO(98, 180, 20, 1),
                  textColor: Colors.white,
                  fontSize: 16,
                  // iconData: iconData,
                  iconColor: Colors.white,
                  width: size.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> requestToAddNewPhoneNumber() async {
    // Validate phone number
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(_numberController.text)) {
      strPhoneError = 'Please enter a valid phone number';
      setState(() {});
      return;
    }

    var response = await Provider.of<AccountController>(context, listen: false)
        .addNewPhoneNumberToAccount(_numberController.text);

    if (response.status) {
      gotoVerifyOTPScreen();
    } else {
      setState(() {
        strPhoneError =
            "Mobile Number is already in use in an another MultiCall registration. Please enter a different Mobile Number.";
      });
    }
  }

  Future<void> gotoVerifyOTPScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyPhoneNumberScreen(
          phoneNumber: _numberController.text,
        ),
      ),
    );

    if (result != null && result == true) {
      Navigator.pop(context);
    }
  }
}
