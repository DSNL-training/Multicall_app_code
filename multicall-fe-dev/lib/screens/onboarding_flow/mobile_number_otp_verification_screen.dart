import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/common/multicall_plain_text_button.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:multicall_mobile/widget/otp_timer.dart';
import 'package:multicall_mobile/widget/pin_input_widget.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class MobileNumberOTPVerificationScreen extends StatefulWidget {
  final String userName;
  final String phoneNumber;
  final String emailAddress;
  final int registrationNumber;

  const MobileNumberOTPVerificationScreen({
    super.key,
    required this.userName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.registrationNumber,
  });

  @override
  State<MobileNumberOTPVerificationScreen> createState() =>
      _MobileNumberOTPVerificationScreenState();
}

class _MobileNumberOTPVerificationScreenState
    extends State<MobileNumberOTPVerificationScreen> {
  bool isButtonEnabled = true;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final WebSocketService webSocketService = WebSocketService();
  String errorText = "";

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final defaultPinTheme = PinTheme(
      width: size.width - 200,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(
            color: (errorText == "")
                ? const Color(0XFFCDD3D7)
                : const Color(0XFFFF6666)),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          leading: Text("Verification"),
          showBackButton: true,
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
                    onChanged: (v) {
                      setState(() {
                        errorText = "";
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        errorText != ""
                            ? Text(
                                errorText,
                                style:
                                    const TextStyle(color: Color(0XFFFF6666)),
                              )
                            : const SizedBox(),
                        OTPTimer(onTap: () {
                          resendSMSOTP();
                        }),
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
                    if (isButtonEnabled) {
                      //Perform Action Here...
                      validateAndPerformAction();
                    }
                  },
                  color: const Color.fromRGBO(98, 180, 20, 1),
                  textColor: Colors.white,
                  fontSize: 16,
                  isDisabled: !isButtonEnabled,
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

  void validateAndPerformAction() {
    if (_pinPutController.text.length == 4) {
      // Perform API Call here...
      verifyMobileOTP(_pinPutController.text);
    }
  }

  Future<void> verifyMobileOTP(String pin) async {
    RegistrationSuccess response = await webSocketService.asyncSendMessage(
      RequestSMSOTPVerificationMessage(
        regNum: widget.registrationNumber,
        telephone: widget.phoneNumber,
        email: widget.emailAddress,
        otp: pin,
      ),
    ) as RegistrationSuccess;

    if (response.status == true) {
      //Save User Data From Here...
      ProfileController profileController = Provider.of<ProfileController>(
        context,
        listen: false,
      );
      await profileController.setUserName(widget.userName);
      await profileController.setEmail(widget.emailAddress);
      await profileController.setPhoneNumber(widget.phoneNumber);
      await profileController
          .setRegNum(widget.registrationNumber)
          .then((value) {
        Provider.of<BaseProvider>(context, listen: false).reset();
      });
      await profileController.getProfiles().then((value) async {
        Provider.of<CallsController>(context, listen: false).initAPIs();

        // isUserRegistered
        await profileController.isUserRegistered(true).then((value) {
          profileController.cloudMessaging();
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen.routeName, (Route<dynamic> route) => false);
          }
        });
      });
    } else {
      debugPrint("Mobile OTP Verification Failed...");
      setState(() {
        errorText = response.failReason;
      });
    }
  }

  Future<void> resendSMSOTP() async {
    RegistrationSuccess message = await webSocketService.asyncSendMessage(
      RequestResendSMSOTP(
        regNum: widget.registrationNumber,
        telephone: widget.phoneNumber,
        email: widget.emailAddress,
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
