import 'dart:developer';
import 'package:contacts_service/contacts_service.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multicall_mobile/controller/app_controller.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/member_list_model.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/request_add_conferee_reschedule.dart';
import 'package:multicall_mobile/models/request_change_conferees_header.dart';
import 'package:multicall_mobile/models/request_remove_conferee_reschedule.dart';
import 'package:multicall_mobile/models/request_schedule_estimation.dart';
import 'package:multicall_mobile/models/request_schedule_estimation_members.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/models/response_change_conferee_list.dart';
import 'package:multicall_mobile/models/response_conference_status.dart';
import 'package:multicall_mobile/models/response_invitation_sync.dart';
import 'package:multicall_mobile/models/response_mccm_delete_schedule.dart';
import 'package:multicall_mobile/models/response_merged_schedule_calls_n_members.dart';
import 'package:multicall_mobile/models/response_reschedule_call.dart';
import 'package:multicall_mobile/models/response_restore_call_history.dart';
import 'package:multicall_mobile/models/response_restore_schedule_members.dart';
import 'package:multicall_mobile/models/response_restore_schedule_start.dart';
import 'package:multicall_mobile/models/response_schedule_members.dart';
import 'package:multicall_mobile/models/response_schedule_pickup_mccm.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/instant_call_screen_call_now.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:provider/provider.dart';

class CallsController extends BaseProvider {
  final WebSocketService webSocketService = WebSocketService();

  /// selected profile
  Profile? _selectedProfile;

  /// selected profile
  Profile? get selectedProfile => _selectedProfile;

