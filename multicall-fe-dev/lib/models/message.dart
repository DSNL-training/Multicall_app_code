import 'dart:ffi';

abstract class RequestMessage {
  final int action;
  List<int> expectedReactionTypes;

  RequestMessage({required this.action, required this.expectedReactionTypes});

  Map<String, dynamic> toJson();
}

class RequestRegistration extends RequestMessage {
  String email;
  String name;
  String phoneNumber;
  int? socialNetworkFlag;

  RequestRegistration({
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.socialNetworkFlag,
  }) : super(action: 5, expectedReactionTypes: [101, 102, 163]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['telephone'] = phoneNumber;
    data['emailid'] = email;
    data['name'] = name;
    data['socialNetworkFlag'] = socialNetworkFlag ?? 1;
    return data;
  }
}

class RequestSMSOTPVerificationMessage extends RequestMessage {
  int regNum;
  String email;
  String telephone;
  String otp;

  RequestSMSOTPVerificationMessage({
    required this.email,
    required this.regNum,
    required this.telephone,
    required this.otp,
  }) : super(action: 6, expectedReactionTypes: [101, 102]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['otp'] = otp;
    return data;
  }
}

class RequestEmailOTPVerificationMessage extends RequestMessage {
  int regNum;
  String email;
  String telephone;
  String otp;

  RequestEmailOTPVerificationMessage({
    required this.email,
    required this.regNum,
    required this.telephone,
    required this.otp,
  }) : super(action: 7, expectedReactionTypes: [101, 102]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['otp'] = otp;
    return data;
  }
}

class RequestResendEmailOTP extends RequestMessage {
  int regNum;
  String email;
  String registeredEmailID;
  String telephone;

  RequestResendEmailOTP({
    required this.email,
    required this.regNum,
    required this.telephone,
    required this.registeredEmailID,
  }) : super(action: 37, expectedReactionTypes: [128]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['registeredEmailid'] = registeredEmailID;
    return data;
  }
}

class RequestResendSMSOTP extends RequestMessage {
  int regNum;
  String email;
  String phoneNumber;
  String telephone;

  RequestResendSMSOTP({
    required this.email,
    required this.regNum,
    required this.telephone,
    required this.phoneNumber,
  }) : super(action: 36, expectedReactionTypes: [127]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}

// To Create New Group
class RequestCreateNewGroup extends RequestMessage {
  int regNum;
  int profileRefNumber;
  String email;
  String telephone;
  String groupName;

  RequestCreateNewGroup({
    required this.email,
    required this.regNum,
    required this.telephone,
    required this.profileRefNumber,
    required this.groupName,
  }) : super(action: 16, expectedReactionTypes: [127]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['profileRefNumber'] = profileRefNumber;
    data['groupName'] = groupName;
    return data;
  }
}
/////////////////////////////////////////////////////
// Models for Profile
/////////////////////////////////////////////////////

class RequestAddUserIdentifierPhone extends RequestMessage {
  int regNum;
  String telephone;
  String email;
  String userIdentifierPhone;

  RequestAddUserIdentifierPhone({
    required this.regNum,
    required this.telephone,
    required this.email,
    required this.userIdentifierPhone,
  }) : super(action: 13, expectedReactionTypes: [105]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['userIdentifierPhone'] = userIdentifierPhone;

    return data;
  }
}

class RequestUserIdentifierPhoneOtp extends RequestMessage {
  int regNum;
  String telephone;
  String email;
  int otp;

  RequestUserIdentifierPhoneOtp({
    required this.regNum,
    required this.telephone,
    required this.email,
    required this.otp,
  }) : super(action: 14, expectedReactionTypes: [107]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['otp'] = otp;

    return data;
  }
}

class RequestAddUserIdentifierEmail extends RequestMessage {
  int regNum;
  String telephone;
  String email;
  String userIdentifierEmail;

  RequestAddUserIdentifierEmail({
    required this.regNum,
    required this.telephone,
    required this.email,
    required this.userIdentifierEmail,
  }) : super(action: 11, expectedReactionTypes: [106]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['userIdentifierEmail'] = userIdentifierEmail;

    return data;
  }
}

class RequestUserIdentifierEmailOtp extends RequestMessage {
  int regNum;
  String telephone;
  String email;
  int otp;

  RequestUserIdentifierEmailOtp({
    required this.regNum,
    required this.telephone,
    required this.email,
    required this.otp,
  }) : super(action: 12, expectedReactionTypes: [108]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['otp'] = otp;

    return data;
  }
}

class RequestAddProfile extends RequestMessage {
  int regNum;
  String telephone;
  String email;
  String profileName;
  int profilePin;
  String profileTelephone;
  String profileEmail;

  RequestAddProfile({
    required this.regNum,
    required this.telephone,
    required this.email,
    required this.profilePin,
    required this.profileName,
    required this.profileTelephone,
    required this.profileEmail,
  }) : super(action: 9, expectedReactionTypes: [110, 111]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['profileName'] = profileName;
    data['profileTelephone'] = profileTelephone;
    data['profileEmail'] = profileEmail;
    data['profilePin'] = profilePin;
    return data;
  }
}

class RequestEditProfile extends RequestMessage {
  int regNum;
  int profileRefNum;
  String profileName;

  RequestEditProfile({
    required this.regNum,
    required this.profileRefNum,
    required this.profileName,
  }) : super(action: 83, expectedReactionTypes: [176, 130]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['profileRefNum'] = profileRefNum;
    data['profileName'] = profileName;
    return data;
  }
}

class RequestProfileSync extends RequestMessage {
  int regNum;
  String telephone;
  String emailid;
  String lastSyncTime;

