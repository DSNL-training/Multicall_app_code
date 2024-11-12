import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/instant_call/request_add_conferee_to_call.dart';
import 'package:multicall_mobile/models/instant_call/request_code_call_review_rate.dart';
import 'package:multicall_mobile/models/instant_call/request_mute_all.dart';
import 'package:multicall_mobile/models/instant_call/request_mute_call.dart';
import 'package:multicall_mobile/models/instant_call/request_record_call.dart';
import 'package:multicall_mobile/models/instant_call/request_redial_all.dart';
import 'package:multicall_mobile/models/instant_call/request_redial_participant.dart';
import 'package:multicall_mobile/models/instant_call/request_un_mute_call.dart';
import 'package:multicall_mobile/models/member_list_model.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/models/response_advertise_requirement_details.dart';
import 'package:multicall_mobile/models/response_bulk_update.dart';
import 'package:multicall_mobile/models/response_conference_status.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/providers/full_screen_ad_provider.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/screens/call_now/maximum_member_alert_bottomsheet.dart';
import 'package:multicall_mobile/screens/instant_call_screen_call_now.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/generic_bottomsheet_dialog.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';

class InstantCallProvider extends BaseProvider {
  final WebSocketService webSocketService = WebSocketService();
  final List<MemberListModel> _memberList = [];
  InstantCallStatus _callStatus = InstantCallStatus.standby;
  String callFailReason = "";
  Profile? _selectedProfile;
  int _scheduleRefNumber = 0;
  int _conferenceRefNumber = 0;
  String _selectedCallMeOnNumber = "";

  /// bulk update response object
  ResponseBulkUpdate? _bulkUpdateData;

  /// get bulk update response
  ResponseBulkUpdate? get bulkUpdateData => _bulkUpdateData;

  /// set bulk update response
  void setBulkUpdateData(ResponseBulkUpdate? response) {
    _bulkUpdateData = response;
    notifyListeners();
  }

  /// add multiple conferences to bulk update
  void addConferences(List<ConferenceParticipant> conferences) {
    _bulkUpdateData?.conferences.addAll(conferences);
    notifyListeners();
  }

  /// Get Call Status
  InstantCallStatus get callStatus => _callStatus;

  /// Set Call Status
  void setCallStatus(InstantCallStatus status) {
    _callStatus = status;
    notifyListeners();
  }

  /// get Selected Profile
  Profile? get selectedProfile => _selectedProfile;

  /// set Selected Profile
  void setProfile(Profile? profile) {
    _selectedProfile = profile;
  }

  /// get Schedule Reference Number
  int get scheduleRefNumber => _scheduleRefNumber;

  /// set Schedule Reference Number
  void setScheduleReferenceNumber(int refNumber) {
    _scheduleRefNumber = refNumber;
  }

  /// get Conference Reference Number
  int get conferenceRefNumber => _conferenceRefNumber;

  /// set Schedule Reference Number
  void setConferenceReferenceNumber(int refNumber) {
    _conferenceRefNumber = refNumber;
  }

  /// Get Call Me On Number
  String get callMeOnNumber => _selectedCallMeOnNumber;

  /// Set Call Me On Number
  void setCallMeOnNumber(String number) {
    _selectedCallMeOnNumber = number;
  }

  List<MemberListModel> get memberList => _memberList;

  void addMember(MemberListModel member) {
    /// add member to bulk update
    ConferenceParticipant newMember = ConferenceParticipant(
      phoneNumber: member.phoneNumber,
      callStatus: CallStatus.onHold,
      muteStatus: MuteStatus.unMuted,
    );

    _bulkUpdateData?.conferences.add(newMember);
    _memberList.add(member);
    notifyListeners();
  }

  void addMembers(List<MemberListModel> members) {
    List<ConferenceParticipant> newMembers = [];

    for (var member in members) {
      ConferenceParticipant newMember = ConferenceParticipant(
        phoneNumber: member.phoneNumber,
        callStatus: CallStatus.onHold,
        muteStatus: MuteStatus.unMuted,
      );
      newMembers.add(newMember);
    }

    _memberList.addAll(members);
    _bulkUpdateData?.conferences.addAll(newMembers);
    notifyListeners();
  }

  void removeMember(String phoneNumber) {
    _bulkUpdateData?.conferences
        .removeWhere((element) => element.phoneNumber == phoneNumber);
    _memberList.removeWhere((element) => element.phoneNumber == phoneNumber);
    notifyListeners();
  }

