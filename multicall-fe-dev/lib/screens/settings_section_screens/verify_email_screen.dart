import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_email_id_screen.dart';
import 'package:multicall_mobile/utils/screen_arguments.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/common/multicall_plain_text_button.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/otp_timer.dart';
import 'package:multicall_mobile/widget/pin_input_widget.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  static const routeName = '/verify_email_pin_screen';

  const VerifyEmailScreen({super.key});

  @override
  VerifyEmailScreenState createState() => VerifyEmailScreenState();
}

class VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as EmailPinVerificationScreenArguments;
    final size = MediaQuery.of(context).size;
    final defaultPinTheme = PinTheme(
      width: size.width - 56,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(
            color: (errorText == "")
                ? const Color(0XFFCDD3D7)
                : const Color(0XFFFF6666)),
        // color: Color.fromARGB(126, 161, 29, 29),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          middle: Text("Verification"),
          showBackButton: true,
          borderWidth: 0,
          borderColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MultiCallTextWidget(
                    text: "Verify your email",
                    textColor: Color.fromRGBO(16, 19, 21, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.start,
                    lineHeight: 2,
                  ),
                  MultiCallTextWidget(
                    text: "Enter the 2-digit code sent to ${args.emailid}",
                    textColor: const Color.fromRGBO(110, 122, 132, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.start,
                    lineHeight: 1.2,
                  ),
                  MultiCallPlainTextButtonWidget(
                    text: "Edit Email",
                    onPressed: () {
                      // Go to Edit EmailScreen
                      Navigator.of(context).popAndPushNamed(
                        AddEmailIdScreen.routeName,
                        arguments: {"emailId": args.emailid},
                      );
                    },
                    textAlign: TextAlign.start,
                    textColor: const Color(0XFF0086B5),
                    fontSize: 14,
                    // fontWeight: FontWeight.w6x00,
                  ),
                  PinInputWidget(
                    length: 2,
                    controller: _pinPutController,
                    focusNode: _pinPutFocusNode,
                    defaultPinTheme: defaultPinTheme,
                    cursor: cursor,
                    onChanged: (v) {
                      setState(() {
                        errorText = "";
                      });
                    },
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        errorText.isNotEmpty
                            ? Expanded(
                                child: Text(
                                  errorText,
                                  style:
                                      const TextStyle(color: Color(0XFFFF6666)),
                                  maxLines: 3,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OTPTimer(onTap: () {
                            // resendEmailOtp
                            resendOtp(args.emailid);
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: TextButtonWithBG(
                  title: 'Verify Email Address',
                  action: () {
                    //Perform Action Here...
                    validateAndPerformAction();
                  },
                  isDisabled: _pinPutController.text.isEmpty,
                  color: const Color.fromRGBO(98, 180, 20, 1),
                  textColor: Colors.white,
                  fontSize: 16,
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

  void resendOtp(emailId) async {
    await Provider.of<AccountController>(context, listen: false)
        .resendEmailOtp(emailId);
  }

  void validateAndPerformAction() async {
    if (_pinPutController.text.length == 2) {
      // Perform API Call here...
      RequestOTPEmailSuccess response =
          await Provider.of<AccountController>(context, listen: false)
              .verifyNewEmailIDToAddToAccount(
                  int.parse(_pinPutController.text)) as RequestOTPEmailSuccess;
      if (response.status) {
        await Provider.of<AccountController>(context, listen: false)
            .refreshEmails();
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pop();
        });
      } else {
        showToast(response.failReason);
        setState(() {
          errorText = response.failReason;
        });
      }
    } else {
      setState(() {
        errorText = "Invalid OTP";
      });
    }
  }
}