  RequestProfileSync({
    required this.regNum,
    required this.telephone,
    required this.emailid,
    required this.lastSyncTime,
  }) : super(action: 78, expectedReactionTypes: [171]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = emailid;
    data['lastSyncTime'] = lastSyncTime;
    return data;
  }
}

class RequestProfileRestore extends RequestMessage {
  int regNum;
  String emailid;
  String telephone;

  RequestProfileRestore({
    required this.emailid,
    required this.regNum,
    required this.telephone,
  }) : super(action: 44, expectedReactionTypes: [137]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = emailid;
    return data;
  }
}

class RequestSetDefaultProfile extends RequestMessage {
  int regNum;
  int profileRefNum;

  RequestSetDefaultProfile({
    required this.regNum,
    required this.profileRefNum,
  }) : super(action: 86, expectedReactionTypes: []);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['profileRefNum'] = profileRefNum;
    return data;
  }
}

class RequestRegistrationStatus extends RequestMessage {
  int regNum;
  String emailid;
  String telephone;

  RequestRegistrationStatus({
    required this.emailid,
    required this.regNum,
    required this.telephone,
  }) : super(action: 87, expectedReactionTypes: [179]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['regnum'] = regNum;
    data['phoneNumber'] = telephone;
    data['emailId'] = emailid;
    return data;
  }
}

class RequestRegistrationReset extends RequestMessage {
  int regNum;
  String phoneNumber;
  String email;

  RequestRegistrationReset({
    required this.regNum,
    required this.email,
    required this.phoneNumber,
  }) : super(action: 88, expectedReactionTypes: [180]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['regnum'] = regNum;
    data['phoneNumber'] = phoneNumber;
    data['emailId'] = email;
    return data;
  }
}

class RequestProfileDelete extends RequestMessage {
  int regNum;
  int profileRefNumber;
  String telephone;
  String email;
  String profileName;

  RequestProfileDelete({
    required this.regNum,
    required this.profileRefNumber,
    required this.email,
    required this.telephone,
    required this.profileName,
  }) : super(action: 10, expectedReactionTypes: [112, 130]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['profileRefNumber'] = profileRefNumber;
    data["profileName"] = profileName;
    return data;
  }
}

class RequestProfileDeleteSync extends RequestMessage {
  int regNum;
  int lastSyncTime;

  RequestProfileDeleteSync({
    required this.regNum,
    required this.lastSyncTime,
  }) : super(action: 84, expectedReactionTypes: [177]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['lastSyncTime'] = lastSyncTime;
    return data;
  }
}

class RequestUpdateDefaultProfile extends RequestMessage {
  int regNum;
  int profileRefNum;

  RequestUpdateDefaultProfile(
      {required this.regNum, required this.profileRefNum})
      : super(action: 86, expectedReactionTypes: [172, 178]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['profileRefNum'] = profileRefNum;
    return data;
  }
}

class RequestAcknowledgeProfileDeleteSync extends RequestMessage {
  int regNum;
  int profileRefNum;
  int lastSyncTime;

  RequestAcknowledgeProfileDeleteSync({
    required this.regNum,
    required this.profileRefNum,
    required this.lastSyncTime,
  }) : super(action: 85, expectedReactionTypes: [177]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['lastDeletedProfileRefNumber'] = profileRefNum;
    data['lastSyncTime'] = lastSyncTime;

    return data;
  }
}

class RequestProfileStatusCheck extends RequestMessage {
  int regNum;
  String telephone;
  String email;
  int profileRefNum;
  String profileTelephone;
  String profileEmail;

  RequestProfileStatusCheck({
    required this.regNum,
    required this.telephone,
    required this.email,
    required this.profileRefNum,
    required this.profileTelephone,
    required this.profileEmail,
  }) : super(action: 65, expectedReactionTypes: [160]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['profileRefNumber'] = profileRefNum;
    data['profileTelephoneNumber'] = profileTelephone;
    data['profileEmailId'] = profileEmail;
    return data;
  }
}

class RequestProfileAcknowledgement extends RequestMessage {
  int regNum;
  String telephone;
  String email;
  int lastSyncTime;
  int profileRefNum;
  String profileName;
  int chairpersonPin;
  int participantPin;
  int status;
  int acountType;
  int allowStatusISD;
  int balanceAmountByte;
  int profileSize;
  List<Char> endDateOfPlanByte;
  int facilityElement;
  int defaultProfileFlag;

  RequestProfileAcknowledgement({
    required this.regNum,
    required this.telephone,
    required this.email,
    required this.lastSyncTime,
    required this.profileRefNum,
    required this.profileName,
    required this.chairpersonPin,
    required this.participantPin,
    required this.status,
    required this.acountType,
    required this.allowStatusISD,
    required this.balanceAmountByte,
    required this.profileSize,
    required this.facilityElement,
    required this.endDateOfPlanByte,
    required this.defaultProfileFlag,
  }) : super(action: 79, expectedReactionTypes: []);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['lastSyncTime'] = lastSyncTime;
    data['profileRefNum'] = profileRefNum;
    data['profileName'] = profileName;
    data['chairpersonPin'] = chairpersonPin;
    data['participantPin'] = participantPin;
    data['status'] = status;
    data['acountType'] = acountType;
    data['allowStatusISD'] = allowStatusISD;
    data['profileSize'] = profileSize;
    data['facilityElement'] = facilityElement;
    data['defaultProfileFlag'] = defaultProfileFlag;
    data['balanceAmountByte'] = balanceAmountByte;
    data['endDateOfPlanByte'] = endDateOfPlanByte;

