import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/member_list_model.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response_did_lists_for_dial_in.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:provider/provider.dart';

class FullScreenAdProvider extends ChangeNotifier
    with LevelPlayInterstitialListener {
  bool _isInterstitialAvailable = false;

  bool get isInterstitialAvailable => _isInterstitialAvailable;

  FullScreenAdProvider() {
    IronSource.setLevelPlayInterstitialListener(this);
    IronSource.loadInterstitial();
  }

  /// schedule call member list
  List<ScheduleCallMember> _scheduleCallMemberList = [];

  /// get scheduleCallMemberList
  List<ScheduleCallMember> get scheduleCallMemberList =>
      _scheduleCallMemberList;

  /// set scheduleCallMemberList
  set scheduleCallMemberList(List<ScheduleCallMember> scheduleCallMemberList) {
    _scheduleCallMemberList = scheduleCallMemberList;
    notifyListeners();
  }

  /// member list
  List<MemberListModel> _memberList = [];

  /// set memberList
  set memberList(List<MemberListModel> memberList) {
    _memberList = memberList;
    notifyListeners();
  }

  /// get memberList
  List<MemberListModel> get memberList => _memberList;

  @override
  void onAdReady(IronSourceAdInfo adInfo) {
    debugPrint("Interstitial - onAdReady: $adInfo");
    _isInterstitialAvailable = true;
    notifyListeners();
  }

  @override
  void onAdLoadFailed(IronSourceError error) {
    debugPrint("Interstitial - onAdLoadFailed: $error");
    _isInterstitialAvailable = false;
    notifyListeners();
  }

  @override
  void onAdOpened(IronSourceAdInfo adInfo) {
    debugPrint("Interstitial - onAdOpened: $adInfo");
  }

  @override
  void onAdClosed(IronSourceAdInfo adInfo) async {
    debugPrint("Interstitial - onAdClosed: $adInfo");
    _isInterstitialAvailable = false;
    notifyListeners();

    /// Load Interstitial again after closed
    IronSource.loadInterstitial();

    /// Start call after ad closed if memberList is not empty
    if (_memberList.isNotEmpty) {
      Provider.of<InstantCallProvider>(navigatorKey.currentContext!,
              listen: false)
          .requestStartCallAPI(_memberList);
    }

    if (_scheduleCallMemberList.isNotEmpty) {
      final provider = Provider.of<CallsController>(
          navigatorKey.currentContext!,
          listen: false);

      final defaultProfile = provider.selectedProfile;

      final filteredCallMeOnList = Provider.of<CallMeOnController>(
              navigatorKey.currentContext!,
              listen: false)
          .filteredCallMeOnList;

      var didListForDialInResponse = await provider.requestDidListsForDialIn(
        appSocketId: 1,
        profileRefNum: defaultProfile?.profileRefNo ?? 0,
      ) as DidListsForDialInResponse;

      if (didListForDialInResponse.dialInDid.isNotEmpty) {
        provider.scheduleCall(
          profileRefNumber: defaultProfile?.profileRefNo ?? 0,
          // Profile reference number
          totalIterations: (provider.getMembers().length / 2).ceil(),
          // Total iterations
          chairPersonPhoneNumber:
              filteredCallMeOnList[provider.getSelectedCallMeOn].callMeOn,
          // Profile Phone number
          callType: provider.getCallType(),
          // Call type: 2
          startType: provider.getTypeOfStart(),
          // Type of start: 1 = auto, 2 = user
          scheduleRefNumber: 1,
          // Schedule reference number
          scheduleName: provider.callName,
          // Schedule name
          totalMembersCount: provider.getMembers().length,
          // Total members count
          conferenceDuration: provider.getConferenceDuration(),
          // Conference duration in minutes
          scheduleStartDateTime: provider.getScheduleStartDateTime(),
          // Schedule start date-time format: 2024-06-27 16:56
          repeatType: provider.getRepeatType(),
          // Repeat type: 0 - Never, 1 - EveryDay, 2 - Every Week, 4 - Every Month
          repeatEndDate:
              DateFormat('yyyy-MM-dd').format(provider.repeatTillDate),
          // Repeat end date format: 2024-06-27
          dialinFlag: provider.dialInFlag,
          // Dialin flag: dialout = 0, dialin = 1
          dialinDid: didListForDialInResponse.dialInDid, // Dialin ID
        );

        List<List<ScheduleCallMember>> pairs = [];

        // Group members into pairs
        for (int i = 0; i < provider.getMembers().length; i += 2) {
          if (i + 1 < provider.getMembers().length) {
            pairs.add([provider.getMembers()[i], provider.getMembers()[i + 1]]);
          } else {
            pairs.add([provider.getMembers()[i]]);
          }
        }

        // Simulate API calls for each pair
        for (int i = 0; i < pairs.length; i++) {
          List<ScheduleCallMember> pair = pairs[i];
          // Perform API call with pair
          provider.scheduleMembers(
            chairPersonPhoneNumber:
                filteredCallMeOnList[provider.getSelectedCallMeOn].callMeOn,
            messageNumber: i + 1,
            members: pair,
          );
        }
      }
    }
  }

  @override
  void onAdShowFailed(IronSourceError error, IronSourceAdInfo adInfo) {
    debugPrint("Interstitial - onAdShowFailed: $error, $adInfo");
    _isInterstitialAvailable = false;
    notifyListeners();
  }

  @override
  void onAdClicked(IronSourceAdInfo adInfo) {
    debugPrint("Interstitial - onAdClicked: $adInfo");
  }

  @override
  void onAdShowSucceeded(IronSourceAdInfo adInfo) {
    debugPrint("Interstitial - onAdShowSucceeded: $adInfo");
  }

  Future<void> showInterstitial() async {
    final isCapped = await IronSource.isInterstitialPlacementCapped(
        placementName: "Default");
    debugPrint('Default placement capped: $isCapped');
    if (!isCapped && await IronSource.isInterstitialReady()) {
      IronSource.showInterstitial();
    }
  }
}