  void updateMemberStatus(ConferenceParticipant member, CallStatus status) {
    member.callStatus = status;
    notifyListeners();
  }

  void muteMember(ConferenceParticipant member) {
    member.muteStatus = MuteStatus.muted;
    notifyListeners();
  }

  void unMuteMember(ConferenceParticipant member) {
    member.muteStatus = MuteStatus.unMuted;
    notifyListeners();
  }

  bool addMembersToCallNow({
    required List<MemberListModel> newMembers,
    required bool addToActiveCall,
  }) {
    /// Get selected call-me-on number
    final selectedCallMeOnNumber = _selectedCallMeOnNumber;

    /// Check if selected call-me-on number is already added
    if (newMembers
        .any((element) => element.phoneNumber == selectedCallMeOnNumber)) {
      showToast(
          "Call-me-on number added as a participant! Please add a different number to continue.");
      return false;
    }

    var existingMembers = memberList.map((e) => e.phoneNumber).toList();
    if (addToActiveCall) {
      existingMembers = _bulkUpdateData?.conferences
              .map((e) => e.phoneNumber)
              .cast<String>()
              .toList() ??
          [];
    }
    final newMemberCount = newMembers.length;

    if (newMemberCount == 1 &&
        existingMembers.contains(newMembers.first.phoneNumber)) {
      showToast("Number Already Added!, Please select different number.");
      return false;
    }

    for (var member in existingMembers) {
      newMembers.removeWhere((element) => element.phoneNumber == member);
    }
    if (newMemberCount != newMembers.length) {
      showToast("Duplicate number found!");
    }

    /// Add Members To Active Call API:
    if (addToActiveCall) {
      for (var member in newMembers) {
        addConfereeToCall(
          profileRefNumber: _selectedProfile?.profileRefNo ?? 0,
          scheduleRefNumber: _scheduleRefNumber,
          conferenceRefNumber: _conferenceRefNumber,
          contactEmail: "",
          contactName: member.name,
          contactNumber: member.phoneNumber,
        );
      }
    }

    addMembers(newMembers);
    return true;
  }

  ///Call Now APIs
  Future<AdvertiseRequirementDetailsResponse> getAdvertiseRequirementDetails(
      membersLength, int profileRefNumber) async {
    AdvertiseRequirementDetailsResponse response =
        await webSocketService.asyncSendMessage(
      App2MMReqAdvertisementDetails(
        regNum: regNum,
        memberCount: membersLength,
        profileRefNumber: profileRefNumber,
      ),
    ) as AdvertiseRequirementDetailsResponse;

    return response;
  }

  ///InstantPickup api call
  Future<RecievedMessage> instantPickup({
    required int profileRefNumber,
    required int totalMembers,
    required int totalNumberOfMessages,
    required String chairPersonPhoneNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestInstantPickup(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        totalNumberOfMessages: totalNumberOfMessages,
        chairPersonPhoneNumber: chairPersonPhoneNumber,
        profileRefNumber: profileRefNumber,
        callType: 1,
        conferenceStartTime: 0,
        conferenceDuration: -1,
        otherFeatures: -1,
        typeOfStart: 2,
        scheduleRefNumber: 1,
        totalMembers: totalMembers,
        confereeEmail: email,
      ),
    );

    debugPrint("Instant Pickup Response: $response");

    return response;
  }

  ///InstantPickupMembers api call
  Future<RecievedMessage> instantPickupMembers({
    required List<MemberListModel> members,
    required int currentIterationNumber,
    required int membersInCurrentIteration,
    required String chairPersonPhoneNumber,
  }) async {
    List<GroupMembers> tempMembers = [];

    for (var member in members) {
      if ((member.name.length) > 15) {
        tempMembers.add(GroupMembers(
            memberTelephone: member.phoneNumber,
            memberName: member.name.substring(0, 14)));
      } else {
        tempMembers.add(GroupMembers(
            memberTelephone: member.phoneNumber, memberName: member.name));
      }
    }

    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestInstantPickupMembers(
          registrationNumber: regNum,
          chairPersonPhoneNumber: chairPersonPhoneNumber,
          messageNumber: currentIterationNumber,
          totalNumberOfMembers: membersInCurrentIteration,
          members: tempMembers),
    );

