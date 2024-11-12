// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/app_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/screens/mobile_pin_verification.dart';
import 'package:multicall_mobile/utils/screen_arguments.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/otp_timer.dart';
import 'package:multicall_mobile/widget/pin_input_widget.dart';
import 'package:multicall_mobile/widget/progress_indiactor.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class EmailPinVerificationScreen extends StatefulWidget {
  static const routeName = '/email_pin_screen';

  const EmailPinVerificationScreen({super.key});

  @override
  EmailPinVerificationScreenState createState() =>
      EmailPinVerificationScreenState();
}

class EmailPinVerificationScreenState
    extends State<EmailPinVerificationScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final WebSocketService webSocketService = WebSocketService();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinPutFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as EmailPinVerificationScreenArguments;

    ProfileController profileController = Provider.of<ProfileController>(
      context,
      listen: false,
    );
    profileController.setRegNum(args.registrationNumber);

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

    return Scaffold(
      appBar: const CustomAppBar(
        borderColor: Colors.transparent,
        borderWidth: 0,
        middle: Text(
          "Verification",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
        ),
        showBackButton: false,
      ),
      body: Consumer<AppController>(
        builder:
            (BuildContext context, AppController controller, Widget? child) {
          return PopScope(
            onPopInvoked: (bool didPop) async {
              // Handle back button press

              await controller.requestRegistration(
                args.emailid,
                args.telephone,
              );
              return; // Return false to prevent default behavior
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  const Center(
                    child: MyProgressBar(),
                  ),
                  const GlobalText(
                    padding: EdgeInsets.fromLTRB(15.0, 20, 15.0, 0),
                    alignment: Alignment.topLeft,
                    text: "Step - 1",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(16, 19, 21, 1),
                  ),
                  const GlobalText(
                    padding: EdgeInsets.fromLTRB(10.0, 8, 15.0, 0),
                    alignment: Alignment.topLeft,
                    text: " Verify your email",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(16, 19, 21, 1),
                  ),
                  GlobalText(
                    padding: const EdgeInsets.fromLTRB(15.0, 8, 15.0, 0),
                    alignment: Alignment.topLeft,
                    text:
                        "Enter the 2-digit code sent to xxxx@${args.emailid.split('@')[1]}",
                    fontSize: 14,
                    textAlign: TextAlign.left,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(110, 122, 132, 1),
                  ),
                  CustomTextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    alignment: Alignment.topLeft,
                    text: "Edit Email",
                  ),
                  PinInputWidget(
                    length: 2,
                    controller: _pinPutController,
                    focusNode: _pinPutFocusNode,
                    defaultPinTheme: defaultPinTheme,
                    cursor: cursor,
                    onChanged: (value) {
                      errorMessage = null;
                      if (value.length == 2) {
                        _pinPutFocusNode.unfocus();
                      }
                      setState(() {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 2, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        errorMessage != null
                            ? Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              )
                            : const SizedBox(),
                        OTPTimer(onTap: () {
                          resendEmailOTP(args);
                        }),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextButtonWithBG(
                      title: "Verify Email Address",
                      action: () async {
                        if (_pinPutController.text.length != 2) {
                          setState(() {
                            errorMessage = "OTP must be 2 digits long.";
                          });
                        } else {
                          String pin = _pinPutController.text;
                          verifyEmailOTP(args, pin);
                        }
                      },
                      width: size.width * 0.9,
                      color: const Color.fromRGBO(98, 180, 20, 1),
                      fontSize: 16,
                      isLoading: isLoading,
                    ),
                  ),
                  SizedBox(height: 16 + MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> verifyEmailOTP(
      EmailPinVerificationScreenArguments args, String pin) async {
    setState(() {
      isLoading = true;
      errorMessage = null; // Clear any previous error messages
    });

    try {
      RegistrationSuccess message = await webSocketService.asyncSendMessage(
        RequestEmailOTPVerificationMessage(
          regNum: args.registrationNumber,
          telephone: args.telephone,
          email: args.emailid,
          otp: pin,
        ),
      ) as RegistrationSuccess;

      if (message.status == true) {
        debugPrint("Email Pin Verify Response: Status True");
        Navigator.of(context).pushReplacementNamed(
          MobilePinVerificationScreen.routeName,
          arguments: MobilePinVerificationScreenArguments(
            registrationNumber: args.registrationNumber,
            emailid: args.emailid,
            telephone: args.telephone,
            userName: args.userName,
          ),
        );
      } else {
        setState(() {
          errorMessage = message.failReason;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred. Please try again.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resendEmailOTP(EmailPinVerificationScreenArguments args) async {
    debugPrint("CALLING RESEND OTP API...");

    RegistrationSuccess message = await webSocketService.asyncSendMessage(
      RequestResendEmailOTP(
        regNum: args.registrationNumber,
        telephone: args.telephone,
        email: args.emailid,
        registeredEmailID: args.emailid,
      ),
    ) as RegistrationSuccess;

    debugPrint("API RESPONSE: $message");

    if (message.status == true) {
      debugPrint("OTP Sent");
      showToast("OTP sent to entered Email Address");
    } else {
      // Display Error Message...
      debugPrint("Failed to send OTP");
    }
  }
}