  /// set selected profile
  set setSelectedProfile(Profile profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  /// selected call me on
  var _selectedCallMeOn = 0;

  /// get selected call me on
  int get getSelectedCallMeOn => _selectedCallMeOn;

  /// set selected call me on
  set setSelectedCallMeOn(int callMeOn) {
    _selectedCallMeOn = callMeOn;
    notifyListeners();
  }

  /// schedule call in progress
  bool _isStartScheduleInProgress = false;

  /// get schedule call is in progress
  bool get isStartScheduleInProgress => _isStartScheduleInProgress;

  /// set schedule call is in progress
  set isStartScheduleInProgress(bool isScheduleInProgress) {
    _isStartScheduleInProgress = isScheduleInProgress;
    notifyListeners();
  }

  /// schedule call status
  InstantCallStatus _scheduleCallStatus = InstantCallStatus.standby;

  /// get schedule call status
  InstantCallStatus get scheduleCallStatus => _scheduleCallStatus;

  /// set schedule call status
  set scheduleCallStatus(InstantCallStatus scheduleCallStatus) {
    _scheduleCallStatus = scheduleCallStatus;
    notifyListeners();
  }

  /// selected call history
  int _selectedCallHistoryIndex = 0;

  /// get selected call history
  int get selectedCallHistoryIndex => _selectedCallHistoryIndex;

  /// set selected call history
  set selectedCallHistoryIndex(int selectedCallHistoryIndex) {
    _selectedCallHistoryIndex = selectedCallHistoryIndex;
    notifyListeners();
  }

  /// invitations list
  var _invitations = <ResponseInvitationSync>[];

  /// get invitations
  List get invitations => _invitations;

  /// clear invitations
  void clearInvitations() {
    _invitations.clear();
    notifyListeners();
  }

  /// refresh upcoming calls
  void refreshUpcomingCallsData() {
    /// clear invitations
    clearInvitations();

    final homeProvider =
        Provider.of<HomeProvider>(navigatorKey.currentContext!, listen: false);

    homeProvider.setFromHomeScreen(false);

    // Calling invitationSync API
    Provider.of<AppController>(navigatorKey.currentContext!, listen: false)
        .invitationSync();

    /// Clear Restore the Upcoming Calls
    updateScheduleCallRestore();

    /// Navigate to Home Screen
    Navigator.pop(navigatorKey.currentContext!);
  }

  /// add invitation
  void addInvitation(ResponseInvitationSync invitation) {
    // check for the duplicate number using scheduleRefNumber
    if (_invitations
        .where((element) => element.scheduleRefNo == invitation.scheduleRefNo)
        .isNotEmpty) {
      debugPrint('Invitation sync response > invitation already exists');
      return;
    }
    _invitations.add(invitation);
    debugPrint('Invitation sync response > added');
    notifyListeners();

    final homeProvider =
        Provider.of<HomeProvider>(navigatorKey.currentContext!, listen: false);

    final isFromHomeScreen = homeProvider.isFromHomeScreen;

    debugPrint("invitation regNum: ${invitation.regNum}");
    debugPrint(
        "local stored registration number: ${PreferenceHelper.get(PrefUtils.userRegistrationNumber)}");

    if (!isFromHomeScreen &&
        invitation.regNum ==
            PreferenceHelper.get(PrefUtils.userRegistrationNumber)) {
      /// clear all invitations
      debugPrint('Invitation sync response > cleared.');
      clearInvitations();

      debugPrint(
          '>>> relaunchHomeScreen >>> from HomeScreen $isFromHomeScreen');
      homeProvider.setFromHomeScreen(true);

      /// relaunch home screen
      relaunchHomeScreen();
    } else {
      debugPrint(
          '--- relaunchHomeScreen >>> from HomeScreen $isFromHomeScreen');
      homeProvider.setFromHomeScreen(false);
    }
  }

  void relaunchHomeScreen() {
    resetKeys();

    Future.delayed(const Duration(milliseconds: 100), () {
      navigatorKey.currentState?.pushReplacementNamed(HomeScreen.routeName);
    });
  }

  /// set invitations
  void addInvitations(List<ResponseInvitationSync> invitations) {
    _invitations = invitations;
    notifyListeners();
  }

  var _selectedUpcomingCallPosition = -1;

  int get selectedUpcomingCallPosition => _selectedUpcomingCallPosition;

  void setSelectedUpcomingCallPosition(int value) {
    _selectedUpcomingCallPosition = value;
    notifyListeners();
  }

  void setSelectedUpcomingCallScheduleRefNo(int value) {
    _selectedUpcomingCallPosition = value;
    notifyListeners();
  }

  String _scheduleCallName = 'New Call';

  final _members = <ScheduleCallMember>[];

  var _typeOfStart = 1; // 1 or 2

  var _addToCalendar = 0; // 0 or 1

  var _conferenceDuration = 30;

  var _scheduleStartDateTime = '';

  var _repeatType =
      0; // 0 - Never, 1 - EveryDay, 2 - Every Week, 4 - Every Month

  var _callType = 2; // dial-out = 2 and dial-in = 3

  var _dialInFlag = 0; // dial-out = 0 dial-in =1

  int get dialInFlag => _dialInFlag;

  void setDialInFlag(int value) {
    _dialInFlag = value;
    notifyListeners();
  }

  /// Write to the Calender
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  List<Calendar>? _calendars;
  List<Calendar>? _writableCalendars;

  List<Calendar>? get writableCalendars => _writableCalendars;

  Future<void> retrieveWritableCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
          return;
        }
      }
      var calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      if (calendarsResult.isSuccess && calendarsResult.data != null) {
        _calendars = calendarsResult.data;
        _writableCalendars = _calendars
            ?.where((calendar) => calendar.isReadOnly == false)
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> createEvent() async {
    if (_writableCalendars == null || _writableCalendars!.isEmpty) {
      debugPrint("No writable calendars available.");
      return;
    }

    DateTime finalDate;
    String startDateString = getScheduleStartDateTime();

    // Check if the input is date or time is empty
    if (startDateString.isEmpty) {
      log("Input is empty, returning current date and time.");
      finalDate = selectedDate; // Store the current date and time in finalDate
    } else {
      try {
        // Attempt to parse the string to DateTime
        finalDate = DateTime.parse("$startDateString:00");
      } catch (e) {
        // Handle the case where the string is not a valid date
        log("Invalid date format, returning current date and time.");
        finalDate =
            selectedDate; // Store the current date and time in finalDate
      }
    }

    final calendar = _writableCalendars!.first;
    final event = Event(
      calendar.id,
      title: '$callName - Multicall',
      start: TZDateTime.from(finalDate, local),
      end: TZDateTime.from(
          finalDate.add(Duration(minutes: getConferenceDuration())), local),
    );

    try {
      await _deviceCalendarPlugin.createOrUpdateEvent(event);
      showToast("Event added to calendar.");
    } catch (e) {
      debugPrint("Failed to create event: $e");
    }
  }

  /// set call type
  void setCallType(int type) {
    _callType = type;
    notifyListeners();
  }

  /// get call type
  int getCallType() => _callType;

  /// set repeat type
  void setRepeatType(int type) {
    _repeatType = type;
    notifyListeners();
  }

  /// get repeat type
  int getRepeatType() => _repeatType;

  /// set schedule start date time
  void setScheduleStartDateTime(String dateTime) {
    _scheduleStartDateTime = dateTime;
    notifyListeners();
  }

  /// get schedule start date time
  String getScheduleStartDateTime() => _scheduleStartDateTime;

  /// set conference duration
  void setConferenceDuration(int duration) {
    _conferenceDuration = duration;
    notifyListeners();
  }

  /// get conference duration
  int getConferenceDuration() => _conferenceDuration;

  /// add member
  void addMember(ScheduleCallMember member) {
    _members.add(member);
    notifyListeners();
  }

  /// add members
  void addMembers(List<ScheduleCallMember> members) {
    _members.addAll(members);
    notifyListeners();
  }

  List<ResponseRestoreCallHistory> _allCallsHistory = [];

  /// get all calls history
  List<ResponseRestoreCallHistory> get allCallsHistory => _allCallsHistory;

  /// clear all calls history
  void clearAllCallsHistory() {
    _allCallsHistory.clear();
    notifyListeners();
  }

  /// set all calls history
  bool _isAllCallLoading = true;

  bool get isAllCallLoading => _isAllCallLoading;

  void setAllCallsHistory(List<ResponseRestoreCallHistory> allCallsHistory) {
    _allCallsHistory = allCallsHistory;
    notifyListeners();
  }

  void updateIsLoading(bool value) {
    _isAllCallLoading = value;
  }

  /// add call history
  void addCallHistory(ResponseRestoreCallHistory callHistory) {
    if (_allCallsHistory.isNotEmpty) {
      if (_allCallsHistory
          .any((element) => element.uniqueKey == callHistory.uniqueKey)) {
        debugPrint(
            'addCallHistory >>>>>>>>>>>>> exist ${_allCallsHistory.length} - ${callHistory.uniqueKey}');
        return;
      }
    }

    debugPrint(
        'addCallHistory >>>>>>>>>>>>> not exist ${_allCallsHistory.length} - ${callHistory.uniqueKey}');
    _allCallsHistory.add(callHistory);
    notifyListeners();
  }

  List<MergedScheduleCallResponse> _mergedScheduleCalls = [];

  /// get merged schedule calls
  List<MergedScheduleCallResponse> get mergedScheduleCalls =>
      _mergedScheduleCalls;

  /// set merged schedule calls
  void setMergedScheduleCalls(
      List<MergedScheduleCallResponse> mergedScheduleCalls) {
    _mergedScheduleCalls = mergedScheduleCalls;
    notifyListeners();
  }

  bool addMembersToScheduleCallWithDuplicateCheck(
      List<ScheduleCallMember> newMembers) {
    /// Get selected call-me-on number
    final selectedCallMeOnNumber = Provider.of<CallMeOnController>(
            navigatorKey.currentContext!,
            listen: false)
        .filteredCallMeOnList[_selectedCallMeOn]
        .callMeOn;

    /// Check if selected call-me-on number is already added
    if (newMembers
        .any((element) => element.memberTelephone == selectedCallMeOnNumber)) {
      showToast(
          "Call-me-on number added as a participant! Please add a different number to continue.");
      return false;
    }

    var existingMembers = getMembers().map((e) => e.memberTelephone).toList();
    final newMemberCount = newMembers.length;

    if (newMemberCount == 1 &&
        existingMembers.contains(newMembers.first.memberTelephone)) {
      showToast("Number Already Added!, Please select different number.");
      return false;
    }

    for (var member in existingMembers) {
      newMembers.removeWhere((element) => element.memberTelephone == member);
    }
    if (newMemberCount != newMembers.length) {
      showToast("Duplicate number found!");
    }
    addMembers(newMembers);
    return true;
  }

  /// Adds new members to a rescheduled call with a duplicate check.
  ///
  /// This function performs the following steps:
  /// 1. Retrieves the list of existing member phone numbers.
  /// 2. Checks if the new member's phone number is already in the existing members list if there is only one new member.
  /// 3. Removes duplicate phone numbers from the new members list.
  /// 4. Calls `addMembersToRescheduleCallAPIs` to add the new members to the rescheduled call.
  ///
  /// Args:
  ///   newMembers (List<ScheduleCallMembers>): The list of new members to be added.
  ///   scheduleDetail (ScheduleDetail): The details of the schedule.
  ///
  /// Returns:
  ///   Future<bool>: A Future that completes with `true` if the members were added successfully,
  ///                 or `false` if a duplicate number was found in the single new member case.
  Future<bool> addMembersToRescheduleCallWithDuplicateCheck(
    List<ScheduleCallMembers> newMembers,
    ScheduleDetail scheduleDetail,
  ) async {
    var existingMembers = mergedScheduleCalls[selectedUpcomingCallPosition]
        .members
        .map((e) => e.phone)
        .toList();
    final newMemberCount = newMembers.length;

    if (newMemberCount == 1 &&
        existingMembers.contains(newMembers.first.phone)) {
      showToast("Number Already Added!, Please select different number.");
      return false;
    }

    for (var member in existingMembers) {
      newMembers.removeWhere((element) => element.phone == member);
    }
    if (newMemberCount != newMembers.length) {
      showToast("Duplicate number found!");
    }

    await addMembersToRescheduleCallAPIs(scheduleDetail, newMembers);
    return true;
  }

  /// Adds members to a rescheduled call and updates the conference header.
  ///
  /// This function performs the following steps:
  /// 1. Calls `changeConfereesHeader` once at the start with the total number of members.
  /// 2. Loops through each member in the list and calls `addConfereeReschedule`.
  /// 3. After each `addConfereeReschedule` call, it updates the conference header again using `changeConfereesHeader`.
  /// 4. If the `addConfereeReschedule` call is successful, it adds the member to the schedule call.
  ///
  /// Args:
  ///   scheduleDetail (ScheduleDetail): The details of the schedule.
  ///   members (List<ScheduleCallMembers>): The list of members to be added to the rescheduled call.
  ///
  /// Returns:
  ///   Future<void>: A Future that completes when all operations are done.
  Future<void> addMembersToRescheduleCallAPIs(
    ScheduleDetail scheduleDetail,
    List<ScheduleCallMembers> members,
  ) async {
    int totalMembers = members.length;

    // Call changeConfereesHeader at the start
    changeConfereesHeader(
      profileRefNumber: scheduleDetail.profileRefNum,
      scheduleRefNumber: scheduleDetail.scheduleRefNo,
      totalNumberOfMessages: totalMembers,
      totalConfereeCount: totalMembers,
    );

    // Loop through each member and call addConfereeReschedule
    for (ScheduleCallMembers member in members) {
      var result = await addConfereeReschedule(
        profileRefNumber: scheduleDetail.profileRefNum,
        scheduleRefNumber: scheduleDetail.scheduleRefNo,
        confereeEmail: member.email,
        confereeName: member.name,
        confereeNumber: member.phone,
      ) as ResponseChangeConfereeList;

      // Call changeConfereesHeader at the end of each addConfereeReschedule call
      changeConfereesHeader(
        profileRefNumber: scheduleDetail.profileRefNum,
        scheduleRefNumber: scheduleDetail.scheduleRefNo,
        totalNumberOfMessages: totalMembers,
        totalConfereeCount: totalMembers,
      );

      if (result.status) {
        addMemberToScheduleCall(member, scheduleDetail.scheduleRefNo);
      }
    }
  }

  /// Checks for duplicate phone numbers in the new numbers list against the existing members.
  ///
  /// @param newNumbers The list of new phone numbers to be added.
  /// @param context The BuildContext used to show toast and navigate.
  /// @return True if duplicates are found, false otherwise.
  bool _checkForDuplicateNumbers(
      List<String> newNumbers, BuildContext context) {
    final Set<String> phoneNumbersSet =
        _members.map((member) => member.memberTelephone).toSet();
    final List<String> duplicateNumbers = [];

    for (var number in newNumbers) {
      if (phoneNumbersSet.contains(number)) {
        duplicateNumbers.add(number);
      } else {
        phoneNumbersSet.add(number);
      }
    }

    if (duplicateNumbers.isNotEmpty) {
      // showToast("Duplicate numbers found: ${duplicateNumbers.join(', ')}");
      showToast("Duplicate number found!");
      return true;
    }
    return false;
  }

  /// Adds members from a list of contacts after checking for duplicates.
  ///
  /// @param selectedContacts The list of contacts to be added.
  /// @param context The BuildContext used to show toast and navigate.
  void addMembersWithCheckForContact(
      List<Contact> selectedContacts, BuildContext context) {
    final newNumbers = selectedContacts
        .map((contact) => (contact.phones?.first.value ?? "")
            .replaceAll(RegExp(r'[ \-()]'), ''))
        .toList();

    if (_checkForDuplicateNumbers(newNumbers, context)) {
      Navigator.pop(context);
      return;
    }

    for (var contact in selectedContacts) {
      addMember(ScheduleCallMember(
        memberName: (contact.displayName ?? "").length > 15
            ? (contact.displayName ?? "").substring(0, 15)
            : (contact.displayName ?? ""),
        memberTelephone: (contact.phones?.first.value ?? "")
            .replaceAll(RegExp(r'[ \-()]'), ''),
        memberEmail: ((contact.emails ?? []).isNotEmpty)
            ? contact.emails?.first.value ?? ""
            : "",
      ));
    }

    Navigator.pop(context);
  }

  /// Adds members from a list of group members after checking for duplicates.
  ///
  /// @param phoneNumbers The list of group members to be added.
  /// @param context The BuildContext used to show toast and navigate.
  void addMembersWithCheckForAddNumber(
      List<GroupMembers> phoneNumbers, BuildContext context) {
    final newNumbers = phoneNumbers
        .map((member) =>
            member.memberTelephone.replaceAll(RegExp(r'[ \-()]'), ''))
        .toList();

    if (_checkForDuplicateNumbers(newNumbers, context)) return;

    for (var member in phoneNumbers) {
      addMember(ScheduleCallMember(
        memberName: (member.memberName ?? "Unknown").length > 15
            ? (member.memberName ?? "Unknown").substring(0, 15)
            : (member.memberName ?? "Unknown"),
        memberTelephone:
            member.memberTelephone.replaceAll(RegExp(r'[ \-()]'), ''),
        memberEmail: member.memberEmail ?? "",
      ));
    }
  }

  /// remove member
  void removeMember(ScheduleCallMember member) {
    _members.remove(member);
    notifyListeners();
  }

  /// clear members
  void clearMembers() {
    if (_members.isNotEmpty) {
      _members.clear();
      notifyListeners();
    }
  }

  /// set type of start
  void setTypeOfStart(int type) {
    _typeOfStart = type;
    notifyListeners();
  }

  void setCalendarEvent(int type) {
    _addToCalendar = type;
    notifyListeners();
  }

  /// get type of start
  int getTypeOfStart() => _typeOfStart;

  int getCalendarStatus() => _addToCalendar;

  /// get members
  List<ScheduleCallMember> getMembers() => _members;

  /// set schedule call name
  String get callName => _scheduleCallName;

  void setCallName(String newName) {
    if (_scheduleCallName != newName) {
      _scheduleCallName = newName;
      notifyListeners();
    }
  }

  /// Date and Time Picker Controller
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _repeatTillDate = DateTime.now();

  void initializeDateTime() {
    _selectedDate = DateTime.now();

    /// adding 15 minutes gap to time
    final dateTime = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedDate.hour, _selectedDate.minute);
    final newDateTime = dateTime.add(const Duration(minutes: 15));
    _selectedTime =
        TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);

    _repeatTillDate = _selectedDate.add(const Duration(days: 1));
    _updateScheduleStartDateTime();
  }

  DateTime get selectedDate => _selectedDate;

  TimeOfDay get selectedTime => _selectedTime;

  DateTime get repeatTillDate => _repeatTillDate;

  void setRepeatTillDate(DateTime date) {
    _repeatTillDate = date;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _selectedDate = date;
    if (getRepeatType() == 0) {
      _repeatTillDate = date;
    } else {
      _repeatTillDate = date.add(const Duration(days: 1));
    }

    _updateScheduleStartDateTime();
    notifyListeners();
  }

  void updateTime(TimeOfDay time) {
    _selectedTime = time;
    _updateScheduleStartDateTime();
    notifyListeners();
  }

  void _updateScheduleStartDateTime() {
    final combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    _scheduleStartDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
  }

  CallsController() {
    initAPIs();
  }

  void initAPIs() {
    // Call all inital apis here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// call history restore
      callHistoryRestore();

      /// schedule call restore
      scheduleCallRestore(DateFormat('yyyy-MM-dd').format(DateTime.now()), 0);
    });
  }

  updateScheduleCallRestore() {
    /// clear merged schedule calls from controller
    setMergedScheduleCalls([]);

    /// clear merged schedule calls from service
    webSocketService.clearMergedScheduleCallsData();

    /// delay 300ms and call schedule call restore
    Future.delayed(const Duration(milliseconds: 300), () {
      /// call schedule call restore api for fresh data
      scheduleCallRestore(DateFormat('yyyy-MM-dd').format(DateTime.now()), 0);
    });
  }

  // CallMeOn Restore
  // Call HistoryRestore
  // ScheduleCall Restore

  Future<RecievedMessage> callHistoryRestore() async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestCallHistoryRestore(
        regNum: regNum,
        email: email,
        telephone: telephone,
      ),
    );
    return response;
  }

  Future<RecievedMessage> scheduleCallRestore(
    String dateFrom,
    int scheduleRefNumber,
  ) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestScheduleCallRestore(
          regNum: regNum,
          email: email,
          telephone: telephone,
          dateFrom: dateFrom,
          scheduleRefNumber: scheduleRefNumber),
    );
    return response;
  }

  /// ScheduleCall api call
  Future<RecievedMessage> scheduleCall({
    required int profileRefNumber,
    required int totalIterations,
    required String chairPersonPhoneNumber,
    required int callType,
    required int startType,
    required int scheduleRefNumber,
    required String scheduleName,
    required int totalMembersCount,
    required int conferenceDuration,
    required String scheduleStartDateTime,
    required int repeatType,
    required String repeatEndDate,
    required int dialinFlag,
    required String dialinDid,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestScheduleCall(
        registrationNumber: regNum,
        telephone: telephone,
        emailid: email,
        profileRefNumber: profileRefNumber,
        totalIterations: totalIterations,
        chairPersonPhoneNumber: chairPersonPhoneNumber,
        callType: callType,
        startType: startType,
        scheduleRefNumber: scheduleRefNumber,
        scheduleName: scheduleName,
        totalMembersCount: totalMembersCount,
        conferenceDuration: conferenceDuration,
        scheduleStartDateTime: scheduleStartDateTime,
        repeatType: repeatType,
        repeatEndDate: repeatEndDate,
        dialinFlag: dialinFlag,
        dialinDid: dialinDid,
      ),
    );
    return response;
  }

  /// EndCallParticipant api call
  Future<RecievedMessage> endCallParticipant({
    required int scheduleRefNumber,
    required String participantPhoneNumber,
    required int profileRefNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestEndCallParticipant(
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

  /// EndCallAll api call
  Future<RecievedMessage> endCallAll({
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

  /// ScheduleMembers api call
  Future<RecievedMessage> scheduleMembers({
    required String chairPersonPhoneNumber,
    required int messageNumber,
    required List<ScheduleCallMember> members,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestScheduleMembers(
        registrationNumber: regNum,
        chairPersonPhoneNumber: chairPersonPhoneNumber,
        messageNumber: messageNumber,
        totalNumberOfMembers: members.length,
        members: members,
      ),
    );
    return response;
  }

  /// RescheduleCall api call
  Future<RecievedMessage> rescheduleCall({
    required int profileRefNumber,
    required int scheduleRefNumber,
    required String scheduleStartDateTime,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestRescheduleCall(
        registrationNumber: regNum,
        telephone: telephone,
        emailid: email,
        profileRefNumber: profileRefNumber,
        scheduleRefNumber: scheduleRefNumber,
        scheduleStartDateTime: scheduleStartDateTime,
      ),
    );
    return response;
  }

  /// DeleteSchedule api call
  Future<RecievedMessage> deleteSchedule({
    required int profileRefNumber,
    required int scheduleRefNumber,
    required int recurrentId,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestDeleteSchedule(
        registrationNumber: regNum,
        telephone: telephone,
        emailid: email,
        profileRefNumber: profileRefNumber,
        scheduleRefNumber: scheduleRefNumber,
        recurrentId: recurrentId,
      ),
    );
    return response;
  }

  /// InstantPickup api call
  Future<RecievedMessage> instantPickup({
    required int totalNumberOfMessages,
    required String chairPersonPhoneNumber,
    required int profileRefNumber,
    required int callType,
    required int conferenceStartTime,
    required int conferenceDuration,
    required int otherFeatures,
    required int typeOfStart,
    required int scheduleRefNumber,
    required int totalMembers,
    required String confereeEmail,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestInstantPickup(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        totalNumberOfMessages: totalNumberOfMessages,
        chairPersonPhoneNumber: chairPersonPhoneNumber,
        profileRefNumber: profileRefNumber,
        callType: callType,
        conferenceStartTime: conferenceStartTime,
        conferenceDuration: conferenceDuration,
        otherFeatures: otherFeatures,
        typeOfStart: typeOfStart,
        scheduleRefNumber: scheduleRefNumber,
        totalMembers: totalMembers,
        confereeEmail: confereeEmail,
      ),
    );
    return response;
  }

  // /// InstantPickupMembers api call
  // Future<RecievedMessage> instantPickupMembers({
  //   required String chairPersonPhoneNumber,
  //   required int messageNumber,
  //   required String memberName,
  //   required String memberTelephone,
  // }) async {
  //   RecievedMessage response = await webSocketService.asyncSendMessage(
  //     RequestInstantPickupMembers(
  //       registrationNumber: regNum,
  //       chairPersonPhoneNumber: chairPersonPhoneNumber,
  //       messageNumber: messageNumber,
  //       totalNumberOfMembers: 1,
  //       memberName: memberName,
  //       memberTelephone: memberTelephone,
  //     ),
  //   );
  //   return response;
  // }

  /// ScheduleInviteAcknowledgement api call
  Future<RecievedMessage> scheduleInviteAcknowledgement({
    required int scheduleRefNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestScheduleInviteAcknowledgement(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        scheduleRefNumber: scheduleRefNumber,
      ),
    );
    return response;
  }

  /// ScheduleCancelAcknowledgement api call
  Future<RecievedMessage> scheduleCancelAcknowledgement({
    required int scheduleRefNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestScheduleCancelAcknowledgement(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        scheduleRefNumber: scheduleRefNumber,
      ),
    );
    return response;
  }

  /// ScheduleEstimation api call
  Future<RequestScheduleEstimateSuccess> scheduleEstimation({
    required int profileRefNumber,
    required int confDuration,
    required int totalNumberOfMessages,
    required String chairPersonPhoneNumber,
    required int dialType,
    required int otherFeatures,
    required int typeOfStart,
    required int totalMembers,
  }) async {
    RequestScheduleEstimateSuccess response =
        await webSocketService.asyncSendMessage(
      RequestScheduleEstimation(
        registrationNumber: regNum,
        profileRefNumber: profileRefNumber,
        confDuration: confDuration,
        totalNumberOfMessages: totalNumberOfMessages,
        chairPersonPhoneNumber: chairPersonPhoneNumber,
        dialType: dialType,
        otherFeatures: otherFeatures,
        typeOfStart: typeOfStart,
        totalMembers: totalMembers,
      ),
    ) as RequestScheduleEstimateSuccess;
    return response;
  }

  /// ScheduleEstimationMembers api call
  Future<RecievedMessage> scheduleEstimationMembers({
    required int profileRefNumber,
    required List<MemberEstimation> members,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestScheduleEstimationMembers(
        registrationNumber: regNum,
        profileRefNumber: profileRefNumber,
        numberOfMembers: members.length,
        members: members,
      ),
    );
    return response;
  }

  /// Start Schedule call api
  Future<RecievedMessage> startScheduleCall({
    required int profileRefNumber,
    required int scheduleRefNumber,
  }) async {
    _isStartScheduleInProgress = true;

    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestStartScheduleCall(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        profileRefNumber: profileRefNumber,
        scheduleRefNumber: scheduleRefNumber,
      ),
    );
    return response;
  }

  /// Response To Invitation api
  /// action values:
  /// 0-Reject, 1-Accept, 2-RejectAll, 3-AcceptAll
  Future<RecievedMessage> responseToInvitation({
    required int scheduleRefNumber,
    required int action,
    required int recurrentId,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestResponseToInvitationCall(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        scheduleRefNumber: scheduleRefNumber,
        actionType: action,
        recurrentId: recurrentId,
      ),
    );
    return response;
  }

  /// Change Conferees Header api call
  Future<RecievedMessage> changeConfereesHeader({
    required int profileRefNumber,
    required int scheduleRefNumber,
    required int totalNumberOfMessages,
    required int totalConfereeCount,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestChangeConfereesHeader(
        regNum: regNum,
        telephone: telephone,
        email: email,
        profileRefNumber: profileRefNumber,
        scheduleRefNumber: scheduleRefNumber,
        totalMessages: totalNumberOfMessages,
        totalConfereeCount: totalConfereeCount,
      ),
    );
    return response;
  }

  /// Change Conferees Members api call
  Future<RecievedMessage> changeConfereesMembers({
    required String chairPersonPhoneNumber,
    required int messageNumber,
    required int totalNumberOfMembers,
    required List<Member> members,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestChangeConfereesMembers(
        registrationNumber: regNum,
        chairPersonPhoneNumber: chairPersonPhoneNumber,
        messageNumber: messageNumber,
        totalNumberOfMembers: totalNumberOfMembers,
        members: members,
      ),
    );
    return response;
  }

  /// Add Conferee ReSchedule api call
  Future<RecievedMessage> addConfereeReschedule({
    required int profileRefNumber,
    required int scheduleRefNumber,
    required String confereeEmail,
    required String confereeName,
    required String confereeNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestAddConfereeReschedule(
        regNum: regNum,
        telephone: telephone,
        email: email,
        profileRefNumber: profileRefNumber,
        scheduleRefNumber: scheduleRefNumber,
        confereeEmail: confereeEmail,
        confereeName: confereeName,
        confereeNumber: confereeNumber,
      ),
    );
    return response;
  }

  /// Remove Conferee ReSchedule api call
  Future<RecievedMessage> removeConfereeReschedule({
    required int profileRefNumber,
    required int scheduleRefNumber,
    required String confereeEmail,
    required String confereeName,
    required String confereeNumber,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestRemoveConfereeReschedule(
        regNum: regNum,
        telephone: telephone,
        email: email,
        profileRefNumber: profileRefNumber,
        scheduleRefNumber: scheduleRefNumber,
        confereeEmail: confereeEmail,
        confereeName: confereeName,
        confereeNumber: confereeNumber,
      ),
    );
    return response;
  }

  /// Reconnect api call
  Future<RecievedMessage> reconnect() async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestReconnect(
        regNum: regNum,
        email: email,
        telephone: telephone,
      ),
    );

    return response;
  }

  void invitationSync() {}

  /// Request Did Lists For Dial In api call
  Future<RecievedMessage> requestDidListsForDialIn({
    required int appSocketId,
    required int profileRefNum,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestDidListsForDialIn(
        registrationNumber: regNum,
        appSocketId: appSocketId,
        profileRefNum: profileRefNum,
      ),
    );
    return response;
  }

  /// Check Schedule Members Response
  void checkScheduleMembersResponse(ResponseScheduleMembers response) {
    // showToast("Successfully scheduled call.");
  }

  /// Check Schedule Pickup Response for successful scheduling
  void checkSchedulePickupMcccmResponse(
      SchedulePickupResponseMcccm responseSchedulePickupMcccm) {
    if (responseSchedulePickupMcccm.scheduleRefNo == 0) {
      showToast("Having issue in scheduling call. Please try again.");
    } else {
      /// Update Schedule Call Restore
      updateScheduleCallRestore();

      /// Create Event in Calendar
      if (_addToCalendar == 1) {
        createEvent();
      }

      /// Reset
      resetScheduleCallVariables();

      showToast("Successfully scheduled call.");

      /// Schedule Invite Acknowledgement api
      scheduleInviteAcknowledgement(
        scheduleRefNumber: responseSchedulePickupMcccm.scheduleRefNo,
      );

      final currentContext = navigatorKey.currentContext;
      if (currentContext != null && Navigator.canPop(currentContext)) {
        Navigator.maybePop(currentContext);
      }
    }
  }

  void resetScheduleCallVariables() {
    _selectedDate = DateTime.now();

    /// adding 15 minutes gap to time
    final dateTime = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedDate.hour, _selectedDate.minute);
    final newDateTime = dateTime.add(const Duration(minutes: 15));
    _selectedTime =
        TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);

    _members.clear();
    _repeatTillDate = _selectedDate.add(const Duration(days: 1));
    _scheduleStartDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate);
    _conferenceDuration = 30;
    _scheduleCallName = "New Call";
    notifyListeners();
  }

  void resetScheduleListing() {
    _mergedScheduleCalls.clear();
    if (_members.isNotEmpty) {
      _members.clear();
    }
    notifyListeners();
  }

  void deleteSuccess(ResponseMccmDeleteSchedule responseMccmDeleteSchedule) {
    showToast("Call has been CANCELLED.");
    final currentContext = navigatorKey.currentContext;
    if (currentContext != null && Navigator.canPop(currentContext)) {
      Navigator.maybePop(currentContext);
    }

    /// Update Schedule Call Restore
    updateScheduleCallRestore();
  }

  void rescheduleSuccess(ResponseRescheduleCall responseRescheduleCall) {
    final currentContext = navigatorKey.currentContext;
    if (currentContext != null && Navigator.canPop(currentContext)) {
      Navigator.maybePop(currentContext);
    }
    if (responseRescheduleCall.scheduleRefNo == 0) {
      showToast("Reschedule failure.");
    } else {
      showToast("Reschedule call successfully.");

      /// Update Schedule Call Restore
      updateScheduleCallRestore();
    }
  }

  /// Removes a member from the schedule call identified by the given schedule reference number.
  ///
  /// This method searches for the schedule call with the specified reference number and removes
  /// the provided member from its list of members. If the schedule call is found and the member
  /// is successfully removed, the listeners are notified of the change.
  ///
  /// @param member The member to be removed from the schedule call.
  /// @param scheduleRefNo The reference number of the schedule call from which the member should be removed.
  void removeMemberFromScheduleCall(
      ScheduleCallMembers member, int scheduleRefNo) {
    final index = _mergedScheduleCalls.indexWhere(
        (element) => element.scheduleDetail.scheduleRefNo == scheduleRefNo);
    if (index != -1) {
      _mergedScheduleCalls[index].members.remove(member);
      notifyListeners();
    }
  }

  /// Adds a member to the schedule call identified by the given schedule reference number.
  ///
  /// This method searches for the schedule call with the specified reference number and adds
  /// the provided member to its list of members. If the schedule call is found and the member
  /// is successfully added, the listeners are notified of the change.
  ///
  /// @param member The member to be added to the schedule call.
  /// @param scheduleRefNo The reference number of the schedule call to which the member should be added.
  void addMemberToScheduleCall(ScheduleCallMembers member, int scheduleRefNo) {
    final index = _mergedScheduleCalls.indexWhere(
        (element) => element.scheduleDetail.scheduleRefNo == scheduleRefNo);
    if (index != -1) {
      _mergedScheduleCalls[index].members.add(member);
      notifyListeners();
    }
  }

  /// Call this methode when user logout
  /// To clear all data
  void clearCallControllerAllData() {
    resetScheduleListing();
    resetScheduleCallVariables();
    clearAllCallsHistory();

    /// clear invitations
    clearInvitations();
  }

  void chairPersonJoinedCall(ResponseConferenceStatus response) {
    if (!_isStartScheduleInProgress) {
      return;
    }

    final members = mergedScheduleCalls
        .firstWhere((element) =>
            element.scheduleDetail.scheduleRefNo == response.scheduleRefNo)
        .members;

    /// map the members with MemberListModel
    List<MemberListModel> memberList = [];
    for (var member in members) {
      memberList.add(MemberListModel(
        name: member.name,
        phoneNumber: member.phone,
      ));
    }

    var callsController = Provider.of<CallsController>(
        navigatorKey.currentContext!,
        listen: false);
    var selectedCallPosition = callsController.selectedUpcomingCallPosition;

    var scheduleDetail = callsController
        .mergedScheduleCalls[selectedCallPosition].scheduleDetail;

    final selectedProfile = Provider.of<ProfileController>(
            navigatorKey.currentContext!,
            listen: false)
        .profiles
        .firstWhere(
          (element) => element.profileRefNo == scheduleDetail.profileRefNum,
          orElse: () => Provider.of<ProfileController>(
                  navigatorKey.currentContext!,
                  listen: false)
              .profiles[0],
        );

    /// add members to instant call provider
    final instantCallProvider = Provider.of<InstantCallProvider>(
        navigatorKey.currentContext!,
        listen: false);
    instantCallProvider.memberList.clear();
    instantCallProvider.addMembers(memberList);
    instantCallProvider.setConferenceReferenceNumber(response.conferenceRefNo);
    instantCallProvider.setScheduleReferenceNumber(response.scheduleRefNo);
    instantCallProvider.setProfile(selectedProfile);
    instantCallProvider.setCallMeOnNumber(selectedProfile.profilePhone);

    _scheduleCallStatus = InstantCallStatus.chairPersonJoined;

    showToast("Call Success!");

    if (!navigatorKey.currentContext!.mounted) return;

    /// Remove current screen from stack
    Navigator.pop(navigatorKey.currentContext!);

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
    _scheduleCallStatus = InstantCallStatus.deniedByChairPerson;
    showToast("Call Denied!");
    notifyListeners();
  }
}
