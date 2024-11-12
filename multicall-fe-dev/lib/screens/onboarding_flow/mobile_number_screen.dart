import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/app_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/screens/onboarding_flow/mobile_number_otp_verification_screen.dart';
import 'package:multicall_mobile/screens/signup_screen.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:multicall_mobile/widget/phone_number_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class MobileNumberScreen extends StatefulWidget {
  final String emailAddress;
  final String userName;
  final int socialNetworkFlag;

  const MobileNumberScreen({
    super.key,
    required this.emailAddress,
    required this.userName,
    required this.socialNetworkFlag,
  });

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final FocusNode _phoneNumberFocus = FocusNode();
  String phoneNumberErrorText = "";
  final TextEditingController _phoneNumberController = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoading = false;
  final WebSocketService webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_checkIfFieldsAreFilled);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (value) {
          showConfirmationBottomSheet(context);
          return;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            middle: const Text("Phone Verification"),
            showBackButton: true,
            onBackIconTap: () {
              showConfirmationBottomSheet(context);
            },
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PhoneNumberInputField(
                      focusNode: _phoneNumberFocus,
                      size: size,
                      label: "Enter your mobile number",
                      errorText: phoneNumberErrorText,
                      controller: _phoneNumberController,
                    ),
                  ],
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextButtonWithBG(
                    title: 'Continue',
                    action: () {
                      // if (isButtonEnabled) {
                      //Perform Action Here...
                      validateAndPerformAction();
                    },
                    // },
                    color: const Color.fromRGBO(98, 180, 20, 1),
                    textColor: Colors.white,
                    fontSize: 16,
                    isDisabled: !isButtonEnabled,
                    iconColor: Colors.white,
                    width: size.width,
                    isLoading: isLoading,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkIfFieldsAreFilled() {
    String phoneNumber = _phoneNumberController.text;

    phoneNumberErrorText = "";

    setState(() {
      isButtonEnabled = phoneNumber.isNotEmpty;
    });
  }

  void validateAndPerformAction() {
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(_phoneNumberController.text)) {
      FocusScope.of(context).unfocus();
      setState(() {
        isLoading = true;
      });

      callRegistrationAPI(_phoneNumberController.text);
    } else {
      setState(() {
        phoneNumberErrorText = "Please enter valid phone number";
      });
    }
  }

  Future<void> callRegistrationAPI(String phoneNumber) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestRegistration(
        email: widget.emailAddress,
        name: widget.userName,
        phoneNumber: phoneNumber,
        socialNetworkFlag: widget.socialNetworkFlag,
      ),
    );
    setState(() {
      isLoading = false;
    });
    if (response.status == true) {
      if (response.reactionType == 163) {
        ProfileController profileController = Provider.of<ProfileController>(
          context,
          listen: false,
        );
        Profile defaultProfile = response as Profile;
        await profileController.setUserName(widget.userName);
        await profileController.setEmail(widget.emailAddress);
        await profileController.setPhoneNumber(phoneNumber);
        await profileController.setRegNum(defaultProfile.regNum).then((value) {
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
        RegistrationSuccess success = response as RegistrationSuccess;
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MobileNumberOTPVerificationScreen(
                userName: widget.userName,
                phoneNumber: phoneNumber,
                emailAddress: widget.emailAddress,
                registrationNumber: success.regNum,
              ),
            ),
          );
        }
      }
    } else {
      RegistrationSuccess success = response as RegistrationSuccess;
      debugPrint("Registration Failed...");
      showToast(success.failReason);
    }
  }

  void showConfirmationBottomSheet(context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                      child: Center(
                        child: Container(
                          height: 6,
                          width: 46,
                          decoration: const BoxDecoration(
                            color: Color(0XFFCDD3D7),
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const MultiCallTextWidget(
                      text: "Are you sure to abort your registration?",
                      textColor: Color(0XFF101315),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: MultiCallTextWidget(
                        text:
                            "Note: Please do this only if you have made an error in your Email ID or Mobile number",
                        textColor: Color(0XFF6E7A84),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const Divider(
                      height: 1,
                      color: Color(0XFFDDE1E4),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                              child: MultiCallOutLineButtonWidget(
                                text: "Cancel",
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                borderColor: const Color(0XFFDDE1E4),
                                textColor: const Color(0XFF101315),
                                borderRadius: 8,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: MultiCallOutLineButtonWidget(
                                text: "Ok",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                textColor: Colors.white,
                                borderRadius: 8,
                                backgroundColor: const Color(0XFF0086B5),
                                borderColor: const Color(0XFF0086B5),
                                onTap: () async {
                                  final controller = Provider.of<AppController>(
                                      context,
                                      listen: false);
                                  controller.requestRegistration(
                                      widget.emailAddress, "");
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
