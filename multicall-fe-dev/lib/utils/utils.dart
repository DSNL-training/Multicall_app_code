import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/response_invitation_sync.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/signup_screen.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

showSnackBar(String? text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text!,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
      ),
      backgroundColor: Colors.black,
    ),
  );
}

/// Shows a toast with the given [message] using the [BuildContext] [context].
///
/// The toast will appear at the bottom of the screen and will be visible for
/// [duration] seconds. The toast will have a black background and white text.
///
/// If the [context] is null, this method does nothing.
///
/// This method is a wrapper around [FToast.showToast].
showToast(String message) {
  if (navigatorKey.currentContext == null) return;
  FToast()
    ..init(navigatorKey.currentContext!)
    ..showToast(
      toastDuration: const Duration(seconds: 2),
      gravity: ToastGravity.BOTTOM,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.black,
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
}

showToastOld(String message) {
  Fluttertoast.showToast(
    toastLength: Toast.LENGTH_LONG,
    msg: message,
    gravity: ToastGravity.BOTTOM,
    fontSize: 16.0,
  );
}

Future<void> launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    debugPrint('Could not launch $url');
  }
}

String processPhoneNumber(String? phone) {
  if (phone == null) return "";
  phone = phone.replaceAll(' ', '');
  if (phone.length == 12 && phone.startsWith('91')) {
    phone = phone.substring(2);
  }
  return phone;
}

Future<void> logout(BuildContext context) async {
  await PreferenceHelper.clear().then((value) async {
    await PreferenceHelper.load().then((value) async {
      PreferenceHelper.set(PrefUtils.watchedIntro, true);

      /// Set selected index of Multicall Tab
      Provider.of<HomeProvider>(context, listen: false).setSelectedIndex(0);

      /// Clear Call Controller All Data
      Provider.of<CallsController>(context, listen: false)
          .clearCallControllerAllData();

      /// Clear Profile Controller All Data
      Provider.of<ProfileController>(context, listen: false)
          .clearProfileControllerAllData();

      /// Clear Account Controller All Data
      Provider.of<AccountController>(context, listen: false)
          .clearAccountControllerAllData();

      /// Clear CallMeOn Controller All Data
      Provider.of<CallMeOnController>(context, listen: false)
          .clearCallMeOnControllerAllData();

      /// Clear Bulk Update Data and navigate to Home Screen
      Provider.of<InstantCallProvider>(context, listen: false)
          .setBulkUpdateData(null);

      Provider.of<BaseProvider>(context, listen: false).reset();

      /// Navigate to SignupScreen after logout is successful
      Navigator.of(context).pushNamedAndRemoveUntil(
        SignupScreen.routeName,
        (Route<dynamic> route) => false,
      );
    });
  });
}

/// Get alert message based on room alert
String getAlertMessage(int roomAlert) {
  switch (roomAlert) {
    case 1:
      return "Open conference in process. (Alert Code: $roomAlert)";
    case 2:
      return "Conference already opened. (Alert Code: $roomAlert)";
    case 3:
      return "Unscheduled details. (Alert Code: $roomAlert)";
    case 4:
      return "Instant call failure for disabled profile. (Alert Code: $roomAlert)";
    case 5:
      return "Scheduled call failure for disabled profile. (Alert Code: $roomAlert)";
    case 6:
      return "Auto call failure for disabled profile. (Alert Code: $roomAlert)";
    case 7:
      return "Cannot initiate call. Try later. (Alert Code: $roomAlert)";
    case 8:
      return "Invalid call me on phone number length. (Alert Code: $roomAlert)";
    case 9:
      return "Invalid participant count. (Alert Code: $roomAlert)";
    case 10:
      return "Invalid participant name length. (Alert Code: $roomAlert)";
    case 11:
      return "Invalid participant phone number length. (Alert Code: $roomAlert)";
    case 12:
      return "Could not start the call. (Alert Code: $roomAlert)";
    case 13:
      return "Could not start your scheduled call. (Alert Code: $roomAlert)";
    case 14:
      return "Scheduled call: Invalid call me on phone number length. (Alert Code: $roomAlert)";
    case 15:
      return "Could not start scheduled call: Invalid participant count. (Alert Code: $roomAlert)";
    case 16:
      return "Could not start scheduled call: Invalid participant name length. (Alert Code: $roomAlert)";
    case 17:
      return "Could not start the call: Invalid participant phone number length. (Alert Code: $roomAlert)";
    case 18:
      return "Could not start the scheduled call. (Alert Code: $roomAlert)";
    case 19:
      return "Could not reschedule your call. Please try again later. (Alert Code: $roomAlert)";
    case 20:
      return "Could not reschedule your call: Invalid participant count. (Alert Code: $roomAlert)";
    case 21:
      return "Could not reschedule your call: Invalid participant name length. (Alert Code: $roomAlert)";
    case 22:
      return "Could not reschedule your call: Invalid phone number length. (Alert Code: $roomAlert)";
    case 23:
      return "Could not reschedule your call. Please try again later. (Alert Code: $roomAlert)";
    case 24:
      return "Could not cancel your call. Please try again later. (Alert Code: $roomAlert)";
    case 25:
      return "No balance for call start. (Alert Code: $roomAlert)";
    case 26:
      return "Profile detail not found. (Alert Code: $roomAlert)";
    case 27:
      return "Profile size exceeds limit. (Alert Code: $roomAlert)";
    case 28:
      return "ISD allow status. (Alert Code: $roomAlert)";
    default:
      return "Call failed! (Alert Code: $roomAlert)";
  }
}

/// Checks if there is any international number in the provided list of phone numbers.
///
/// A phone number is considered international if it starts with "+" or "00", and
/// does not start with "0091" or "+91".
///
/// Example:
///
/// ```dart
/// List<String> phoneNumbers = [
///   "+919876543210",
///   "00919876543210",
///   "+1234567890",
///   "001234567890",
///   "9876543210"
/// ];
///
/// bool result = hasInternationalNumber(phoneNumbers);
///
/// print(result); // true
/// ```
///
/// [phoneNumbers] - A list of phone numbers to check.
///
/// Returns `true` if any phone number in the list is an international number, otherwise `false`.
bool hasInternationalNumber(List<String> phoneNumbers) {
  const String check2 = "0091";
  const String check3 = "+91";

  for (String phoneNumber in phoneNumbers) {
    if (phoneNumber.startsWith("+") || phoneNumber.startsWith("00")) {
      if (!phoneNumber.startsWith(check2) && !phoneNumber.startsWith(check3)) {
        return true;
      }
    }
  }
  return false;
}

Map<String, dynamic> decodeString(String input) {
  // Step 1: Remove starting /* and ending */
  if (input.startsWith('/*') && input.endsWith('*/')) {
    input = input.substring(2, input.length - 2);
  }

  // Step 2: Remove first 5 characters
  input = input.substring(5);

  // Step 3: Decode Base64
  List<int> decodedBytes = base64.decode(input);
  String decodedString = utf8.decode(decodedBytes);

  // Step 4: Convert the decoded string to a Map
  Map<String, dynamic> decodedMap = jsonDecode(decodedString);

  return decodedMap;
}

ResponseInvitationSync? findObjectByScheduleRefNo(
    List<ResponseInvitationSync> list, String scheduleRefNo) {
  try {
    return list
        .singleWhere((item) => item.scheduleRefNo.toString() == scheduleRefNo);
  } catch (e) {
    print('Error finding object: $e');
    return null;
  }
}

getPercentage(percent, amount) {
  return (amount) * (percent / 100);
}