    return data;
  }
}

/////////////////////////////////////////////////////
// Models for Groups
/////////////////////////////////////////////////////

class RequestGroupSync extends RequestMessage {
  int regNum;
  int lastSyncTime;
  String email;
  String telephone;

  RequestGroupSync({
    required this.lastSyncTime,
    required this.regNum,
    required this.email,
    required this.telephone,
  }) : super(action: 62, expectedReactionTypes: [138]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['lastSyncTime'] = lastSyncTime;
    return data;
  }
}

class RequestFetchGroupMembers extends RequestMessage {
  int regNum;
  int groupId;
  String email;
  String telephone;

  RequestFetchGroupMembers({
    required this.groupId,
    required this.regNum,
    required this.email,
    required this.telephone,
  }) : super(action: 68, expectedReactionTypes: [139]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['groupId'] = groupId;
    return data;
  }
}

class RequestCreateGroup extends RequestMessage {
  int regNum;
  String email;
  String telephone;
  String groupName;
  int totalIterations;
  int profileRefNumber;
  int groupMembersCount;

  RequestCreateGroup({
    required this.regNum,
    required this.email,
    required this.telephone,
    required this.groupName,
    required this.totalIterations,
    required this.profileRefNumber,
    required this.groupMembersCount,
  }) : super(action: 16, expectedReactionTypes: [109]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['groupName'] = groupName;
    data['totalIterations'] = totalIterations;
    data['profileRefNumber'] = profileRefNumber;
    data['groupMembersCount'] = groupMembersCount;
    return data;
  }
}

class RequestDeleteGroup extends RequestMessage {
  int regNum;
  String email;
  String telephone;
  String groupName;

  RequestDeleteGroup({
    required this.regNum,
    required this.email,
    required this.telephone,
    required this.groupName,
  }) : super(action: 20, expectedReactionTypes: [114]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['groupName'] = groupName;
    return data;
  }
}

class RequestAddFavoriteGroup extends RequestMessage {
  int regNum;
  String email;
  String telephone;
  String groupName;
  int profileRefNumber;

  RequestAddFavoriteGroup({
    required this.regNum,
    required this.email,
    required this.telephone,
    required this.groupName,
    required this.profileRefNumber,
  }) : super(action: 21, expectedReactionTypes: [115]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['groupName'] = groupName;
    data['profileRefNumber'] = profileRefNumber;
    return data;
  }
}

class RequestRemoveFavoriteGroup extends RequestMessage {
  int regNum;
  String email;
  String telephone;
  String groupName;

  RequestRemoveFavoriteGroup({
    required this.regNum,
    required this.email,
    required this.telephone,
    required this.groupName,
  }) : super(action: 22, expectedReactionTypes: [116]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['groupName'] = groupName;
    return data;
  }
}

class RequestFavoriteGroup extends RequestMessage {
  int regNum;
  String email;
  String telephone;
  String groupName;
  int profileRefNum;

  RequestFavoriteGroup({
    required this.regNum,
    required this.email,
    required this.telephone,
    required this.groupName,
    required this.profileRefNum,
  }) : super(action: 21, expectedReactionTypes: []);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['groupName'] = groupName;
    data['profileRefNum'] = profileRefNum;
    return data;
  }
}

/////////////////////////////////////////////////////
// Models for Calls
/////////////////////////////////////////////////////
class RequestScheduleCallRestore extends RequestMessage {
  int regNum;
  String email;
  String telephone;
  String dateFrom;
  int scheduleRefNumber;

  RequestScheduleCallRestore({
    required this.regNum,
    required this.email,
    required this.telephone,
    required this.dateFrom,
    required this.scheduleRefNumber,
  }) : super(action: 48, expectedReactionTypes: [142, 150]);

  // 142 = RESTORE_SCHEDULE_START_RESPONSE
  // 150 = RESTORE_SCHEDULE_MEMBER_RESPONSE

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['dateFrom'] = dateFrom;
    data['scheduleRefNumber'] = scheduleRefNumber;
    return data;
  }
}

/// Restore call history for a user
class RequestCallHistoryRestore extends RequestMessage {
  int regNum;
  String email;
  String telephone;

  RequestCallHistoryRestore({
    required this.regNum,
    required this.email,
    required this.telephone,
  }) : super(action: 49, expectedReactionTypes: [143]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    return data;
  }
}

/////////////////////////////////////////////////////
// Models for Call Me On
/////////////////////////////////////////////////////

class RequestCallMeOnRestore extends RequestMessage {
  int regNum;
  String emailid;
  String telephone;

  RequestCallMeOnRestore({
    required this.emailid,
    required this.regNum,
    required this.telephone,
  }) : super(action: 50, expectedReactionTypes: [144]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = emailid;
    return data;
  }
}

class NumberEntry {
  final int type;
  final String callMeOnNumber;

  NumberEntry({required this.type, required this.callMeOnNumber});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'callMeOnNumber': callMeOnNumber,
    };
  }
}

class RequestCallMeOnUpdate extends RequestMessage {
  int regNum;
  String email;
  String telephone;
  int totalMembersCount;

  List<NumberEntry> members;

  RequestCallMeOnUpdate({
    required this.email,
    required this.regNum,
    required this.telephone,
    required this.totalMembersCount,
    required this.members,
  }) : super(action: 15, expectedReactionTypes: [104]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['totalMembersCount'] = totalMembersCount;
    data['members'] = members;
    return data;
  }
}

