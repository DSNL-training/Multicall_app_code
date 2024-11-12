import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/screens/onboarding_flow/email_address_otp_verification_screen.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/gmail_input_field.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class EditEmailAddressScreen extends StatefulWidget {
  final String? emailAddress;
  final String number;
  final String userName;
  final int socialNetworkFlag;

  const EditEmailAddressScreen(
      {super.key,
      this.emailAddress,
      required this.number,
      required this.socialNetworkFlag,
      required this.userName});

  @override
  State<EditEmailAddressScreen> createState() => _EditEmailAddressScreenState();
}

class _EditEmailAddressScreenState extends State<EditEmailAddressScreen> {
  final FocusNode _emailAddressFocus = FocusNode();
  String emailErrorText = "";
  TextEditingController _emailController = TextEditingController(text: "");
  bool isButtonEnabled = false;
  bool isLoading = false;
  final WebSocketService webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkIfFieldsAreFilled);
    _emailController = TextEditingController(text: widget.emailAddress);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          leading: Text("Email Verification"),
          showBackButton: false,
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
                  GmailInputField(
                    focusNode: _emailAddressFocus,
                    size: size.width * 0.9,
                    label: "Enter your email id",
                    errorText: emailErrorText,
                    controller: _emailController,
                    onChanged: (v) {
                      isButtonEnabled = v.isNotEmpty;
                      setState(() {});
                    },
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
                    //Perform Action Here...
                    validateAndPerformAction();
                  },
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
    );
  }

  void _checkIfFieldsAreFilled() {
    emailErrorText = "";

    setState(() {});
  }

  void validateAndPerformAction() {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text)) {
      emailErrorText = "Please enter a valid email ID";
      setState(() {
        emailErrorText = "Please enter valid email address";
      });
    } else {
      FocusScope.of(context).unfocus();
      callRegistrationAPI(_emailController.text);
    }
  }

  Future<void> callRegistrationAPI(String email) async {
    // TODO: Handle if number is null (Route to Number verification screen)
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestRegistration(
        email: email,
        name: widget.userName,
        phoneNumber: widget.number,
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
        await profileController.setEmail(email);
        await profileController.setPhoneNumber(widget.number);
        await profileController.setRegNum(defaultProfile.regNum).then((value) {
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
        RegistrationSuccess success = response as RegistrationSuccess;
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailAddressOTPVerificationScreen(
                emailAddress: _emailController.text,
                number: widget.number,
                userName: widget.userName,
                socialNetworkFlag: widget.socialNetworkFlag,
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
}
