// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/auth_user.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/screens/email_pin_verification_screen.dart';
import 'package:multicall_mobile/screens/help_screen.dart';
import 'package:multicall_mobile/screens/mobile_pin_verification.dart';
import 'package:multicall_mobile/screens/onboarding_flow/mobile_number_screen.dart';
import 'package:multicall_mobile/utils/app_images.dart';
import 'package:multicall_mobile/utils/auth_handler.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/screen_arguments.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/gmail_input_field.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:multicall_mobile/widget/name_input_field.dart';
import 'package:multicall_mobile/widget/or_divider.dart';
import 'package:multicall_mobile/widget/phone_number_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:multicall_mobile/widget/truecaller_sso_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const routeName = "/signup-screen";

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _gmailController =
      TextEditingController(text: "");
  final TextEditingController _namecontroller = TextEditingController(text: "");
  final TextEditingController _phoneNumberController =
      TextEditingController(text: "");
  final WebSocketService webSocketService = WebSocketService();
  bool isLoading = false;
  bool isButtonEnabled = false;
  Color nameFieldColor = const Color.fromRGBO(142, 152, 160, 1);
  Color emailFieldColor = const Color.fromRGBO(205, 211, 215, 1);
  Color emailPlaceHolderColor = const Color.fromRGBO(142, 152, 160, 1);
  Color phoneNumberFieldColor = const Color.fromRGBO(205, 211, 215, 1);
  Color phoneNumberPlaceHolderColor = const Color.fromRGBO(142, 152, 160, 1);

  String emailErrorText = "";
  String phoneNumberErrorText = "";

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _gmailController.addListener(_checkIfFieldsAreFilled);
    _namecontroller.addListener(_checkIfFieldsAreFilled);
    _phoneNumberController.addListener(_checkIfFieldsAreFilled);
  }

  @override
  void dispose() {
    _gmailController.dispose();
    _namecontroller.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _checkIfFieldsAreFilled() {
    String name = _namecontroller.text;
    String email = _gmailController.text;
    String phoneNumber = _phoneNumberController.text;

    emailErrorText = "";
    phoneNumberErrorText = "";

    setState(() {
      isButtonEnabled =
          name.isNotEmpty && email.isNotEmpty && phoneNumber.isNotEmpty;
      nameFieldColor = const Color.fromRGBO(205, 211, 215, 1);
      emailFieldColor = const Color.fromRGBO(205, 211, 215, 1);
      phoneNumberFieldColor = const Color.fromRGBO(205, 211, 215, 1);

      nameFieldColor = const Color(0XFF4e5d69);
      emailPlaceHolderColor = const Color(0XFF4e5d69);
      phoneNumberPlaceHolderColor = const Color(0XFF4e5d69);
    });
  }

  Future<void> handleSignup({
    required String name,
    required String email,
    required String phoneNumber,
    int? socialNetworkFlag,
    bool isSSO = false,
  }) async {
    var allDataValidated = true;
    if (!isSSO) {
      if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email)) {
        emailErrorText = "Please enter a valid email ID";
        emailFieldColor = const Color(0XFFFF6666);
        emailPlaceHolderColor = const Color(0XFFFF6666);
        allDataValidated = false;
      }
      if (!RegExp(r'^[0-9]{10,15}$').hasMatch(phoneNumber)) {
        phoneNumberErrorText = "Please enter a valid phone number";
        phoneNumberFieldColor = const Color(0XFFFF6666);
        phoneNumberPlaceHolderColor = const Color(0XFFFF6666);
        allDataValidated = false;
      }
      if (name.isEmpty || name == "") {
        allDataValidated = false;
      }

      if (allDataValidated) {
        setState(() {
          isLoading = true;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        return;
      }

      RegistrationSuccess response = await webSocketService.asyncSendMessage(
        RequestRegistration(
          email: email,
          name: name,
          phoneNumber: phoneNumber,
          socialNetworkFlag: socialNetworkFlag,
        ),
      ) as RegistrationSuccess;

      setState(() {
        isLoading = false;
      });

      if (!response.status) {
        showToast(response.failReason);
        return;
      }

      if (response.primaryRegFlag == 2) {
        // Login
        //if primaryRegFlag == 2 then open mobile otp verification screen then
        //after successful verification goto Home scree.

        Navigator.of(context).pushNamed(
          MobilePinVerificationScreen.routeName,
          arguments: MobilePinVerificationScreenArguments(
            registrationNumber: response.regNum,
            emailid: email,
            telephone: phoneNumber,
            userName: name,
            isLogin: true,
          ),
        );
      } else if (!(response.isEmailRegistered ?? false)) {
        // Here Email is not verified:
        // Goto Verify Email OTP screen.
        // Then Goto Verify Mobile OTP screen.
        // Then Goto Home screen.

        Navigator.of(context).pushNamed(
          EmailPinVerificationScreen.routeName,
          arguments: EmailPinVerificationScreenArguments(
            registrationNumber: response.regNum,
            emailid: email,
            telephone: phoneNumber,
            userName: name,
          ),
        );
      } else if (!(response.isTelNoRegistered ?? false)) {
        // Here Only Mobile is not verified:
        // Goto Verify Mobile OTP screen.
        // Then Goto Home screen.

        Navigator.of(context).pushNamed(
          MobilePinVerificationScreen.routeName,
          arguments: MobilePinVerificationScreenArguments(
            registrationNumber: response.regNum,
            emailid: email,
            telephone: phoneNumber,
            userName: name,
            isLogin: false,
          ),
        );
      }

      debugPrint("signup screen ${response.reactionType}");
    } else {
      debugPrint("Please fill all the fields");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                style: TextStyle(
                  fontFamily:
                      ThemeData().primaryTextTheme.titleLarge?.fontFamily,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
                "Get Started",
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: customIconButton(
                padding: EdgeInsets.zero,
                iconData: PhosphorIcons.question(),
                onPressed: () {
                  Navigator.of(context).pushNamed(HelpScreen.routeName);
                },
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: isKeyboardShowing
                            ? (16.0 + MediaQuery.of(context).padding.bottom)
                            : 100.0,
                      ),
                      child: Column(
                        children: [
                          // const SizedBox(height: 15),
                          const GlobalText(
                            text:
                                "Let’s get you started by verifying\nyour credentials",
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          NameInputField(
                            size: size,
                            label: "Enter your name",
                            controller: _namecontroller,
                            focusNode: _nameFocus,
                            onChanged: (v) {
                              //FocusScope.of(context).requestFocus(_emailFocus);
                            },
                            color: nameFieldColor,
                          ),
                          const SizedBox(height: 20),
                          GmailInputField(
                            focusNode: _emailFocus,
                            size: size.width * 0.9,
                            label: "Enter your email id",
                            errorText: emailErrorText,
                            controller: _gmailController,
                            textInputAction: TextInputAction.next,
                            onChanged: (v) {
                              //FocusScope.of(context).requestFocus(_phoneNumberFocus);
                            },
                            borderColor: emailFieldColor,
                            placeHolderColor: emailPlaceHolderColor,
                          ),
                          const SizedBox(height: 20),
                          PhoneNumberInputField(
                            focusNode: _phoneNumberFocus,
                            size: size,
                            label: "Enter your mobile number",
                            errorText: phoneNumberErrorText,
                            controller: _phoneNumberController,
                            borderColor: phoneNumberFieldColor,
                            placeHolderColor: phoneNumberPlaceHolderColor,
                          ),
                          const SizedBox(height: 22),
                          TextButtonWithBG(
                            action: () {
                              if (isButtonEnabled) {
                                () async {
                                  FocusScope.of(context).unfocus();
                                  String name = _namecontroller.text;
                                  String email = _gmailController.text;
                                  String phoneNumber =
                                      _phoneNumberController.text;

                                  await handleSignup(
                                    name: name,
                                    email: email,
                                    phoneNumber: phoneNumber,
                                  );
                                }();
                              } else {
                                print('Button not enabled');
                              }
                            },
                            title: 'Continue',
                            isDisabled: !isButtonEnabled,
                            width: size.width * 0.9,
                            color: const Color.fromRGBO(98, 180, 20, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: 10),
                          const OrDivider(),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DualToneIcon(
                                iconSrc: AssetImages.facebookLogo,
                                press: () async {
                                  final LoginResult result =
                                      await FacebookAuth.instance.login();
                                  if (result.status == LoginStatus.success) {
                                    final userData = await FacebookAuth.instance
                                        .getUserData();
                                    if (userData["name"].isEmpty ||
                                        userData["email"].isEmpty) {
                                      showToast(
                                        "Unable to retrieve information from Facebook Login",
                                      );
                                      return;
                                    }
                                    ssoLogin(
                                      userData["name"],
                                      userData["email"],
                                      2,
                                    );
                                  } else {
                                    debugPrint(result.message);
                                  }
                                },
                              ),
                              DualToneIcon(
                                iconSrc: AssetImages.googleLogo,
                                press: () async {
                                  AuthHandler authHandler = AuthHandler();
                                  AuthUser user =
                                      await authHandler.googleSignIn();
                                  if (user.name.isEmpty || user.email.isEmpty) {
                                    showToast(
                                      "Unable to retrieve information from Google Login",
                                    );
                                    return;
                                  }
                                  ssoLogin(
                                    user.name,
                                    user.email,
                                    3,
                                  );
                                },
                              ),
                              if (Platform.isIOS)
                                DualToneIcon(
                                  iconSrc: AssetImages.appleLogo,
                                  press: () async {
                                    AuthHandler authHandler = AuthHandler();
                                    AuthUser user =
                                        await authHandler.appleSignIn();
                                    if (user.name.isEmpty ||
                                        user.email.isEmpty) {
                                      showToast(
                                        "Unable to retrieve Email from Apple Login",
                                      );
                                      return;
                                    }
                                    ssoLogin(
                                      user.name,
                                      user.email,
                                      4,
                                    );
                                  },
                                ),
                              if (Platform.isAndroid) const TruecallerSSO(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isKeyboardShowing,
                    child: Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          top: 16.0,
                          bottom: 16.0 + MediaQuery.of(context).padding.bottom,
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "By Signing up, you agree to our ",
                            style: const TextStyle(
                                color: Color.fromRGBO(110, 122, 132, 1)),
                            children: [
                              TextSpan(
                                text: "Terms of Condition",
                                style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url =
                                        'https://multicall.in/terms-conditions/';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                              ),
                              const TextSpan(
                                style: TextStyle(
                                  color: Color.fromRGBO(110, 122, 132, 1),
                                ),
                                text: " and ",
                              ),
                              TextSpan(
                                text: "Privacy Policy ",
                                style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url =
                                        'https://multicall.in/privacy-policy/';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void ssoLogin(String name, String email, int socialFlag) async {
    RequestPrimaryEmailCheckSuccess response =
        await webSocketService.asyncSendMessage(
      RequestCodeCheckEmailIdPrimaryCheck(
        emailId: email,
        appSocketId: 1,
        socialNetworkFlag: socialFlag,
      ),
    ) as RequestPrimaryEmailCheckSuccess;
    if (response.reactionType != 102 && response.regNum != 0) {
      if (response.primaryRegFlag == 2) {
        ProfileController profileController = Provider.of<ProfileController>(
          context,
          listen: false,
        );
        await profileController.setUserName(name);
        await profileController.setEmail(response.requestedEmailId);
        await profileController.setPhoneNumber(response.regPhone);
        await profileController.setRegNum(response.regNum).then((value) {
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
      } else if (response.primaryRegFlag == 1) {
        gotoVerifyMobileNumber(
          name: name,
          email: email,
          socNetworkFlag: socialFlag,
        );
      }
    } else if (response.primaryRegFlag == 1) {
      gotoVerifyMobileNumber(
        name: name,
        email: email,
        socNetworkFlag: socialFlag,
      );
    } else {
      RegistrationSuccess regResponse = await webSocketService.asyncSendMessage(
        RequestRegistration(
          email: email,
          name: name,
          phoneNumber: response.regPhone,
          socialNetworkFlag: 1,
        ),
      ) as RegistrationSuccess;

      if (!regResponse.status) {
        showToast(regResponse.failReason);
        return;
      }
    }
  }

  void gotoVerifyMobileNumber({
    required String email,
    required String name,
    required int socNetworkFlag,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileNumberScreen(
          emailAddress: email,
          userName: name,
          socialNetworkFlag: socNetworkFlag,
        ),
      ),
    );
  }
}
