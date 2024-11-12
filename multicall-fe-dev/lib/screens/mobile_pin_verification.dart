import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/app_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/utils/screen_arguments.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:multicall_mobile/widget/otp_timer.dart';
import 'package:multicall_mobile/widget/pin_input_widget.dart';
import 'package:multicall_mobile/widget/progress_indiactor.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class MobilePinVerificationScreen extends StatefulWidget {
  static const routeName = '/mobile_pin_screen';

  const MobilePinVerificationScreen({super.key});

  @override
  MobilePinVerificationScreenState createState() =>
      MobilePinVerificationScreenState();
}

class MobilePinVerificationScreenState
    extends State<MobilePinVerificationScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final WebSocketService webSocketService = WebSocketService();
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as MobilePinVerificationScreenArguments;

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

    return Consumer<AppController>(
      builder: (BuildContext context, AppController controller, Widget? child) {
        return PopScope(
          onPopInvoked: (bool didPop) async {
            // Handle back button press

            await controller.requestRegistration(args.emailid, args.telephone);

            return; // Return false to prevent default behavior
          },
          child: Scaffold(
            appBar: const CustomAppBar(
              borderColor: Colors.transparent,
              borderWidth: 0,
              middle: Text(
                "Verification",
                style: TextStyle(color: Colors.black, fontSize: 21),
              ),
              showBackButton: false,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  if (!args.isLogin)
                    const Center(
                      child: MyProgressBar(
                        color: Color.fromRGBO(98, 180, 20, 1),
                      ),
                    ),
                  if (!args.isLogin)
                    const GlobalText(
                      padding: EdgeInsets.fromLTRB(15.0, 20, 15.0, 0),
                      alignment: Alignment.topLeft,
                      text: "Step - 2",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(16, 19, 21, 1),
                    ),
                  const GlobalText(
                    padding: EdgeInsets.fromLTRB(10.0, 8, 15.0, 0),
                    alignment: Alignment.topLeft,
                    text: " Verify your mobile number",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(16, 19, 21, 1),
                  ),
                  GlobalText(
                    padding: const EdgeInsets.fromLTRB(15.0, 8, 15.0, 0),
                    alignment: Alignment.topLeft,
                    text:
                        "Enter the 4-digit code sent to +91 XXX${args.telephone.substring(args.telephone.length - 3)}",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(110, 122, 132, 1),
                  ),
                  CustomTextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    alignment: Alignment.topLeft,
                    text: "Edit Mobile Number",
                  ),
                  PinInputWidget(
                    length: 4,
                    controller: _pinPutController,
                    focusNode: _pinPutFocusNode,
                    defaultPinTheme: defaultPinTheme,
                    cursor: cursor,
                    onChanged: (value) {
                      errorMessage = null;
                      if (value.length == 4) {
                        _pinPutFocusNode.unfocus();
                      }
                      setState(() {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 2, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: errorMessage != null
                              ? Text(
                                  errorMessage!,
                                  style:
                                      const TextStyle(color: Color(0XFFFF6666)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )
                              : const SizedBox(),
                        ),
                        OTPTimer(onTap: () {
                          resendSMSOTP(args);
                        }),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 12.0 + MediaQuery.of(context).padding.bottom),
                    child: TextButtonWithBG(
                      title: "Verify Mobile Number",
                      action: () async {
                        if (_pinPutController.text.length != 4) {
                          setState(() {
                            errorMessage = "OTP must be of 4 digits.";
                          });
                        } else {
                          String pin = _pinPutController.text;
                          verifySMSOTP(args, pin);
                        }
                      },
                      width: size.width * 0.9,
                      color: const Color.fromRGBO(98, 180, 20, 1),
                      fontSize: 16,
                      isLoading: isLoading,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> verifySMSOTP(
      MobilePinVerificationScreenArguments args, String pin) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      RegistrationSuccess message = await webSocketService.asyncSendMessage(
        RequestSMSOTPVerificationMessage(
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
            profileController.cloudMessaging();

            Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen.routeName, (Route<dynamic> route) => false);
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

  Future<void> resendSMSOTP(MobilePinVerificationScreenArguments args) async {
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