    return response;
  }

  ///EndCallForAll api call
  Future<RecievedMessage> endCallForAll({
    required int scheduleRefNumber,
    required int profileRefNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestEndCallAll(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        scheduleRefNumber: scheduleRefNumber,
        profileRefNumber: profileRefNumber,
      ),
    );
    return response;
  }

  ///EndCallParticipant api call
  Future<RecievedMessage> endCallForParticipant({
    required String participantPhoneNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestEndCallParticipant(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        scheduleRefNumber: scheduleRefNumber,
        participantPhoneNumber: participantPhoneNumber,
        profileRefNumber: _selectedProfile?.profileRefNo ?? 0,
      ),
    );
    return response;
  }

  /// MuteCall api call
  Future<RecievedMessage> muteCall({
    required int scheduleRefNumber,
    required String participantPhoneNumber,
    required int profileRefNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestMuteCall(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        scheduleRefNumber: scheduleRefNumber,
        participantPhoneNumber: participantPhoneNumber,
        profileRefNumber: profileRefNumber,
      ),
    );
    return response;
  }

  /// UnmuteCall api call
  Future<RecievedMessage> unMuteCall({
    required int scheduleRefNumber,
    required String participantPhoneNumber,
    required int profileRefNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestUnMuteCall(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        scheduleRefNumber: scheduleRefNumber,
        participantPhoneNumber: participantPhoneNumber,
        profileRefNumber: profileRefNumber,
      ),
    );
    return response;
  }

  /// MuteAll api call
  Future<RecievedMessage> muteAll({
    required int profileRefNumber,
    required int conferenceRefNumber,
    required int scheduleRefNumber,
    required int actionValue,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestMuteAll(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        profileRefNumber: profileRefNumber,
        conferenceRefNumber: conferenceRefNumber,
        scheduleRefNumber: scheduleRefNumber,
        actionValue: actionValue,
      ),
    );
    return response;
  }

  /// Add Conferee To Call api call
  Future<RecievedMessage> addConfereeToCall({
    required int profileRefNumber,
    required int scheduleRefNumber,
    required int conferenceRefNumber,
    required String contactEmail,
    required String contactName,
    required String contactNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestAddConfereeToCall(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        profileRefNumber: profileRefNumber,
        scheduleRefNumber: scheduleRefNumber,
        conferenceRefNumber: conferenceRefNumber,
        contactEmail: contactEmail,
        contactName: contactName,
        contactNumber: contactNumber,
      ),
    );
    return response;
  }

  /// RecordCallAction api call
  Future<RecievedMessage> recordCallAction({
    required int recordAction,
    required int lastConnectedEpochTime,
    required int groupId,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestRecordCallAction(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        profileRefNumber: _selectedProfile?.profileRefNo ?? 0,
        conferenceRefNumber: _conferenceRefNumber,
        scheduleRefNumber: _scheduleRefNumber,
        recordAction: recordAction,
        lastConnectedEpochTime: lastConnectedEpochTime,
        groupId: groupId,
      ),
    );
    return response;
  }

  /// CallReviewRate api call
  Future<RecievedMessage> callReviewRate({
    required int chairpersonPin,
    required int callRate,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestCallReviewRate(
        registrationNumber: regNum,
        chairpersonPin: chairpersonPin,
        callRate: callRate,
      ),
    );
    return response;
  }

  /// RedialAll api call
  Future<RecievedMessage> redialAll({
    required int scheduleRefNumber,
    required int profileRefNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestRedialAll(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        scheduleRefNumber: scheduleRefNumber,
        profileRefNumber: profileRefNumber,
      ),
    );
    return response;
  }

  /// RedialParticipant api call
  Future<RecievedMessage> redialParticipant({
    required int scheduleRefNumber,
    required String participantPhoneNumber,
    required int profileRefNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestRedialParticipant(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        scheduleRefNumber: scheduleRefNumber,
        participantPhoneNumber: participantPhoneNumber,
        profileRefNumber: profileRefNumber,
      ),
    );
    return response;
  }

  Future<void> callFailedWithAlertNumber(int roomAlert) async {
    _callStatus = InstantCallStatus.failed;

    if (roomAlert == 25) {
      final accountController = Provider.of<AccountController>(
          navigatorKey.currentContext!,
          listen: false);

      var paymentOptionResponse = await accountController
              .requestRetailPaymentOption(selectedProfile?.profileRefNo ?? 0)
          as RequestRetailPaymentOptionSuccess;

      /// retailPaymentOption
      /// 1: show Switch to free plan
      /// 2: show Pay overdue
      /// 3: show no option - no need to do anything
      if (paymentOptionResponse.retailPaymentOption == 1) {
        showModalBottomSheet<void>(
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return GenericBottomSheetDialog(
              title: "Do you want to move to the Free Plan?",
              negativeButtonText: "Cancel",
              positiveButtonText: "Ok",
              onTap: () async {
                var response = await accountController.requestSwitchToFreePlan(
                    selectedProfile?.profileRefNo ?? 0);
                // RequestSwitchPlanSuccess
                if (response.status == false) {
                  Navigator.pop(context);

                  /// false means (2- option not available now. Pls try payment option)
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return GenericBottomSheetDialog(
                        title:
                            "This option is unavailable right now. Please select a payment option.",
                        negativeButtonText: "Cancel",
                        positiveButtonText: "See Plans",
                        onTap: () async {
                          navigateToPremiumScreen(context);
                        },
                      );
                    },
                  );
                } else {
                  final adProvider = Provider.of<FullScreenAdProvider>(
                      navigatorKey.currentContext!,
                      listen: false);

                  /// Check is there any ISD numbers if not then start call else call requestActiveStatus API
                  await checkISDNumbersAndStartCall(
                      memberList, accountController, adProvider);
                }
              },
            );
          },
        );
      } else if (paymentOptionResponse.retailPaymentOption == 2) {
        showModalBottomSheet<void>(
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return GenericBottomSheetDialog(
              title: "You have an overdue amount.",
              negativeButtonText: "Cancel",
              positiveButtonText: "See Plans",
              onTap: () {
                navigateToPremiumScreen(context);
              },
            );
          },
        );
      }
    }

    /// For Schedule Call
    final callsController = Provider.of<CallsController>(
        navigatorKey.currentContext!,
        listen: false);
    if (callsController.isStartScheduleInProgress) {
      callsController.isStartScheduleInProgress = false;
    }

    /// show toast message based on room alert
    showToast(getAlertMessage(roomAlert));

    notifyListeners();
  }

  void chairPersonJoinedCall(ResponseConferenceStatus response) {
    _callStatus = InstantCallStatus.chairPersonJoined;
    showToast("Call Success!");

    setScheduleReferenceNumber(response.scheduleRefNo);
    setConferenceReferenceNumber(response.conferenceRefNo);

    if (!navigatorKey.currentContext!.mounted) return;

    /// Get the current route
    final currentRoute = ModalRoute.of(navigatorKey.currentContext!);

    /// Check if the current route is not the HomeScreen route and not null
    if (currentRoute?.settings.name != HomeScreen.routeName &&
        currentRoute?.settings.name != null) {
      /// Remove the current screen from the stack
      Navigator.pop(navigatorKey.currentContext!);
    }

    /// Navigate to instant call screen
    Navigator.of(navigatorKey.currentContext!).pushNamed(
      InstantCallScreenCallNow.routeName,
      arguments: {
        'selectedProfile': selectedProfile,
        'scheduleRefNumber': response.scheduleRefNo,
        'conferenceRefNumber': response.conferenceRefNo,
      },
    );

    notifyListeners();
  }

  void chairPersonDeniedCall(ResponseConferenceStatus response) {
    _callStatus = InstantCallStatus.deniedByChairPerson;
    showToast("Call Denied!");
    notifyListeners();
  }

  Future<void> onClickCallNowButton(FullScreenAdProvider adProvider) async {
    if (memberList.isNotEmpty) {
      var selectedProfileSize = selectedProfile?.profileSize == 0
          ? 4
          : selectedProfile?.profileSize ?? 4;

      if (memberList.length > selectedProfileSize) {
        if (navigatorKey.currentContext != null &&
            !navigatorKey.currentContext!.mounted) return;
        showModalBottomSheet<void>(
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return MaximumMemberAlertBottomSheet(
              onTapSeePlan: () {
                // GOTO PLAN SCREEN
                debugPrint("On Tap See Plans");
              },
            );
          },
        );
      } else {
        /// Check if context is still mounted
        if (navigatorKey.currentContext != null &&
            !navigatorKey.currentContext!.mounted) return;
        final accountController = Provider.of<AccountController>(
            navigatorKey.currentContext!,
            listen: false);
        if (selectedProfile?.accountType == AppConstants.retailPrepaid) {
          /// Check is there any ISD numbers if not then start call else call requestActiveStatus API
          await checkISDNumbersAndStartCall(
            memberList,
            accountController,
            adProvider,
          );
        } else {
          /// start call and add host member
          startCallAndAddHostMember(memberList, adProvider);
        }
      }
    } else {
      showToast("Please add at-least one member to make a call");
    }
  }

  /// navigate to Premium Screen
  void navigateToPremiumScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).pushNamedAndRemoveUntil(
      HomeScreen.routeName,
      (Route<dynamic> route) => false,
    );
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    Future.delayed(
      const Duration(milliseconds: 500),
      () => homeProvider.navigateToPremium(),
    );
  }

  /// Check is there any ISD numbers if not then start call else call requestActiveStatus API
  Future<void> checkISDNumbersAndStartCall(
    List<MemberListModel> memberList,
    AccountController accountController,
    FullScreenAdProvider adProvider,
  ) async {
    /// Check for the ISD numbers of the members
    var hasISDNum =
        hasInternationalNumber(memberList.map((e) => e.phoneNumber).toList());

    if (hasISDNum) {
      var response = await accountController.requestActiveStatus(
          1, selectedProfile?.profileRefNo ?? 0);

      /// responseAllowedStatus
      /// 1 - Show Option
      /// 2 - Do not show Option
      if (response.responseAllowedStatus == 1) {
        showModalBottomSheet<void>(
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return GenericBottomSheetDialog(
              title:
                  "Please either subscribe to the add-on plans or remove ISD numbers from the list",
              negativeButtonText: "Cancel",
              positiveButtonText: "See Plans",
              onTap: () {
                navigateToPremiumScreen(context);
              },
            );
          },
        );
      } else {
        /// start call and add host member
        startCallAndAddHostMember(memberList, adProvider);
      }
    } else {
      /// start call and add host member
      startCallAndAddHostMember(memberList, adProvider);
    }
  }

  /// start call and add host member
  Future<void> startCallAndAddHostMember(
    List<MemberListModel> memberList,
    FullScreenAdProvider adProvider,
  ) async {
    //Call Action:106
    // In response, adStatus == 1 then show ad

    var response = await getAdvertiseRequirementDetails(
        memberList.length, selectedProfile?.profileRefNo ?? 0);

    if (response.adStatus == 1) {
      showModalBottomSheet<void>(
        context: navigatorKey.currentContext!,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context) {
          return GenericBottomSheetDialog(
            title:
                "Since you are on a free profile, you will be played an ad before the call is completed. Explore our paid profiles for an ad-free experience.",
            negativeButtonText: "",
            positiveButtonText: "Ok",
            isOnlyOneButton: true,
            onTap: () async {
              Navigator.pop(context);

              /// Display Interstitial Ad
              if (adProvider.isInterstitialAvailable) {
                /// clear memberList
                adProvider.memberList.clear();

                /// store memberList in adProvider and start call after ad gets closed
                adProvider.memberList = memberList;

                await adProvider.showInterstitial();
              }
            },
          );
        },
      );
    } else {
      requestStartCallAPI(memberList);
    }
  }

  Future<void> requestStartCallAPI(
    List<MemberListModel> memberList,
  ) async {
    int totalIterations = ((memberList.length) / 2).ceil();

    setCallStatus(InstantCallStatus.dialing);
    setProfile(selectedProfile);

    instantPickup(
      profileRefNumber: selectedProfile?.profileRefNo ?? 0,
      totalNumberOfMessages: totalIterations,
      totalMembers: memberList.length,
      chairPersonPhoneNumber: _selectedCallMeOnNumber,
    );

    ///Call Add Members API in For Loop number of totalIterations times
    int currentIterationNumber = 1;
    for (var i = 0; i < (memberList.length); i += 2) {
      List<MemberListModel> members = [
        MemberListModel(
            name: memberList.elementAt(i).name,
            phoneNumber: memberList.elementAt(i).phoneNumber),
      ];

      if ((memberList.length) > i + 1) {
        members.add(MemberListModel(
            name: memberList.elementAt(i + 1).name,
            phoneNumber: memberList.elementAt(i + 1).phoneNumber));
      }

      instantPickupMembers(
        members: members,
        currentIterationNumber: currentIterationNumber,
        membersInCurrentIteration: members.length,
        chairPersonPhoneNumber: _selectedCallMeOnNumber,
      );

      currentIterationNumber++;
    }
  }

  /// Call Bulk Update API
  Future<RecievedMessage> requestBulkUpdate() async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestBulkUpdate(
        registrationNumber: regNum,
      ),
    );
    return response;
  }
}

enum InstantCallStatus {
  dialing,
  joined,
  failed,
  hold,
  standby,
  initiated,
  chairPersonJoined,
  deniedByChairPerson,
}
