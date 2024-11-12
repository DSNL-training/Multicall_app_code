import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/screens/settings_section_screens/verify_email_screen.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/screen_arguments.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/gmail_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class AddEmailIdScreen extends StatefulWidget {
  static const routeName = '/add-email-id';

  const AddEmailIdScreen({super.key});

  @override
  AddEmailIdScreenState createState() => AddEmailIdScreenState();
}

class AddEmailIdScreenState extends State<AddEmailIdScreen> {
  final TextEditingController _gmailController = TextEditingController();
  String emailErrorText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Object args = ModalRoute.of(context)?.settings.arguments ?? {};
      final String emailId = (args as Map)['emailId'] ?? '';
      _gmailController.text = emailId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const CustomAppBar(
          leading: Text("Add Email ID"),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CustomStyledContainer(
                    width: size.width,
                    height: size.height - math.max(size.height * 0.28, 240),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          GmailInputField(
                            size: size.width * 0.9,
                            label: "Enter your email id",
                            errorText: emailErrorText,
                            controller: _gmailController,
                            textInputAction: TextInputAction.next,
                            onChanged: (V) {
                              emailErrorText = "";
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
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextButtonWithBG(
                  title: 'Add',
                  action: () {
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(_gmailController.text)) {
                      emailErrorText = "Please enter a valid email ID";
                      setState(() {});
                    } else {
                      // CALL ADD EMAIL API:
                      // THEN REDIRECT TO OPT SCREEN:

                      requestAddEmail(_gmailController.text);
                    }
                  },
                  isDisabled: _gmailController.text.isEmpty,
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

  Future<void> requestAddEmail(String emailAddress) async {
    var response = await Provider.of<AccountController>(context, listen: false)
        .addNewEmailIDToAccount(emailAddress);

    if (response.status) {
      gotoVerifyOTPScreen(emailAddress);
    } else {
      setState(() {
        emailErrorText =
            "Email Id is already in use in an another MultiCall registration. Please enter a different Email Id.";
      });
    }
  }

  void gotoVerifyOTPScreen(String emailAddress) {
    Navigator.of(context).popAndPushNamed(
      VerifyEmailScreen.routeName,
      arguments: EmailPinVerificationScreenArguments(
        registrationNumber:
            PreferenceHelper.get(PrefUtils.userRegistrationNumber),
        emailid: emailAddress,
        telephone: "",
        userName: "",
      ),
    );
  }
}
