import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:multicall_mobile/screens/onboarding_screen.dart';
import 'package:multicall_mobile/screens/schedule_invitation_notification_screen.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = "/splash-screen";

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await PreferenceHelper.load();
    await Future.delayed(const Duration(seconds: 2)).then((value) => {
          if (mounted)
            {
              _navigateToNextScreen(),
            }
        });
  }

  void _navigateToNextScreen() async {
    Map<String, dynamic>? notificationData;
    if (Platform.isAndroid) {
      RemoteMessage? message =
          await FirebaseMessaging.instance.getInitialMessage();
      notificationData = message?.data;
    }
    if ((PreferenceHelper.get(PrefUtils.isUserRegistered) == true)) {
      if (Platform.isAndroid &&
          notificationData != null &&
          notificationData["schedule_ref_number"] != 0 &&
          notificationData["push_type"].toString() == "1") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ScheduledInvitationNotificationScreen(
            confName: notificationData?["conf_name"],
            scheduleRefNo:
                int.parse(notificationData?["schedule_ref_number"] ?? "0"),
            scheduleDateTime: notificationData?["schedule_start_date_time"],
            updatedEndDateTime: notificationData?["schedule_end_date_time"],
            confDuration: int.parse(notificationData?["conference_duration"]),
            chairpersonName: notificationData?["chairperson_name"],
            repeatType: int.parse(notificationData?["repeat_type"]),
            recurrentId: int.parse(notificationData?["recurrent_id"]),
          ),
        ));
      } else {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    } else {
      Navigator.of(context).pushReplacementNamed(OnBoardingScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/multicall_logo.png',
              width: 327,
              height: 110,
            ),
          ],
        ),
      ),
    );
  }
}