/////////////////////////////////////////////////////
// Models for App
/////////////////////////////////////////////////////

class RequestInvitationSync extends RequestMessage {
  int regNum;
  String email;
  String telephone;

  RequestInvitationSync({
    required this.email,
    required this.regNum,
    required this.telephone,
  }) : super(action: 58, expectedReactionTypes: [147]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    return data;
  }
}

class RequestCancelInvitationSync extends RequestMessage {
  int regNum;
  String email;
  String telephone;

  RequestCancelInvitationSync({
    required this.email,
    required this.regNum,
    required this.telephone,
  }) : super(action: 63, expectedReactionTypes: []);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    return data;
  }
}

class RequestReconnect extends RequestMessage {
  int regNum;
  String email;
  String telephone;

  RequestReconnect({
    required this.email,
    required this.regNum,
    required this.telephone,
  }) : super(action: 39, expectedReactionTypes: [131]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    return data;
  }
}

class CheckHealthCheckResponse extends RequestMessage {
  int regNum;
  int healthCheckResponse;

  CheckHealthCheckResponse({
    required this.regNum,
    required this.healthCheckResponse,
  }) : super(action: 102, expectedReactionTypes: [198]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['healthCheckResponse'] = healthCheckResponse;
    return data;
  }
}

class RequestCodeCheckEmailIdPrimaryCheck extends RequestMessage {
  int appSocketId;
  String emailId;
  int socialNetworkFlag;

  RequestCodeCheckEmailIdPrimaryCheck({
    required this.appSocketId,
    required this.emailId,
    required this.socialNetworkFlag,
  }) : super(action: 103, expectedReactionTypes: [199, 102]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['appSocketId'] = appSocketId;
    data['requestedEmailId'] = emailId;
    data['socialNetworkFlag'] = socialNetworkFlag;
    return data;
  }
}

class App2MMReqAdvertisementDetails extends RequestMessage {
  int regNum;
  int memberCount;
  int profileRefNumber;

  App2MMReqAdvertisementDetails({
    required this.regNum,
    required this.memberCount,
    required this.profileRefNumber,
  }) : super(action: 106, expectedReactionTypes: [201]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['regNumb'] = regNum;
    data['memberCount'] = memberCount;
    data['profileRefNum'] = profileRefNumber;
    return data;
  }
}

class App2MMRequestToSendEnterprisePlanToMcSupport extends RequestMessage {
  int regNum;
  String phoneNumber;
  String name;
  String email;

  App2MMRequestToSendEnterprisePlanToMcSupport({
    required this.regNum,
    required this.phoneNumber,
    required this.name,
    required this.email,
  }) : super(action: 107, expectedReactionTypes: [203]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['regNum'] = regNum;
    data['phone'] = phoneNumber;
    data['email'] = email;
    data['name'] = name;
    return data;
  }
}

// Request Group Restore
class RequestRestoreGroup extends RequestMessage {
  int regNum;
  String email;
  String telephone;

  RequestRestoreGroup({
    required this.regNum,
    required this.email,
    required this.telephone,
  }) : super(action: 45, expectedReactionTypes: [138]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    return data;
  }
}

// Request To Add New Members To Group
class RequestAddNewMembersToGroup extends RequestMessage {
  int regNum;
  String groupName;
  int currentIterationNumber;
  int membersInCurrentIteration;
  List<GroupMembers> members;

  RequestAddNewMembersToGroup({
    required this.regNum,
    required this.groupName,
    required this.currentIterationNumber,
    required this.membersInCurrentIteration,
    required this.members,
  }) : super(action: 17, expectedReactionTypes: [109]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['groupName'] = groupName;
    data['currentIterationNumber'] = currentIterationNumber;
    data['membersInCurrentIteration'] = membersInCurrentIteration;
    data['members'] = members;
    return data;
  }
}

class GroupMembers {
  String? memberName;
  String memberTelephone;
  String? memberEmail;

  GroupMembers({
    this.memberName,
    required this.memberTelephone,
    this.memberEmail,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (memberName != null) data['memberName'] = memberName;
    data['memberTelephone'] = memberTelephone;
    if (memberEmail != null) data['memberEmail'] = memberEmail;
    return data;
  }
}

// Request Edit Group details
class RequestEditGroupDetails extends RequestMessage {
  int regNum;
  String email;
  String telephone;
  int totalIterations;
  String oldGroupName;
  String newGroupName;
  int profileRefNumber;
  int groupMemberCount;

  RequestEditGroupDetails({
    required this.regNum,
    required this.email,
    required this.telephone,
    required this.totalIterations,
    required this.oldGroupName,
    required this.newGroupName,
    required this.profileRefNumber,
    required this.groupMemberCount,
  }) : super(action: 18, expectedReactionTypes: []);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['telephone'] = telephone;
    data['emailid'] = email;
    data['totalIterations'] = totalIterations;
    data['oldGroupName'] = oldGroupName;
    data['newGroupName'] = newGroupName;
    data['profileRefNumber'] = profileRefNumber;
    data['groupMemberCount'] = groupMemberCount;
    return data;
  }
}

// Request Edit Group Members
class RequestEditGroupMembers extends RequestMessage {
  int regNum;
  int currentIteration;
  String oldGroupName;
  String newGroupName;
  int membersInCurrentIteration;
  List<GroupMembers> members;

