import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/app_controller.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/screens/onboarding_screen.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:provider/provider.dart';

class NotificationController extends BaseProvider {
  final WebSocketService webSocketService = WebSocketService();

  NotificationController() {}

  String confName = "";
  String scheduleDateTime = "";
  String updatedEndDateTime = "";
  String chairpersonName = "";
  String chairpersonNumber = "";
  int scheduleRefNo = 0;
  int confDuration = 0;
  int repeatType = 0;
  int recurrentId = 0;

  saveData(
    String confNameValue,
    String scheduleDateTimeValue,
    String updatedEndDateTimeValue,
    String chairpersonNameValue,
    String chairpersonNumberValue,
    int scheduleRefNoValue,
    int confDurationValue,
    int repeatTypeValue,
    int recurrentIdValue,
  ) {
    confName = confNameValue;
    scheduleDateTime = scheduleDateTimeValue;
    updatedEndDateTime = updatedEndDateTimeValue;
    chairpersonName = chairpersonNameValue;
    chairpersonNumber = chairpersonNumberValue;
    scheduleRefNo = scheduleRefNoValue;
    confDuration = confDurationValue;
    repeatType = repeatTypeValue;
    recurrentId = recurrentIdValue;
  }

  Future initialCalls() async {
    if ((PreferenceHelper.get(PrefUtils.isUserRegistered) == true)) {
      // Calling reconnect API
      await Provider.of<CallsController>(navigatorKey.currentContext!,
              listen: false)
          .reconnect();

      // Calling invitationSync API
      AppController appController = Provider.of<AppController>(
          navigatorKey.currentContext!,
          listen: false);
      await appController.invitationSync();
      await appController.invitationSyncCancel();

      Provider.of<CallsController>(navigatorKey.currentContext!, listen: false);

      Provider.of<CallMeOnController>(
        navigatorKey.currentContext!,
        listen: false,
      ).callMeOnRestore();

      Provider.of<GroupController>(navigatorKey.currentContext!, listen: false)
          .syncGroup();

      Provider.of<ProfileController>(
        navigatorKey.currentContext!,
        listen: false,
      ).getDeviceDetails().then(
            (value) => {
              Provider.of<ProfileController>(
                navigatorKey.currentContext!,
                listen: false,
              ).cloudMessaging()
            },
          );
    } else {
      Navigator.of(navigatorKey.currentContext!)
          .pushReplacementNamed(OnBoardingScreen.routeName);
    }
  }
}
