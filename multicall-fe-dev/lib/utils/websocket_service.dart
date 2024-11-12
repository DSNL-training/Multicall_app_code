// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/instant_call/response_call_record.dart';
import 'package:multicall_mobile/models/instant_call/response_conferee_speaking.dart';
import 'package:multicall_mobile/models/instant_call/response_mute_call.dart';
import 'package:multicall_mobile/models/instant_call/response_un_mute_call.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/models/response_advertise_requirement_details.dart';
import 'package:multicall_mobile/models/response_bulk_update.dart';
import 'package:multicall_mobile/models/response_call_me_on_restore.dart';
import 'package:multicall_mobile/models/response_call_me_on_update.dart';
import 'package:multicall_mobile/models/response_cancel_sync.dart';
import 'package:multicall_mobile/models/response_change_conferee_list.dart';
import 'package:multicall_mobile/models/response_conference_status.dart';
import 'package:multicall_mobile/models/response_customer_care_number.dart';
import 'package:multicall_mobile/models/response_did_lists_for_dial_in.dart';
import 'package:multicall_mobile/models/response_invitation_sync.dart';
import 'package:multicall_mobile/models/response_mccm_delete_schedule.dart';
import 'package:multicall_mobile/models/response_merged_schedule_calls_n_members.dart';
import 'package:multicall_mobile/models/response_reconnect.dart';
import 'package:multicall_mobile/models/response_redial_all.dart';
import 'package:multicall_mobile/models/response_reschedule_call.dart';
import 'package:multicall_mobile/models/response_restore_call_history.dart';
import 'package:multicall_mobile/models/response_restore_schedule_members.dart';
import 'package:multicall_mobile/models/response_restore_schedule_start.dart';
import 'package:multicall_mobile/models/response_room_alert.dart';
import 'package:multicall_mobile/models/response_schedule_delete.dart';
import 'package:multicall_mobile/models/response_schedule_members.dart';
import 'package:multicall_mobile/models/response_schedule_pickup_mccm.dart';
import 'package:multicall_mobile/models/response_start_schedule_call.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/providers/speaking_provider.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/widget/common/loader.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() => _instance;

  WebSocketService._internal();

  WebSocketChannel? _channel;
  final StreamController<RecievedMessage> _streamController =
      StreamController.broadcast();

  Map<int, ScheduleDetail> scheduleDetailsMap = {};
  Map<int, List<ScheduleCallMembers>> scheduleMembersMap = {};
  List<MergedScheduleCallResponse> mergedResponses = [];

  // clear all the variables related to merge schedule calls
  void clearMergedScheduleCallsData() {
    scheduleDetailsMap = {};
    scheduleMembersMap = {};
    mergedResponses = [];
  }

  void connect(String url) async {
    try {
      if (_channel != null) {
        _channel?.sink.close();
      }
      _channel = WebSocketChannel.connect(Uri.parse(url));
      // debugger();
      await _channel?.ready;
      _channel?.stream.listen(
        _onMessageReceived,
        onError: _onError,
        onDone: _onDone,
      );
      debugPrint('Connected');
    } catch (e) {
      debugPrint('WebSocket connection error: $e');
    }
  }

  void sendMessage(RequestMessage message) {
    final jsonString = json.encode(
      {
        "action": message.action,
        "data": message.toJson(),
      },
    );
    log("Sending Message to WebSocket ==> $jsonString");
    _channel!.sink.add(jsonString);
  }

  void _onMessageReceived(dynamic message) {
    log("Message Received from WebSocket ==> $message");
    final jsonResponse = jsonDecode(message); // convert message to json string
    final response = toRecivedMessageFromJSON(
      jsonResponse,
    ); // handle json response and convert it to respective class
    _streamController.sink.add(response);
  }

  void _onError(dynamic error) {
    debugPrint('WebSocket error: $error');
  }

  void reconnect({int i = 0}) async {
    BuildContext? currentContext = navigatorKey.currentState?.context;
    try {
      if (Loader.loaderCount == 0) {
        Loader.showLoader(currentContext!);
      }
      connect(AppConstants().websocketUrl);
      await _channel?.ready;
      Loader.hideLoader(currentContext!);
    } catch (e) {
      if (i < 3) {
        Timer(const Duration(seconds: 10), () => reconnect(i: ++i));
      } else {
        if (currentContext != null) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            SnackBar(
              content: const Text(
                "Unable to reconnect. Please try again later",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              backgroundColor: Colors.black,
              action: SnackBarAction(
                label: "Retry",
                onPressed: () {
                  reconnect(i: 0);
                },
              ),
              duration: const Duration(seconds: 10),
            ),
          );
        }
      }
    }
  }

  void _onDone() {
    debugPrint('WebSocket connection closed');
    reconnect();
  }

  Stream<dynamic> get messages => _streamController.stream;

  void disconnect() async {
    debugPrint('Disconnected');
    _channel?.sink.close();
    await _streamController.sink.close();
  }

  Future<RecievedMessage> asyncSendMessage(RequestMessage message) async {
    sendMessage(message);

    // Listen for the response
    final completer = Completer<RecievedMessage>();
    final subscription = _streamController.stream.listen(null);
    subscription.onData((RecievedMessage recievedMessage) {
      if (message.expectedReactionTypes
          .contains(recievedMessage.reactionType)) {
        completer.complete(recievedMessage);
        subscription.cancel();
      }
    });

    return completer.future;
  }

  RecievedMessage toRecivedMessageFromJSON(dynamic json) {
    int? reactionType = json['reactionType'];
    switch (reactionType) {
      case 24:
        return ResponseEndCallSuccess.fromJson(json);
      case 101:
      case 102:
      case 128:
      case 127:
        return RegistrationSuccess.fromJson(json);
      case 163:
        Profile defaultProfile = Profile.fromJson(json);
        ProfileController profileController = Provider.of<ProfileController>(
          navigatorKey.currentContext!,
          listen: false,
        ); // Assign the profile controller
        profileController.defaultProfile = defaultProfile;
        profileController.notify();
        return defaultProfile;
      case 137:
        ProfileController profileController = Provider.of<ProfileController>(
          navigatorKey.currentContext!,
          listen: false,
        ); // Assign the profile controller
        var profile = RestoreProfileSuccess.fromJson(json);
        profileController
            .addProfile(profile); // Add profile to the controller's list
        return profile;
      case 138:
        GroupController groupController = Provider.of<GroupController>(
          navigatorKey.currentContext!,
          listen: false,
        ); // Assign the profile controller
        RestoreGroupsSuccess group = RestoreGroupsSuccess.fromJson(json);
        groupController.addGroup(group); // Add group to the controller's list
        groupController.setIsGroupFetching = false;
        return group;
      case 139:
        GroupController groupController = Provider.of<GroupController>(
          navigatorKey.currentContext!,
          listen: false,
        ); // Assign the profile controller
        FetchGroupMembersResponse group =
            FetchGroupMembersResponse.fromJson(json);
        groupController
            .addGroupMembers(group); // Add group to the controller's list
        return group;
      case 131: // Reconnect response
        return ReconnectResponse.fromJson(json);
      case 141:
        return UserPhoneNumberListResponse.fromJson(json);
      case 147: // Invitation sync response
        var response = ResponseInvitationSync.fromJson(json);
        if (response.confName.isNotEmpty) {
          debugPrint("Invitation sync response before: $json");
          if (response.inviteStatus != 3) {
            debugPrint("Invitation sync response after: $json");
            Provider.of<CallsController>(navigatorKey.currentContext!,
                    listen: false)
                .addInvitation(response);
          }
        }
        return response;
      case 158: // Cancel Sync response
        debugPrint("Cancel Sync response: $json");
        return ResponseCancelSync.fromJson(json);
      case 105:
        return ResponseAddEmailSuccess.fromJson(json);
      case 106:
        return ResponseAddEmailSuccess.fromJson(json);
      case 108:
        return RequestOTPEmailSuccess.fromJson(json);
      case 107:
        return VerificationResponseForAddNewPhoneNumber.fromJson(json);
      case 109:
        return CreateGroupResponse.fromJson(json);
      case 110:
      case 111:
        return AddProfileSuccess.fromJson(json);
      case 112:
        return DeleteProfileSuccess.fromJson(json);
      case 113:
        return EditGroupMembersResponse.fromJson(json);
      case 114:
        return DeleteGroupResponse.fromJson(json);
      case 115:
        return MakeGroupFavoriteResponse.fromJson(json);
      case 116:
        return MakeGroupFavoriteResponse.fromJson(json);
      case 200:
        return DidListsForDialInResponse.fromJson(json);
      case 132:

        /// Inform to InstantCallProvider.
        /// The Call is failed
        /// Display the reason as per room alert

        var response = RoomAlertResponse.fromJson(json);

        Provider.of<InstantCallProvider>(navigatorKey.currentContext!,
                listen: false)
            .callFailedWithAlertNumber(response.roomAlert);

        return response;
      case 126:
        var response = ReDialAllResponse.fromJson(json);

        Provider.of<InstantCallProvider>(navigatorKey.currentContext!,
                listen: false)
            .setCallStatus(InstantCallStatus.initiated);

        return response;
      case 133:
        var responseScheduleMembers = ResponseScheduleMembers.fromJson(json);

        Provider.of<CallsController>(navigatorKey.currentContext!,
                listen: false)
            .checkScheduleMembersResponse(responseScheduleMembers);
        return responseScheduleMembers;
      case 140:
        AccountController accountController = Provider.of<AccountController>(
          navigatorKey.currentContext!,
          listen: false,
        );
        var email = RestoreEmailsSuccess.fromJson(json);
        accountController.addEmails(email.emails);
        return email;
      case 145:
        var responseSchedulePickupMcccm =
            SchedulePickupResponseMcccm.fromJson(json);
        Provider.of<CallsController>(navigatorKey.currentContext!,
                listen: false)
            .checkSchedulePickupMcccmResponse(responseSchedulePickupMcccm);
        return responseSchedulePickupMcccm;
      case 142:
        var restoreScheduleStartResponse =
            RestoreScheduleStartResponse.fromJson(json);

        if (restoreScheduleStartResponse.totalScheduleCallCount == 0) {
          // Notify listeners or update state as needed
          Provider.of<CallsController>(navigatorKey.currentContext!,
                  listen: false)
              .resetScheduleListing();
        } else {
          // Add schedule detail to the map
          for (var schedule in restoreScheduleStartResponse.schedules) {
            scheduleDetailsMap[schedule.scheduleRefNo] = schedule;
            // Try to merge if members are already present
            _tryMergeSchedule(schedule.scheduleRefNo);
          }
        }

        return restoreScheduleStartResponse;
      case 150:
        var restoreScheduleMemberResponse =
            RestoreScheduleMemberResponse.fromJson(json);

        // Add members to the map
        for (var member in restoreScheduleMemberResponse.members) {
          if (!scheduleMembersMap
              .containsKey(restoreScheduleMemberResponse.scheduleRefNo)) {
            scheduleMembersMap[restoreScheduleMemberResponse.scheduleRefNo] =
                [];
          }
          // Add this check to avoid duplicates
          if (!scheduleMembersMap[restoreScheduleMemberResponse.scheduleRefNo]!
              .any((existingMember) => existingMember.phone == member.phone)) {
            scheduleMembersMap[restoreScheduleMemberResponse.scheduleRefNo]!
                .add(member);
          }

          // Try to merge if schedule detail is already present
          _tryMergeSchedule(restoreScheduleMemberResponse.scheduleRefNo);
        }

        return restoreScheduleMemberResponse;
      case 170:
        return RequestScheduleEstimateSuccess.fromJson(json);
      case 172:
      case 178:
        return UpdateDefaultProfileSuccess.fromJson(json);
      case 135:
        var response = ResponseRescheduleCall.fromJson(json);
        Provider.of<CallsController>(navigatorKey.currentContext!,
                listen: false)
            .rescheduleSuccess(response);

        return response;
      case 136:
        return ResponseScheduleDelete.fromJson(json);
      case 152:
        final response = ResponseMccmDeleteSchedule.fromJson(json);
        Provider.of<CallsController>(navigatorKey.currentContext!,
                listen: false)
            .deleteSuccess(response);

        return response;
      case 160:
        return RequestProfileStatusCheckSuccess.fromJson(json);
      case 171:
        return SyncProfileSuccess.fromJson(json);
      case 173:
        return RequestTopUpSuccess.fromJson(json);
      case 176:
        return EditProfileSuccess.fromJson(json);
      case 177:
        return SyncDeletedProfileSuccess.fromJson(json);
      case 179:
        return RequestForRegistrationStatusSuccess.fromJson(json);
      case 180:
        return RequestUserResetRegistrationSuccess.fromJson(json);
      case 182:
      case 183:
        return RequestCreateRetailProfileSuccess.fromJson(json);
      case 184:
        return RequestAccountDetailsSuccess.fromJson(json);
      case 185:
        return RequestProfilePlanDetailsSuccess.fromJson(json);
      case 186:
        return RequestProfileBasePlanDetailsSuccess.fromJson(json);
      case 187:
        return RequestProfileAddOnPlanDetailsSuccess.fromJson(json);
      case 188:
        return RequestProfilePaymentHistorySuccess.fromJson(json);
      case 189:
        return RequestProfileOverDueSuccess.fromJson(json);
      case 190:
        return RequestRetailPaymentOptionSuccess.fromJson(json);
      case 191:
        return RequestSwitchPlanSuccess.fromJson(json);
      case 192:
        return RequestCurrentPlanActiveStatusSuccess.fromJson(json);
      case 193:
        return RequestActiveStatusSuccess.fromJson(json);
      case 199:
        return RequestPrimaryEmailCheckSuccess.fromJson(json);
      case 144:
        final response = ResponseCallMeOnRestore.fromJson(json);
        Provider.of<CallMeOnController>(navigatorKey.currentContext!,
                listen: false)
            .setCallMeOnList(response.callMeOnList);
        return response;
      case 104:
        return ResponseCallMeOnUpdate.fromJson(json);
      case 149:
        return ResponseChangeConfereeList.fromJson(json);
      case 146:
        return ResponseStartScheduledCall.fromJson(json);
      case 164:
        var response = ResponseConferenceStatus.fromJson(json);
        final callsController = Provider.of<CallsController>(
            navigatorKey.currentContext!,
            listen: false);
        if (response.callStatus == 3) {
          if (callsController.isStartScheduleInProgress) {
            Provider.of<CallsController>(navigatorKey.currentContext!,
                    listen: false)
                .chairPersonJoinedCall(response);
          } else {
            Provider.of<InstantCallProvider>(navigatorKey.currentContext!,
                    listen: false)
                .chairPersonJoinedCall(response);
          }
        } else if (response.callStatus == 2) {
          if (callsController.isStartScheduleInProgress) {
            Provider.of<CallsController>(navigatorKey.currentContext!,
                    listen: false)
                .chairPersonDeniedCall(response);
          } else {
            Provider.of<InstantCallProvider>(navigatorKey.currentContext!,
                    listen: false)
                .chairPersonDeniedCall(response);
          }
        }

        return response;
      case 201:
        return AdvertiseRequirementDetailsResponse.fromJson(json);
      case 202:
        var response = ConfereeSpeakingStatusResponse.fromJson(json);
        Provider.of<SpeakingProvider>(navigatorKey.currentContext!,
                listen: false)
            .handleConfereeSpeakingStatusResponse(response);
        return response;
      case 143:
        var response = ResponseRestoreCallHistory.fromJson(json);
        CallsController callsController = Provider.of<CallsController>(
            navigatorKey.currentContext!,
            listen: false);
        callsController.updateIsLoading(false);

        /// Add call history to the list if there are participants
        if (response.participants.isNotEmpty) {
          callsController.addCallHistory(response);
        }
        return response;
      case 120:
        return ResponseMuteCall.fromJson(json);
      case 121:
        return ResponseUnMuteCall.fromJson(json);
      case 166:
        return ResponseCallRecord.fromJson(json);
      case 168:
        return ResponseCustomerCareNumber.fromJson(json);
      case 250:
        return ResponseRequestHealthSuccess.fromJson(json);
      case 203:
        return RequestAppRequestToSendEnterprisePlanToMcSupportSuccess.fromJson(
            json);
      case 52:
        final response = ResponseBulkUpdate.fromJson(json);
        final provider = Provider.of<InstantCallProvider>(
            navigatorKey.currentContext!,
            listen: false);

        if (provider.bulkUpdateData != null) {
          if (provider.bulkUpdateData?.conferences.isNotEmpty == true) {
            /// check if response conferences are not same as bulk update conferences
            /// and add new conferences to bulk update
            if (response.conferences
                .map((e) => e.phoneNumber)
                .toSet()
                .difference(provider.bulkUpdateData!.conferences
                    .map((e) => e.phoneNumber)
                    .toSet())
                .isNotEmpty) {
              provider.addConferences(response.conferences);
            } else {
              provider.setBulkUpdateData(response);
            }
          } else {
            provider.setBulkUpdateData(response);
          }
        } else {
          provider.setBulkUpdateData(response);
        }
        return response;
      default:
        return DefaultError(message: json['message'] ?? "Unknown error");
    }
  }

  void _tryMergeSchedule(int scheduleRefNo) {
    if (scheduleDetailsMap.containsKey(scheduleRefNo) &&
        scheduleMembersMap.containsKey(scheduleRefNo)) {
      // Check if the scheduleRefNo already exists in mergedResponses
      var existingResponseIndex = mergedResponses
          .indexWhere((response) => response.scheduleRefNo == scheduleRefNo);

      if (existingResponseIndex != -1) {
        // Update existing merged response
        mergedResponses[existingResponseIndex] = MergedScheduleCallResponse(
          scheduleRefNo: scheduleRefNo,
          scheduleDetail: scheduleDetailsMap[scheduleRefNo]!,
          members: scheduleMembersMap[scheduleRefNo]!,
        );
      } else {
        // Add new merged response
        var mergedResponse = MergedScheduleCallResponse(
          scheduleRefNo: scheduleRefNo,
          scheduleDetail: scheduleDetailsMap[scheduleRefNo]!,
          members: scheduleMembersMap[scheduleRefNo]!,
        );
        mergedResponses.add(mergedResponse);
      }

      // Notify listeners or update state as needed
      Provider.of<CallsController>(navigatorKey.currentContext!, listen: false)
          .setMergedScheduleCalls(mergedResponses);
    }
  }
}