  RequestEditGroupMembers({
    required this.regNum,
    required this.currentIteration,
    required this.oldGroupName,
    required this.newGroupName,
    required this.membersInCurrentIteration,
    required this.members,
  }) : super(action: 19, expectedReactionTypes: [113]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['currentIteration'] = currentIteration;
    data['oldGroupName'] = oldGroupName;
    data['newGroupName'] = newGroupName;
    data['membersInCurrentIteration'] = membersInCurrentIteration;
    data['members'] = members;
    return data;
  }
}

/// Model for Request Schedule Call
class RequestScheduleCall extends RequestMessage {
  int registrationNumber; // Registration number
  String telephone; // Telephone
  String emailid; // Email ID
  int profileRefNumber; // Profile reference number
  int totalIterations; // Total iterations
  String chairPersonPhoneNumber; // Chairperson phone number
  int callType; // Call type: 2
  int startType; // Type of start: 1 = auto, 2 = user
  int scheduleRefNumber; // Schedule reference number
  String scheduleName; // Schedule name
  int totalMembersCount; // Total members count
  int conferenceDuration; // Conference duration in minutes
  String
      scheduleStartDateTime; // Schedule start date-time format: 2024-06-27 16:56
  int repeatType; // Repeat type: 0 - Never, 1 - EveryDay, 2 - Every Week, 4 - Every Month
  String repeatEndDate; // Repeat end date format: 2024-06-27
  int dialinFlag; // Dialin flag: dialout = 0, dialin = 1
  String dialinDid; // Dialin DID

  RequestScheduleCall({
    required this.registrationNumber,
    required this.telephone,
    required this.emailid,
    required this.profileRefNumber,
    required this.totalIterations,
    required this.chairPersonPhoneNumber,
    required this.callType,
    required this.startType,
    required this.scheduleRefNumber,
    required this.scheduleName,
    required this.totalMembersCount,
    required this.conferenceDuration,
    required this.scheduleStartDateTime,
    required this.repeatType,
    required this.repeatEndDate,
    required this.dialinFlag,
    required this.dialinDid,
  }) : super(action: 40, expectedReactionTypes: [145]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailid;
    data['profileRefNumber'] = profileRefNumber;
    data['totalIterations'] = totalIterations;
    data['chairPersonPhoneNumber'] = chairPersonPhoneNumber;
    data['callType'] = callType;
    data['startType'] = startType;
    data['scheduleRefNumber'] = scheduleRefNumber;
    data['scheduleName'] = scheduleName;
    data['totalMembersCount'] = totalMembersCount;
    data['conferenceDuration'] = conferenceDuration;
    data['scheduleStartDateTime'] = scheduleStartDateTime;
    data['repeatType'] = repeatType;
    data['repeatEndDate'] = repeatEndDate;
    data['dialinFlag'] = dialinFlag;
    data['dialinDid'] = dialinDid;
    return data;
  }
}

/////////////////////////////////////////////////////
// Models for Payment section
/////////////////////////////////////////////////////

class RequestTopUP extends RequestMessage {
  int regNum;
  int profileRefNum;
  String message;

  RequestTopUP({
    required this.profileRefNum,
    required this.regNum,
    required this.message,
  }) : super(action: 80, expectedReactionTypes: [173]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['profileRefNumber'] = profileRefNum;
    data['message'] = message;
    return data;
  }
}

class RequestCreateRetailProfile extends RequestMessage {
  int regNum;
  String telephone;
  String email;
  String profileName;
  String profileTelephone;
  String profileEmail;

  RequestCreateRetailProfile({
    required this.regNum,
    required this.telephone,
    required this.email,
    required this.profileName,
    required this.profileTelephone,
    required this.profileEmail,
  }) : super(action: 89, expectedReactionTypes: [182, 183]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['registeredPhoneNumber'] = telephone;
    data['registeredEmailId'] = email;
    data['profileName'] = profileName;
    data['profilePhoneNumber'] = profileTelephone;
    data['profileEmailId'] = profileEmail;

    return data;
  }
}

class RequestAccountDetails extends RequestMessage {
  int regNum;
  int profileRefNum;

  RequestAccountDetails({
    required this.profileRefNum,
    required this.regNum,
  }) : super(action: 90, expectedReactionTypes: [184]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileRefNumber'] = profileRefNum;

    return data;
  }
}

class RequestForRetailProfileBalance extends RequestMessage {
  int regNum;
  String profileRefNum;
  int accountId;

  RequestForRetailProfileBalance({
    required this.profileRefNum,
    required this.regNum,
    required this.accountId,
  }) : super(action: 91, expectedReactionTypes: [185]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileRefNumber'] = profileRefNum;
    data['accountId'] = accountId;
    return data;
  }
}

class RequestBasePlanDetails extends RequestMessage {
  int regNum;
  int profileRefNum;
  int accountId;
  int basePlanId;

  RequestBasePlanDetails({
    required this.accountId,
    required this.profileRefNum,
    required this.regNum,
    required this.basePlanId,
  }) : super(action: 92, expectedReactionTypes: [186]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileReferenceNumber'] = profileRefNum;
    data['accountId'] = accountId;
    data['basePlanId'] = basePlanId;
    return data;
  }
}

class AckResponseFromBasePlanDetails extends RequestMessage {
  int regNum;
  int profileRefNum;
  int accountId;
  int jobId;

  AckResponseFromBasePlanDetails({
    required this.accountId,
    required this.profileRefNum,
    required this.regNum,
    required this.jobId,
  }) : super(action: 93, expectedReactionTypes: [186]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileRefNumber'] = profileRefNum;
    data['accountId'] = accountId;
    data['jobId'] = jobId;
    return data;
  }
}

class RequestAddOnPlans extends RequestMessage {
  int regNum;
  int profileRefNum;
  int accountId;
  int basePlanId;

