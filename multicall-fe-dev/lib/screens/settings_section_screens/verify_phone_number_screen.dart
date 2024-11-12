import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/common/multicall_plain_text_button.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/otp_timer.dart';
import 'package:multicall_mobile/widget/pin_input_widget.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const routeName = '/verify_mobile_pin_screen';

  const VerifyPhoneNumberScreen({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  VerifyPhoneNumberScreenState createState() => VerifyPhoneNumberScreenState();
}

class VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final defaultPinTheme = PinTheme(
      width: size.width - 56,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(
            color: (errorMessage == null)
                ? const Color(0XFFCDD3D7)
                : const Color(0XFFFF6666)),
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
                    text: "Verify your mobile number",
                    textColor: Color.fromRGBO(16, 19, 21, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.start,
                    lineHeight: 2,
                  ),
                  MultiCallTextWidget(
                    text:
                        "Enter the 4-digit code sent to +91 ${widget.phoneNumber}",
                    textColor: const Color.fromRGBO(110, 122, 132, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.start,
                    lineHeight: 1.2,
                  ),
                  MultiCallPlainTextButtonWidget(
                    text: "Edit Mobile Number",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    textAlign: TextAlign.start,
                    textColor: const Color(0XFF0086B5),
                    fontSize: 14,
                    // fontWeight: FontWeight.w600,
                  ),
                  PinInputWidget(
                    length: 4,
                    controller: _pinPutController,
                    focusNode: _pinPutFocusNode,
                    defaultPinTheme: defaultPinTheme,
                    cursor: cursor,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    onChanged: (value) {
                      errorMessage = null;
                      if (value.length == 4) {
                        _pinPutFocusNode.unfocus();
                      }
                      setState(() {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 2, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        errorMessage != null
                            ? Expanded(
                                child: Text(
                                  errorMessage!,
                                  style:
                                      const TextStyle(color: Color(0XFFFF6666)),
                                  maxLines: 3,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 100,
                          child: OTPTimer(onTap: () {
                            resendSMSOTP();
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
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 12.0,
                  bottom: 12.0 + MediaQuery.of(context).padding.bottom,
                ),
                child: TextButtonWithBG(
                  title: 'Verify Mobile Number',
                  action: () {
                    //Perform Action Here...

                    if (_pinPutController.text.length != 4) {
                      setState(() {
                        errorMessage = "OTP must be of 4 digits.";
                      });
                    } else {
                      String pin = _pinPutController.text;
                      validateAndPerformAction(pin);
                    }
                  },
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

  Future<void> validateAndPerformAction(String pin) async {
    // Perform API Call here...

    errorMessage = null;

    int otp = int.parse(pin);
    var response = await Provider.of<AccountController>(context, listen: false)
        .verifyNewPhoneNumberToAddToAccount(otp);

    if (response.responseStatus == 1) {
      showToast("Number Added Successfully.");

      Provider.of<AccountController>(context, listen: false)
          .getUserPhoneNumberList();

      Navigator.pop(context, true);
    } else {
      if (response.responseStatus == 0) {
        errorMessage = "Failed to Add number, Please try again!";
      } else if (response.responseStatus == 2) {
        errorMessage = "Invalid OTP, Please try again!";
      } else if (response.responseStatus == 3) {
        errorMessage = "Verification Attempt Exceeded, Please try again later!";
      } else if (response.responseStatus == 4) {
        errorMessage = "Resend Attempt Exceeded, Please try again later!";
      } else if (response.responseStatus == 5) {
        errorMessage = "OTP Timed Out, Please try again!";
      }
      setState(() {});
    }
  }

  Future<void> resendSMSOTP() async {
    final WebSocketService webSocketService = WebSocketService();
    int regNum = PreferenceHelper.get(PrefUtils.userRegistrationNumber);
    String email = PreferenceHelper.get(PrefUtils.userEmail);
    String telephone = PreferenceHelper.get(PrefUtils.userPhoneNumber);

    RegistrationSuccess message = await webSocketService.asyncSendMessage(
      RequestResendSMSOTP(
        regNum: regNum,
        telephone: telephone,
        email: email,
        phoneNumber: widget.phoneNumber,
      ),
    ) as RegistrationSuccess;

    if (message.status == true) {
      debugPrint("OTP Sent");
      showToast("OTP sent to entered Mobile Number");
    } else {
      // Display Error Message...
      debugPrint("Failed to send OTP");
      showToast(message.failReason);
    }
  }
}
