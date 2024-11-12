import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/utils/app_images.dart';
import 'package:multicall_mobile/utils/truecaller_auth_service.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:provider/provider.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

class TruecallerSSO extends StatefulWidget {
  const TruecallerSSO({
    super.key,
  });

  @override
  State<TruecallerSSO> createState() => _TruecallerSSOState();
}

class _TruecallerSSOState extends State<TruecallerSSO> {
  final TrueCallerAuthService _authHandler = TrueCallerAuthService();
  final WebSocketService webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    _authHandler.init(TcSdk.streamCallbackData, _onSuccess, _onError);
  }

  void _onSuccess(Map<String, dynamic> data) async {
    debugPrint(data.toString());
    if (data["email"].toString().isNotEmpty &&
        data["phone_number"].toString().isNotEmpty) {
      Profile response = await webSocketService.asyncSendMessage(
        RequestRegistration(
          email: data["email"].toString(),
          name: data["given_name"] ?? "",
          phoneNumber: data["phone_number"].toString(),
          socialNetworkFlag: 5,
        ),
      ) as Profile;
      if (response.reactionType == 163) {
        ProfileController profileController = Provider.of<ProfileController>(
          context,
          listen: false,
        );
        await profileController.setUserName(data["given_name"] ?? "");
        await profileController.setEmail(data["email"].toString());
        await profileController.setPhoneNumber(data["phone_number"].toString());
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
      }
    } else {
      showToast("Please use different service to login");
    }
  }

  void _onError(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return DualToneIcon(
      iconSrc: AssetImages.trueCalledLogo,
      press: () {
        _authHandler.startVerification(
          () => _onError("Device not supported"),
          () => _onError("Not Usable"),
        );
      },
    );
  }

  @override
  void dispose() {
    _authHandler.dispose();
    super.dispose();
  }
}