  RequestAddOnPlans({
    required this.accountId,
    required this.profileRefNum,
    required this.regNum,
    required this.basePlanId,
  }) : super(action: 94, expectedReactionTypes: [187]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileReferenceNumber'] = profileRefNum;
    data['accountId'] = accountId;
    data['basePlanId'] = basePlanId;
    return data;
  }
}

class AckForResponseAddOnPlans extends RequestMessage {
  int regNum;
  int profileRefNum;
  int accountId;
  int basePlanId;
  int jobId;

  AckForResponseAddOnPlans({
    required this.accountId,
    required this.profileRefNum,
    required this.regNum,
    required this.basePlanId,
    required this.jobId,
  }) : super(action: 95, expectedReactionTypes: [187]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileReferenceNumber'] = profileRefNum;
    data['accountId'] = accountId;
    data['basePlanId'] = basePlanId;
    data['jobId'] = jobId;
    return data;
  }
}

class RequestForRetailPaymentHistory extends RequestMessage {
  int regNum;
  String profileRefNum;

  RequestForRetailPaymentHistory({
    required this.profileRefNum,
    required this.regNum,
  }) : super(action: 96, expectedReactionTypes: [188]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileRefNumber'] = profileRefNum;
    return data;
  }
}

class RequestProfileOverdueAmount extends RequestMessage {
  int regNum;
  int profileRefNum;

  RequestProfileOverdueAmount({
    required this.profileRefNum,
    required this.regNum,
  }) : super(action: 97, expectedReactionTypes: [189]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileReferenceNumber'] = profileRefNum;
    return data;
  }
}

class RequestRetailPayOption extends RequestMessage {
  int regNum;
  int profileRefNum;

  RequestRetailPayOption({
    required this.profileRefNum,
    required this.regNum,
  }) : super(action: 98, expectedReactionTypes: [190]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileRefNumber'] = profileRefNum;
    return data;
  }
}

class SwitchToFreePlan extends RequestMessage {
  int regNum;
  int profileRefNum;

  SwitchToFreePlan({
    required this.profileRefNum,
    required this.regNum,
  }) : super(action: 99, expectedReactionTypes: [191]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileRefNumber'] = profileRefNum;
    return data;
  }
}

class RequestCurrentPlanActiveStatus extends RequestMessage {
  int regNum;
  int profileRefNum;
  int requestType;

  RequestCurrentPlanActiveStatus({
    required this.profileRefNum,
    required this.regNum,
    required this.requestType,
  }) : super(action: 100, expectedReactionTypes: [192]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileReferenceNumber'] = profileRefNum;
    data['requestType'] = requestType;

    return data;
  }
}

class RequestActiveStatus extends RequestMessage {
  int regNum;
  int reqType;
  int profileRefNum;

  RequestActiveStatus({
    required this.profileRefNum,
    required this.regNum,
    required this.reqType,
  }) : super(action: 101, expectedReactionTypes: [193]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registeredNumber'] = regNum;
    data['profileReferenceNumber'] = profileRefNum;
    data['requestType'] = reqType;
    return data;
  }
}

/// Model for Request End Call Participant
class RequestEndCallParticipant extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int scheduleRefNumber;
  String participantPhoneNumber;
  int profileRefNumber;

  RequestEndCallParticipant({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.scheduleRefNumber,
    required this.participantPhoneNumber,
    required this.profileRefNumber,
  }) : super(action: 32, expectedReactionTypes: [165]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    data['scheduleRefNumber'] = scheduleRefNumber;
    data['participantPhoneNumber'] = participantPhoneNumber;
    data['profileRefNumber'] = profileRefNumber;
    return data;
  }
}

/// Model for Request End Call All
class RequestEndCallAll extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int scheduleRefNumber;
  int profileRefNumber;

  RequestEndCallAll({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.scheduleRefNumber,
    required this.profileRefNumber,
  }) : super(action: 33, expectedReactionTypes: [24]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    data['scheduleRefNumber'] = scheduleRefNumber;
    data['profileRefNumber'] = profileRefNumber;
    return data;
  }
}

/// Model for Request Schedule Members
class RequestScheduleMembers extends RequestMessage {
  int registrationNumber;
  String chairPersonPhoneNumber;
  int messageNumber;
  int totalNumberOfMembers;
  List<ScheduleCallMember> members;

  RequestScheduleMembers({
    required this.registrationNumber,
    required this.chairPersonPhoneNumber,
    required this.messageNumber,
    required this.totalNumberOfMembers,
    required this.members,
  }) : super(action: 41, expectedReactionTypes: [133]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['chairPersonPhoneNumber'] = chairPersonPhoneNumber;
    data['messageNumber'] = messageNumber;
    data['totalNumberOfMembers'] = totalNumberOfMembers;
    data['members'] = members.map((member) => member.toJson()).toList();
    return data;
  }
}

/// Model for Schedule Call Member
class ScheduleCallMember {
  String memberName;
  String memberTelephone;
  String memberEmail;

  ScheduleCallMember({
    required this.memberName,
    required this.memberTelephone,
    required this.memberEmail,
  });

  factory ScheduleCallMember.fromJson(Map<String, dynamic> json) {
    return ScheduleCallMember(
      memberName: json['memberName'],
      memberTelephone: json['memberTelephone'],
      memberEmail: json['memberEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberName': memberName,
      'memberTelephone': memberTelephone,
      'memberEmail': memberEmail,
    };
  }
}

/// Model for Repeat
class RepeatModel {
  int repeat;
  String repeatText;
  String? repeatTill;

