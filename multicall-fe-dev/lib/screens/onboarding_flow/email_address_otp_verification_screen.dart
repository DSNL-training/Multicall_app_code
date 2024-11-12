import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/screens/onboarding_flow/edit_email_address_screen.dart';
import 'package:multicall_mobile/utils/screen_arguments.dart';
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

class EmailAddressOTPVerificationScreen extends StatefulWidget {
  final String emailAddress;
  final String number;
  final String userName;
  final int socialNetworkFlag;
  final int registrationNumber;

  const EmailAddressOTPVerificationScreen(
      {super.key,
      required this.emailAddress,
      required this.number,
      required this.userName,
      required this.socialNetworkFlag,
      required this.registrationNumber});

  @override
  State<EmailAddressOTPVerificationScreen> createState() =>
      _EmailAddressOTPVerificationScreenState();
}

class _EmailAddressOTPVerificationScreenState
    extends State<EmailAddressOTPVerificationScreen> {
  bool isButtonEnabled = true;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final WebSocketService webSocketService = WebSocketService();
  bool isLoading = false;
  String? errorMessage;

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
        border: Border.all(color: const Color.fromRGBO(205, 211, 215, 1)),
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
                    text: "Verify your email",
                    textColor: Color.fromRGBO(16, 19, 21, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.start,
                    lineHeight: 2,
                  ),
                  MultiCallTextWidget(
                    text:
                        "Enter the 2-digit code sent to ${widget.emailAddress}",
                    textColor: const Color.fromRGBO(110, 122, 132, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.start,
                    lineHeight: 1.2,
                  ),
                  MultiCallPlainTextButtonWidget(
                    text: "Edit Email Address",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditEmailAddressScreen(
                                  emailAddress: widget.emailAddress,
                                  number: widget.number,
                                  userName: widget.userName,
                                  socialNetworkFlag: widget.socialNetworkFlag,
                                ),
                            fullscreenDialog: true),
                      );
                    },
                    textAlign: TextAlign.start,
                    textColor: const Color(0XFF0086B5),
                    fontSize: 14,
                    // fontWeight: FontWeight.w600,
                  ),
                  PinInputWidget(
                    length: 2,
                    controller: _pinPutController,
                    focusNode: _pinPutFocusNode,
                    defaultPinTheme: defaultPinTheme,
                    cursor: cursor,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 2, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        errorMessage != null
                            ? Text(
                                errorMessage!,
                                style:
                                    const TextStyle(color: Color(0XFFFF6666)),
                              )
                            : const SizedBox(),
                        OTPTimer(onTap: () {
                          resendSMSOTP(
                            EmailPinVerificationScreenArguments(
                              registrationNumber: widget.registrationNumber,
                              telephone: widget.number,
                              emailid: widget.emailAddress,
                              userName: widget.userName,
                            ),
                          );
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
                padding: const EdgeInsets.all(24),
                child: TextButtonWithBG(
                  title: 'Verify Email Address',
                  action: () {
                    if (isButtonEnabled) {
                      {
                        if (_pinPutController.text.length != 2) {
                          setState(() {
                            errorMessage = "OTP must be of 2 digits.";
                          });
                        } else {
                          String pin = _pinPutController.text;
                          verifyEmailOTP(
                              EmailPinVerificationScreenArguments(
                                  registrationNumber: widget.registrationNumber,
                                  emailid: widget.emailAddress,
                                  telephone: widget.number,
                                  userName: widget.userName),
                              pin);
                        }
                      }
                    }
                  },
                  color: const Color.fromRGBO(98, 180, 20, 1),
                  textColor: Colors.white,
                  fontSize: 16,
                  isDisabled: !isButtonEnabled,
                  iconColor: Colors.white,
                  isLoading: isLoading,
                  width: size.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyEmailOTP(
      EmailPinVerificationScreenArguments args, String pin) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
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
        // Save User Data In Local Pref.
        ProfileController profileController = Provider.of<ProfileController>(
          context,
          listen: false,
        );
        await profileController.setUserName(args.userName);
        await profileController.setEmail(args.emailid);
        await profileController.setPhoneNumber(args.telephone);
        await profileController
            .setRegNum(args.registrationNumber)
            .then((value) {
          Provider.of<BaseProvider>(context, listen: false).reset();
        });
        await profileController.getProfiles().then((value) async {
          Provider.of<CallsController>(context, listen: false).initAPIs();

          // isUserRegistered
          await profileController.isUserRegistered(true).then((value) {
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.routeName, (Route<dynamic> route) => false);
            }
          });
        });
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

  Future<void> resendSMSOTP(EmailPinVerificationScreenArguments args) async {
    RegistrationSuccess message = await webSocketService.asyncSendMessage(
      RequestResendSMSOTP(
        regNum: args.registrationNumber,
        telephone: args.telephone,
        email: args.emailid,
        phoneNumber: args.telephone,
      ),
    ) as RegistrationSuccess;

    if (message.status == true) {
      debugPrint("OTP Sent");
      showToast("OTP sent to entered Mobile Number");
    } else {
      // Display Error Message...
      debugPrint("Failed to send OTP");
    }
  }
}