  RepeatModel({
    required this.repeat,
    required this.repeatText,
    this.repeatTill,
  });

  factory RepeatModel.fromJson(Map<String, dynamic> json) {
    return RepeatModel(
      repeat: json['repeat'],
      repeatText: json['repeatText'],
      repeatTill: json['repeatTill'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'repeat': repeat,
      'repeatText': repeatText,
      'repeatTill': repeatTill,
    };
  }

  static List<RepeatModel> getDefaultRepeats() {
    return [
      RepeatModel(repeat: 0, repeatText: 'Never'),
      RepeatModel(repeat: 1, repeatText: 'EveryDay'),
      RepeatModel(repeat: 2, repeatText: 'Every Week'),
      RepeatModel(repeat: 4, repeatText: 'Every Month'),
    ];
  }
}

/// Model for Member
class Member {
  String name;
  String telephone;
  String email;

  Member({
    required this.name,
    required this.telephone,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'telephone': telephone,
      'email': email,
    };
  }
}

/// Model for Request Reschedule Call
class RequestRescheduleCall extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailid;
  int profileRefNumber;
  int scheduleRefNumber;
  String scheduleStartDateTime;

  RequestRescheduleCall({
    required this.registrationNumber,
    required this.telephone,
    required this.emailid,
    required this.profileRefNumber,
    required this.scheduleRefNumber,
    required this.scheduleStartDateTime,
  }) : super(action: 42, expectedReactionTypes: [135]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailid;
    data['profileRefNumber'] = profileRefNumber;
    data['scheduleRefNumber'] = scheduleRefNumber;
    data['scheduleStartDateTime'] = scheduleStartDateTime;
    return data;
  }
}

/// Model for Request Delete Schedule
class RequestDeleteSchedule extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailid;
  int profileRefNumber;
  int scheduleRefNumber;
  int recurrentId;

  RequestDeleteSchedule({
    required this.registrationNumber,
    required this.telephone,
    required this.emailid,
    required this.profileRefNumber,
    required this.scheduleRefNumber,
    required this.recurrentId,
  }) : super(action: 43, expectedReactionTypes: [136, 152]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailid;
    data['profileRefNumber'] = profileRefNumber;
    data['scheduleRefNumber'] = scheduleRefNumber;
    data['recurrentId'] = recurrentId;
    return data;
  }
}

/// Model for Request Start Schedule Call
class RequestStartScheduleCall extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int profileRefNumber;
  int scheduleRefNumber;

  RequestStartScheduleCall({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.profileRefNumber,
    required this.scheduleRefNumber,
  }) : super(action: 51, expectedReactionTypes: [146, 164]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    data['profileRefNumber'] = profileRefNumber;
    data['scheduleRefNumber'] = scheduleRefNumber;
    return data;
  }
}

/// Model for Request Response To Invitation Call
class RequestResponseToInvitationCall extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int scheduleRefNumber;
  int actionType;
  int recurrentId;

  RequestResponseToInvitationCall({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.scheduleRefNumber,
    required this.actionType,
    required this.recurrentId,
  }) : super(action: 53, expectedReactionTypes: [
          /* add expected reaction types */
        ]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    data['scheduleRefNumber'] = scheduleRefNumber;
    data['actionValue'] = actionType;
    data['recurrentId'] = recurrentId;
    data['dummyRef'] = 0;
    return data;
  }
}

/// Model for Request Change Conferees Members
class RequestChangeConfereesMembers extends RequestMessage {
  int registrationNumber;
  String chairPersonPhoneNumber;
  int messageNumber;
  int totalNumberOfMembers;
  List<Member> members;

  RequestChangeConfereesMembers({
    required this.registrationNumber,
    required this.chairPersonPhoneNumber,
    required this.messageNumber,
    required this.totalNumberOfMembers,
    required this.members,
  }) : super(action: 55, expectedReactionTypes: [
          /* add expected reaction types */
        ]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['chairPersonPhoneNumber'] = chairPersonPhoneNumber;
    data['messageNumber'] = messageNumber;
    data['totalNumberOfMembers'] = totalNumberOfMembers;
    data['members'] = members.map((member) => member.toJson()).toList();
    return data;
  }
}

/// Model for Cloud Messaging
class RequestCloudMessaging extends RequestMessage {
  int registrationNumber;
  int osType;
  int deviceTokenLength;
  String deviceToken;
  String deviceModel;
  String deviceOs;
  String buildVersion;

  RequestCloudMessaging({
    required this.registrationNumber,
    required this.osType,
    required this.deviceTokenLength,
    required this.deviceToken,
    required this.deviceModel,
    required this.deviceOs,
    required this.buildVersion,
  }) : super(action: 57, expectedReactionTypes: [
          /* no expected reaction types */
        ]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['osType'] = osType;
    data['deviceTokenLength'] = deviceTokenLength;
    data['deviceToken'] = deviceToken;
    data['deviceModel'] = deviceModel;
    data['deviceOs'] = deviceOs;
    data['buildVersion'] = buildVersion;
    return data;
  }
}

/// Model for Request Group Acknowledgement
class RequestGroupAcknowledgement extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int lastSyncTime;
  int groupId;

  RequestGroupAcknowledgement({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.lastSyncTime,
    required this.groupId,
  }) : super(action: 72, expectedReactionTypes: [
          /* add expected reaction types */
        ]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    data['lastSyncTime'] = lastSyncTime;
    data['groupId'] = groupId;
    return data;
  }
}

/// Model for Request User Email User Identifier Restore
class RequestRestoreUserEmails extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;

  RequestRestoreUserEmails({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
  }) : super(action: 46, expectedReactionTypes: [140]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    return data;
  }
}

/// Model for Request User Phone User Identifier Restore
class RequestRestoreUserPhoneNumbers extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;

  RequestRestoreUserPhoneNumbers({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
  }) : super(action: 47, expectedReactionTypes: [141]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    return data;
  }
}

/// Model for Request Instant Pickup
class RequestInstantPickup extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int totalNumberOfMessages;
  String chairPersonPhoneNumber;
  int profileRefNumber;
  int callType;
  int conferenceStartTime;
  int conferenceDuration;
  int otherFeatures;
  int typeOfStart;
  int scheduleRefNumber;
  int totalMembers;
  String confereeEmail;

  RequestInstantPickup({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.totalNumberOfMessages,
    required this.chairPersonPhoneNumber,
    required this.profileRefNumber,
    required this.callType,
    required this.conferenceStartTime,
    required this.conferenceDuration,
    required this.otherFeatures,
    required this.typeOfStart,
    required this.scheduleRefNumber,
    required this.totalMembers,
    required this.confereeEmail,
  }) : super(action: 66, expectedReactionTypes: [126, 164, 165, 132]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    data['totalNumberOfMessages'] = totalNumberOfMessages;
    data['chairPersonPhoneNumber'] = chairPersonPhoneNumber;
    data['profileRefNumber'] = profileRefNumber;
    data['callType'] = callType;
    data['conferenceStartTime'] = conferenceStartTime;
    data['conferenceDuration'] = conferenceDuration;
    data['otherFeatures'] = otherFeatures;
    data['typeOfStart'] = typeOfStart;
    data['scheduleRefNumber'] = scheduleRefNumber;
    data['totalMembers'] = totalMembers;
    data['confereeEmail'] = confereeEmail;
    return data;
  }
}

/// Model for Request Instant Pickup Members
class RequestInstantPickupMembers extends RequestMessage {
  int registrationNumber;
  String chairPersonPhoneNumber;
  int messageNumber;
  int totalNumberOfMembers;
  List<GroupMembers> members;

  RequestInstantPickupMembers({
    required this.registrationNumber,
    required this.chairPersonPhoneNumber,
    required this.messageNumber,
    required this.totalNumberOfMembers,
    required this.members,
  }) : super(action: 67, expectedReactionTypes: [126, 164, 165, 132]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['chairPersonPhoneNumber'] = chairPersonPhoneNumber;
    data['messageNumber'] = messageNumber;
    data['totalNumberOfMembers'] = totalNumberOfMembers;
    data['members'] = members;
    return data;
  }
}

/// Model for Request Schedule Invite Acknowledgement
class RequestScheduleInviteAcknowledgement extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int scheduleRefNumber;

  RequestScheduleInviteAcknowledgement({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.scheduleRefNumber,
  }) : super(action: 70, expectedReactionTypes: [149]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    data['scheduleRefNumber'] = scheduleRefNumber;
    return data;
  }
}

/// Model for Request Schedule Cancel Acknowledgement
class RequestScheduleCancelAcknowledgement extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int scheduleRefNumber;

  RequestScheduleCancelAcknowledgement({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.scheduleRefNumber,
  }) : super(action: 71, expectedReactionTypes: [
          /* add expected reaction types */
        ]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailId'] = emailId;
    data['scheduleRefNumber'] = scheduleRefNumber;
    return data;
  }
}

/////////////////////////////////////////////////////
// Models for User Feedback
/////////////////////////////////////////////////////

class RequestUserFeedback extends RequestMessage {
  int regNum;
  String unusedString;
  String feedbackMessage;

  RequestUserFeedback({
    required this.feedbackMessage,
    required this.regNum,
    required this.unusedString,
  }) : super(action: 64, expectedReactionTypes: []);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['unusedString'] = unusedString;
    data['feedbackMessage'] = feedbackMessage;
    return data;
  }
}

/// Model for Request Did Lists For Dial In
class RequestDidListsForDialIn extends RequestMessage {
  int registrationNumber;
  int appSocketId;
  int profileRefNum;

  RequestDidListsForDialIn({
    required this.registrationNumber,
    required this.appSocketId,
    required this.profileRefNum,
  }) : super(action: 104, expectedReactionTypes: [200]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['appSocketId'] = appSocketId;
    data['profileRefNum'] = profileRefNum;
    return data;
  }
}

/// Model for Request Bulk Update
class RequestBulkUpdate extends RequestMessage {
  int registrationNumber;

  RequestBulkUpdate({
    required this.registrationNumber,
  }) : super(action: 69, expectedReactionTypes: [52]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    return data;
  }
}

/// Model for Request Customer Care Number
class RequestCustomerCareNumber extends RequestMessage {
  int registrationNumber;

  RequestCustomerCareNumber({
    required this.registrationNumber,
  }) : super(action: 75, expectedReactionTypes: [168]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    return data;
  }
}

/// Model for fcm

class RequestFCM extends RequestMessage {
  int regNum;
  String token;

  RequestFCM({
    required this.regNum,
    required this.token,
  }) : super(action: 81, expectedReactionTypes: []);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = regNum;
    data['deviceToken'] = token;
    return data;
  }
}

/// Model for Health check
class RequestHealthCheck extends RequestMessage {
  int registrationNumber;

  RequestHealthCheck({
    required this.registrationNumber,
  }) : super(action: 250, expectedReactionTypes: [250]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    return data;
  }
}
