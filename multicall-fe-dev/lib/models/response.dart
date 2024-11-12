import 'package:intl/intl.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/group.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:provider/provider.dart';

abstract class RecievedMessage {
  final int reactionType;
  final bool status;

  RecievedMessage({required this.reactionType, required this.status});
}

class DefaultError extends RecievedMessage {
  String message;

  DefaultError({
    required this.message,
  }) : super(reactionType: -1, status: false);
}

class RegistrationSuccess extends RecievedMessage {
  int regNum;
  bool? isTelNoRegistered;
  bool? isEmailRegistered;
  int? primaryRegFlag;
  late String failReason;

  static List<String> errorMessage = [
    '',
    'The mobile number is already in use in another MultiCall Registration.',
    'The Email ID is already in use in another MultiCall Registration. ',
    'Registered with MultiCall too many times.',
    'Invalid SMS OTP',
    'Invalid Email OTP',
    'Primary Reg is not completed; So Secondary Failure (Msg Try after some times)',
    'Max SMS OTP Verification Attempt Exceeded',
    'Max EMAIL OTP Verification Attempt Exceeded',
    'Max SMS OTP Resend Attempt Exceeded',
    'Max EMAIL OTP Resend Attempt Exceeded',
    'Timed-out on SMS OTP Reg State',
    'Timed-out on EMAIL OTP Reg State'
  ];

  RegistrationSuccess({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    this.isTelNoRegistered = false,
    this.isEmailRegistered = false,
    this.primaryRegFlag = 0,
    this.failReason = "",
  });

  factory RegistrationSuccess.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return RegistrationSuccess(
        status: false,
        reactionType: json['reactionType'],
        regNum: -1,
        failReason: errorMessage[json['failReason']],
      );
    }
    return RegistrationSuccess(
      status: true,
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      isTelNoRegistered: json['isTelNoRegistered'] != 0,
      isEmailRegistered: json['isEmailRegistered'] != 0,
      primaryRegFlag: json['primaryRegFlag'],
    );
  }
}

class RestoreProfileSuccess extends RecievedMessage {
  int totalCountOfProfiles;
  late String failReason;
  int profilesIncluded;
  int sequenceNo;
  List<Profile> profiles;
  String uniqueId;

  static List<String> errorMessage = [
    '',
  ];

  RestoreProfileSuccess({
    super.status = false,
    required super.reactionType,
    required this.totalCountOfProfiles,
    this.failReason = "",
    required this.profilesIncluded,
    required this.sequenceNo,
    required this.profiles,
    required this.uniqueId,
  });

  factory RestoreProfileSuccess.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return RestoreProfileSuccess(
        status: false,
        reactionType: json['reactionType'],
        totalCountOfProfiles: -1,
        failReason: errorMessage[json['failReason']],
        profilesIncluded: 0,
        sequenceNo: 0,
        profiles: [],
        uniqueId: "",
      );
    }
    return RestoreProfileSuccess(
      status: true,
      reactionType: json['reactionType'],
      totalCountOfProfiles: json['totalCountOfProfiles'],
      profilesIncluded: json['profilesIncluded'],
      sequenceNo: json['sequenceNo'],
      profiles: (json['persons'] as List)
          .map((person) => Profile.fromJson(person))
          .toList(),
      uniqueId: json['uniqueId'],
    );
  }
}

class UpdateDefaultProfileSuccess extends RecievedMessage {
  late String failReason;
  int profileRefNo;
  int actionStatus;

  String uniqueId;

  static List<String> errorMessage = [
    'Profile Not Exist',
    'Profile Disabled (NOT IN USE)',
  ];

  UpdateDefaultProfileSuccess({
    super.status = false,
    required super.reactionType,
    this.failReason = "",
    required this.profileRefNo,
    this.actionStatus = 0,
    required this.uniqueId,
  });

  factory UpdateDefaultProfileSuccess.fromJson(Map<String, dynamic> json) {
    if (json['actionStatus'] == 2) {
      final index = json['failureReason'] - 1;

      return UpdateDefaultProfileSuccess(
        status: false,
        reactionType: json['reactionType'],
        failReason: errorMessage[index],
        profileRefNo: json['profileRefNo'],
        uniqueId: json["uniqueId"],
      );
    }
    return UpdateDefaultProfileSuccess(
      status: true,
      reactionType: json['reactionType'],
      profileRefNo: json['profileRefNo'],
      uniqueId: json['uniqueId'],
    );
  }
}

class SyncProfileSuccess extends RecievedMessage {
  // late String failReason;
  int profileRefNo;
  int actionStatus;

  String uniqueId;

  static List<String> errorMessage = [
    'Profile Not Exist',
    'Profile Disabled (NOT IN USE)',
  ];

  SyncProfileSuccess({
    super.status = false,
    required super.reactionType,
    // this.failReason = "",
    required this.profileRefNo,
    this.actionStatus = 0,
    required this.uniqueId,
  });

  factory SyncProfileSuccess.fromJson(Map<String, dynamic> json) {
    if (json['actionStatus'] == 2) {
      // final index = json['failureReason'] - 1;

      return SyncProfileSuccess(
        status: false,
        reactionType: json['reactionType'],
        // failReason: errorMessage[index],
        profileRefNo: json['profileRefNo'],
        uniqueId: json["uniqueId"],
      );
    }
    return SyncProfileSuccess(
      status: true,
      reactionType: json['reactionType'],
      profileRefNo: json['profileRefNo'],
      uniqueId: json['uniqueId'],
    );
  }
}

class SyncDeletedProfileSuccess extends RecievedMessage {
  int profileRefNo;

  String uniqueId;

  SyncDeletedProfileSuccess({
    super.status = false,
    required super.reactionType,
    required this.profileRefNo,
    required this.uniqueId,
  });

  factory SyncDeletedProfileSuccess.fromJson(Map<String, dynamic> json) {
    if (json['actionStatus'] == 2) {
      return SyncDeletedProfileSuccess(
        status: false,
        reactionType: json['reactionType'],
        profileRefNo: json['profileRefNo'],
        uniqueId: json["uniqueId"],
      );
    }
    return SyncDeletedProfileSuccess(
      status: true,
      reactionType: json['reactionType'],
      profileRefNo: json['profileRefNo'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestCreateRetailProfileSuccess extends RecievedMessage {
  int regNum;
  String profileEmail;
  int chairpersonPin;
  int profileRefNum;
  int participantPin;
  int accountType;
  int allowStatusISD;
  int profileSize;
  int facilityElement;
  int defaultProfileFlag;
  int profileStatus;
  String uniqueId;
  String failReason;

  RequestCreateRetailProfileSuccess({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    required this.uniqueId,
    this.profileEmail = "",
    this.chairpersonPin = 0,
    this.profileRefNum = 0,
    this.participantPin = 0,
    this.accountType = AppConstants.retailPrepaid,
    this.allowStatusISD = 1,
    this.profileSize = 4,
    this.facilityElement = 0,
    this.defaultProfileFlag = 2,
    this.profileStatus = 1,
    this.failReason = "",
  });

  static List<String> errorMessage = [
    'Maximum LImit is reached',
    'Already Retail is available',
    'Profile Name already exists.',
  ];

  factory RequestCreateRetailProfileSuccess.fromJson(
      Map<String, dynamic> json) {
    if (json['reactionType'] == 183) {
      return RequestCreateRetailProfileSuccess(
        status: false,
        reactionType: json['reactionType'],
        regNum: 0,
        uniqueId: json["uniqueId"],
        failReason: errorMessage[json["failureReason"]],
      );
    }
    return RequestCreateRetailProfileSuccess(
      status: true,
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestProfileOverDueSuccess extends RecievedMessage {
  int profileRefNo;
  int overdueAmountInPaise;
  String uniqueId;

  RequestProfileOverDueSuccess({
    super.status = false,
    required super.reactionType,
    required this.profileRefNo,
    this.overdueAmountInPaise = 0,
    required this.uniqueId,
  });

  factory RequestProfileOverDueSuccess.fromJson(Map<String, dynamic> json) {
    if (json['actionStatus'] == 2) {
      return RequestProfileOverDueSuccess(
        status: false,
        reactionType: json['reactionType'],
        profileRefNo: json['profileRefNo'],
        uniqueId: json["uniqueId"],
      );
    }
    return RequestProfileOverDueSuccess(
      status: true,
      reactionType: json['reactionType'],
      profileRefNo: json['profileRefNo'],
      uniqueId: json['uniqueId'],
      overdueAmountInPaise: json["overdueAmountInPaise"],
    );
  }
}

class RequestProfileStatusCheckSuccess extends RecievedMessage {
  // late String failReason;
  int profileRefNo;
  int actionStatus;

  String uniqueId;

  static List<String> errorMessage = [
    'Profile Not Exist',
    'Profile Disabled (NOT IN USE)',
  ];

  RequestProfileStatusCheckSuccess({
    super.status = false,
    required super.reactionType,
    // this.failReason = "",
    required this.profileRefNo,
    this.actionStatus = 0,
    required this.uniqueId,
  });

  factory RequestProfileStatusCheckSuccess.fromJson(Map<String, dynamic> json) {
    if (json['actionStatus'] == 2) {
      // final index = json['failureReason'] - 1;

      return RequestProfileStatusCheckSuccess(
        status: false,
        reactionType: json['reactionType'],
        // failReason: errorMessage[index],
        profileRefNo: json['profileRefNo'],
        uniqueId: json["uniqueId"],
      );
    }
    return RequestProfileStatusCheckSuccess(
      status: true,
      reactionType: json['reactionType'],
      profileRefNo: json['profileRefNo'],
      uniqueId: json['uniqueId'],
    );
  }
}

class AddProfileSuccess extends RecievedMessage {
  int regNum;
  String profileEmail;
  int chairpersonPin;
  int profileRefNum;
  int participantPin;
  int accountType;
  int allowStatusISD;
  int profileSize;
  int facilityElement;
  int defaultProfileFlag;
  int profileStatus;
  String uniqueId;
  String failReason;

  AddProfileSuccess({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    required this.uniqueId,
    this.profileEmail = "",
    this.chairpersonPin = 7284487,
    this.profileRefNum = 4,
    this.participantPin = 5643592,
    this.accountType = 1,
    this.allowStatusISD = 1,
    this.profileSize = 100,
    this.facilityElement = 3,
    this.defaultProfileFlag = 2,
    this.profileStatus = 1,
    this.failReason = "",
  });

  static List<String> errorMessage = [
    'Profile already exists.',
    'Your profile is disabled.',
    'Pin is Hacked',
    'Profile Already Exists',
    'PIN does not match with Email ID',
  ];

  factory AddProfileSuccess.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 111) {
      return AddProfileSuccess(
        status: false,
        reactionType: json['reactionType'],
        regNum: 0,
        uniqueId: json["uniqueId"],
        failReason: errorMessage[json["reason"]],
      );
    }
    return AddProfileSuccess(
      status: true,
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      uniqueId: json['uniqueId'],
    );
  }
}

class DeleteProfileSuccess extends RecievedMessage {
  int profileRefNum;
  String uniqueId;
  String failureReason;

  DeleteProfileSuccess({
    super.status = false,
    required super.reactionType,
    required this.uniqueId,
    this.profileRefNum = 0,
    this.failureReason = "",
  });

  static List<String> errorMessage = [
    'Profile does not exists',
    'Profile is Retail Type',
  ];

  factory DeleteProfileSuccess.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 130) {
      return DeleteProfileSuccess(
        status: false,
        reactionType: json['reactionType'],
        uniqueId: "",
        failureReason: errorMessage[json["failReason"] + 1],
      );
    }
    return DeleteProfileSuccess(
      status: true,
      reactionType: json['reactionType'],
      uniqueId: json['uniqueId'],
    );
  }
}

class EditProfileSuccess extends RecievedMessage {
  int profileRefNum;
  String uniqueId;
  int profileEditStatus;
  String failureReason;

  EditProfileSuccess({
    super.status = false,
    required super.reactionType,
    required this.uniqueId,
    this.profileRefNum = 4,
    this.failureReason = "",
    this.profileEditStatus = 1,
  });

  static List<String> errorMessage = [
    '',
    'Profile Not Exist',
    'Name Already Exist',
  ];

  factory EditProfileSuccess.fromJson(Map<String, dynamic> json) {
    if (json['profileEditStatus'] == 2) {
      return EditProfileSuccess(
        status: false,
        reactionType: json['reactionType'],
        uniqueId: "",
        failureReason: errorMessage[json['failureReason']],
        profileEditStatus: json["profileEditStatus"],
      );
    }
    return EditProfileSuccess(
      status: true,
      reactionType: json['reactionType'],
      uniqueId: json['uniqueId'],
      profileEditStatus: json["profileEditStatus"],
    );
  }
}

class RestoreGroupsSuccess extends RecievedMessage {
  int totalCountOfGroups;
  late String failReason;
  int groupCountHere;
  int groupType;
  List<Group> groups;
  String uniqueId;

  static List<String> errorMessage = [
    '',
  ];

  RestoreGroupsSuccess({
    super.status = false,
    required super.reactionType,
    required this.totalCountOfGroups,
    this.failReason = "",
    required this.groupCountHere,
    required this.groupType,
    required this.groups,
    required this.uniqueId,
  });

  factory RestoreGroupsSuccess.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return RestoreGroupsSuccess(
        status: false,
        reactionType: json['reactionType'],
        totalCountOfGroups: -1,
        failReason: errorMessage[json['failReason']],
        groupCountHere: 0,
        groupType: 0,
        groups: [],
        uniqueId: "",
      );
    }
    return RestoreGroupsSuccess(
      status: true,
      reactionType: json['reactionType'],
      totalCountOfGroups: json['totalCountOfGroups'],
      groupCountHere: json['groupCountHere'],
      groupType: json['groupType'],
      groups: (json['groups'] as List)
          .map((person) => Group.fromJson(person))
          .toList(),
      uniqueId: json['uniqueId'],
    );
  }
}

class FetchGroupMembersResponse extends RecievedMessage {
  int totalGroupMembers;
  int countOfMembers;
  int msgNumber;
  int groupId;
  List<GroupMembers> members;
  String uniqueId;

  FetchGroupMembersResponse({
    super.status = false,
    required super.reactionType,
    this.totalGroupMembers = 0,
    this.countOfMembers = 0,
    this.msgNumber = 1,
    required this.groupId,
    this.members = const [],
    required this.uniqueId,
  });

  factory FetchGroupMembersResponse.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return FetchGroupMembersResponse(
        status: false,
        reactionType: json['reactionType'],
        groupId: json['groupId'],
        uniqueId: "",
      );
    }
    return FetchGroupMembersResponse(
        status: true,
        reactionType: json['reactionType'],
        totalGroupMembers: json['totalGroupMembers'],
        countOfMembers: json['countOfMembers'],
        msgNumber: json['msgNumber'],
        groupId: json['groupId'],
        uniqueId: json['uniqueId'],
        members: (json['members'] as List)
            .map(
              (e) => GroupMembers(
                memberName: e['name'] ?? "",
                memberTelephone: e['phone'] ?? "",
                memberEmail: e['email'] ?? "",
              ),
            )
            .toList());
  }
}

class CreateGroupResponse extends RecievedMessage {
  int regNum;
  String uniqueId;
  String groupName;

  CreateGroupResponse({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    required this.groupName,
    required this.uniqueId,
  });

  factory CreateGroupResponse.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return CreateGroupResponse(
        status: false,
        reactionType: json['reactionType'],
        groupName: "",
        regNum: 0,
        uniqueId: "",
      );
    }
    return CreateGroupResponse(
      status: true,
      reactionType: json['reactionType'],
      groupName: json['groupName'],
      regNum: json['regNum'],
      uniqueId: json['uniqueId'],
    );
  }
}

class DeleteGroupResponse extends RecievedMessage {
  int regNum;
  String uniqueId;

  DeleteGroupResponse({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    required this.uniqueId,
  });

  factory DeleteGroupResponse.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return DeleteGroupResponse(
        status: false,
        reactionType: json['reactionType'],
        regNum: 0,
        uniqueId: "",
      );
    }
    return DeleteGroupResponse(
      status: true,
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      uniqueId: json['uniqueId'],
    );
  }
}

class MakeGroupFavoriteResponse extends RecievedMessage {
  int regNum;
  String uniqueId;
  String groupName;

  MakeGroupFavoriteResponse({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    required this.uniqueId,
    required this.groupName,
  });

  factory MakeGroupFavoriteResponse.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return MakeGroupFavoriteResponse(
        status: false,
        reactionType: json['reactionType'],
        regNum: 0,
        uniqueId: "",
        groupName: "",
      );
    }
    return MakeGroupFavoriteResponse(
      status: true,
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      uniqueId: json['uniqueId'],
      groupName: json['groupName'],
    );
  }
}

class EditGroupMembersResponse extends RecievedMessage {
  int regNum;
  String uniqueId;
  String groupName;

  EditGroupMembersResponse({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    required this.uniqueId,
    required this.groupName,
  });

  factory EditGroupMembersResponse.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return EditGroupMembersResponse(
          status: false,
          reactionType: json['reactionType'],
          regNum: 0,
          uniqueId: "",
          groupName: "");
    }
    return EditGroupMembersResponse(
      status: true,
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      uniqueId: json['uniqueId'],
      groupName: json['groupName'],
    );
  }
}

class VerificationResponseForAddNewPhoneNumber extends RecievedMessage {
  int regNum;
  String uniqueId;
  int responseStatus;

  VerificationResponseForAddNewPhoneNumber({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    required this.uniqueId,
    required this.responseStatus,
  });

  factory VerificationResponseForAddNewPhoneNumber.fromJson(
      Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return VerificationResponseForAddNewPhoneNumber(
          status: false,
          reactionType: json['reactionType'],
          regNum: 0,
          uniqueId: "",
          responseStatus: 0);
    }
    return VerificationResponseForAddNewPhoneNumber(
      status: true,
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      uniqueId: json['uniqueId'],
      responseStatus: json['status'],
    );
  }
}

class UserPhoneNumberListResponse extends RecievedMessage {
  String uniqueId;
  int totalPhoneCount;
  int countHere;
  int unused;
  List<dynamic> phones;

  UserPhoneNumberListResponse({
    super.status = false,
    required super.reactionType,
    required this.uniqueId,
    required this.totalPhoneCount,
    required this.countHere,
    required this.unused,
    required this.phones,
  });

  factory UserPhoneNumberListResponse.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return UserPhoneNumberListResponse(
          status: false,
          reactionType: json['reactionType'],
          uniqueId: "",
          totalPhoneCount: 0,
          countHere: 0,
          unused: 0,
          phones: []);
    }
    return UserPhoneNumberListResponse(
      status: true,
      reactionType: json['reactionType'],
      uniqueId: json['uniqueId'],
      totalPhoneCount: json['totalPhoneCount'],
      countHere: json['countHere'],
      unused: json['unused'],
      phones: json['phones'],
    );
  }
}

class ResponseAddEmailSuccess extends RecievedMessage {
  int actionStatus;
  String uniqueId;

  static List<String> errorMessage = [
    'Profile Not Exist',
    'Profile Disabled (NOT IN USE)',
  ];

  ResponseAddEmailSuccess({
    super.status = false,
    required super.reactionType,
    this.actionStatus = 0,
    required this.uniqueId,
  });

  factory ResponseAddEmailSuccess.fromJson(Map<String, dynamic> json) {
    if (json['status'] == 0) {
      return ResponseAddEmailSuccess(
        status: false,
        reactionType: json['reactionType'],
        uniqueId: json["uniqueId"],
      );
    }
    return ResponseAddEmailSuccess(
      status: true,
      reactionType: json['reactionType'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestOTPEmailSuccess extends RecievedMessage {
  int actionStatus;
  String uniqueId;
  late String failReason;

  static List<String> errorMessage = [
    "Response Failure",
    "Response Success",
    "Invalid OTP ",
    "Verification Attempt Exceeded",
    "Resend Attempt Exceeded",
    "OTP Timed Out",
  ];

  RequestOTPEmailSuccess({
    super.status = false,
    required super.reactionType,
    this.actionStatus = 0,
    required this.uniqueId,
    this.failReason = "",
  });

  factory RequestOTPEmailSuccess.fromJson(Map<String, dynamic> json) {
    if (json['status'] != 1) {
      var index = json['status'];
      return RequestOTPEmailSuccess(
          status: false,
          reactionType: json['reactionType'],
          uniqueId: json["uniqueId"],
          failReason: errorMessage[index]);
    }
    return RequestOTPEmailSuccess(
      status: true,
      reactionType: json['reactionType'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RestoreEmailsSuccess extends RecievedMessage {
  int totalEmailIdCount;
  late String failReason;
  int countHere;
  List<dynamic> emails;
  String uniqueId;

  static List<String> errorMessage = [
    '',
  ];

  RestoreEmailsSuccess({
    super.status = false,
    required super.reactionType,
    required this.totalEmailIdCount,
    this.failReason = "",
    required this.countHere,
    required this.emails,
    required this.uniqueId,
  });

  factory RestoreEmailsSuccess.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 0) {
      return RestoreEmailsSuccess(
        status: false,
        reactionType: json['reactionType'],
        totalEmailIdCount: -1,
        // failReason: errorMessage[json['failReason']],
        countHere: 0,
        emails: [],
        uniqueId: "",
      );
    }
    return RestoreEmailsSuccess(
      status: true,
      reactionType: json['reactionType'],
      totalEmailIdCount: json['totalEmailIdCount'],
      countHere: json['countHere'],
      emails: json['emails'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestAccountDetailsSuccess extends RecievedMessage {
  int profileReferenceNumber;
  late String failReason;
  int conferenceReferenceNumber;
  int accountID;
  int accountType;
  String uniqueId;

  static List<String> errorMessage = [
    '',
  ];

  RequestAccountDetailsSuccess({
    super.status = false,
    required super.reactionType,
    this.failReason = "",
    required this.profileReferenceNumber,
    required this.conferenceReferenceNumber,
    required this.accountID,
    required this.accountType,
    required this.uniqueId,
  });

  factory RequestAccountDetailsSuccess.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 0) {
      return RequestAccountDetailsSuccess(
        status: false,
        reactionType: json['reactionType'],
        // failReason: errorMessage[json['failReason']],
        profileReferenceNumber: -1,
        conferenceReferenceNumber: 0,
        accountID: 0,
        accountType: 0,
        uniqueId: "",
      );
    }
    return RequestAccountDetailsSuccess(
      status: true,
      reactionType: json['reactionType'],
      profileReferenceNumber: json['profileReferenceNumber'],
      conferenceReferenceNumber: json['conferenceReferenceNumber'],
      accountID: json['accountID'],
      accountType: json['accountType'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestProfilePlanDetailsSuccess extends RecievedMessage {
  late String failReason;
  int accountID;
  int basePlanID;
  String uniqueId;
  String basePlanName;
  String balanceInformation;
  String validityDateInformation;
  int basePlanDurationInt;
  String basePlanDurationDisplay;
  int addOnPlanDurationCount;

  static List<String> errorMessage = [
    '',
  ];

  RequestProfilePlanDetailsSuccess({
    super.status = false,
    required super.reactionType,
    this.failReason = "",
    required this.basePlanName,
    required this.balanceInformation,
    required this.validityDateInformation,
    required this.basePlanDurationInt,
    required this.basePlanDurationDisplay,
    required this.addOnPlanDurationCount,
    required this.accountID,
    required this.basePlanID,
    required this.uniqueId,
  });

  factory RequestProfilePlanDetailsSuccess.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 0) {
      return RequestProfilePlanDetailsSuccess(
        status: false,
        reactionType: json['reactionType'],
        // failReason: errorMessage[json['failReason']],
        basePlanName: "",
        balanceInformation: "",
        validityDateInformation: "",
        basePlanDurationInt: 0,
        basePlanDurationDisplay: "",
        addOnPlanDurationCount: 0,
        accountID: 0,
        basePlanID: 0,
        uniqueId: "",
      );
    }
    return RequestProfilePlanDetailsSuccess(
      status: true,
      reactionType: json['reactionType'],
      basePlanName: json['basePlanName'],
      balanceInformation: json['balanceInformation'],
      validityDateInformation: json['validityDateInformation'],
      basePlanDurationInt: json['basePlanDurationInt'],
      basePlanDurationDisplay: json['basePlanDurationDisplay'],
      addOnPlanDurationCount: json['addOnPlanDurationCount'],
      accountID: json['accountID'],
      basePlanID: json['basePlanID'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestProfileBasePlanDetailsSuccess extends RecievedMessage {
  late String failReason;
  int accountID;
  int basePlanID;
  String uniqueId;
  String planName;
  String planDurationDisplay;
  int jobID;
  String paymentAmountDisplay;
  String talkTimeDisplay;
  int rpm;
  int planSize;
  int paymentAmount;
  int suggestedPlanFlag;
  int planPriority;
  int planType;

  static List<String> errorMessage = [
    '',
  ];

  RequestProfileBasePlanDetailsSuccess({
    super.status = false,
    required super.reactionType,
    this.failReason = "",
    required this.planName,
    required this.planDurationDisplay,
    required this.jobID,
    required this.paymentAmountDisplay,
    required this.talkTimeDisplay,
    required this.planSize,
    required this.rpm,
    required this.accountID,
    required this.basePlanID,
    required this.paymentAmount,
    required this.planPriority,
    required this.planType,
    required this.suggestedPlanFlag,
    required this.uniqueId,
  });

  factory RequestProfileBasePlanDetailsSuccess.fromJson(
      Map<String, dynamic> json) {
    if (json['reactionType'] == 0) {
      return RequestProfileBasePlanDetailsSuccess(
        status: false,
        reactionType: json['reactionType'],
        // failReason: errorMessage[json['failReason']],
        planName: "",
        jobID: 0,
        paymentAmountDisplay: "",
        talkTimeDisplay: "",
        rpm: 0,
        planDurationDisplay: "",

        planSize: 0,
        accountID: 0,
        basePlanID: 0,
        paymentAmount: 0,
        planPriority: 0,
        planType: 0,
        suggestedPlanFlag: 0,
        uniqueId: "",
      );
    }
    return RequestProfileBasePlanDetailsSuccess(
      status: true,
      reactionType: json['reactionType'],
      planName: json['planName'],
      jobID: json['jobID'],
      paymentAmountDisplay: json['paymentAmountDisplay'],
      talkTimeDisplay: json['talkTimeDisplay'],
      rpm: json['rpm'],
      planDurationDisplay: json['planDurationDisplay'],
      planSize: json['planSize'],
      accountID: json['accountID'],
      basePlanID: json['basePlanID'],
      paymentAmount: json['paymentAmount'],
      planPriority: json['planPriority'],
      planType: json['planType'],
      suggestedPlanFlag: json['suggestedPlanFlag'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestProfileAddOnPlanDetailsSuccess extends RecievedMessage {
  late String failReason;
  int accountID;
  int basePlanID;
  String uniqueId;
  String planName;
  String planDescription;
  String planDurationDisplay;
  int jobID;
  String paymentAmountDisplay;
  String talkTimeDisplay;
  int rpm;
  int maximumConferees;
  int paymentAmountInPaise;
  int addonPlanID;
  int planDurationInDays;

  static List<String> errorMessage = [
    '',
  ];

  RequestProfileAddOnPlanDetailsSuccess({
    super.status = false,
    required super.reactionType,
    this.failReason = "",
    required this.planName,
    required this.planDescription,
    required this.planDurationDisplay,
    required this.jobID,
    required this.paymentAmountDisplay,
    required this.talkTimeDisplay,
    required this.maximumConferees,
    required this.rpm,
    required this.accountID,
    required this.basePlanID,
    required this.addonPlanID,
    required this.paymentAmountInPaise,
    required this.planDurationInDays,
    required this.uniqueId,
  });

  factory RequestProfileAddOnPlanDetailsSuccess.fromJson(
      Map<String, dynamic> json) {
    if (json['reactionType'] == 0) {
      return RequestProfileAddOnPlanDetailsSuccess(
        status: false,
        reactionType: json['reactionType'],
        // failReason: errorMessage[json['failReason']],
        planName: "",
        planDescription: "",
        jobID: 0,
        paymentAmountDisplay: "",
        talkTimeDisplay: "",
        rpm: 0,
        planDurationDisplay: "",
        paymentAmountInPaise: 0,
        planDurationInDays: 0,
        maximumConferees: 0,
        addonPlanID: 0,
        accountID: 0,
        basePlanID: 0,
        uniqueId: "",
      );
    }
    return RequestProfileAddOnPlanDetailsSuccess(
      status: true,
      reactionType: json['reactionType'],
      planName: json['planName'],
      planDescription: json['planDescription'],
      jobID: json['jobID'],
      paymentAmountDisplay: json['paymentAmountDisplay'],
      talkTimeDisplay: json['talkTimeDisplay'],
      rpm: json['rpm'],
      planDurationDisplay: json['planDurationDisplay'],
      maximumConferees: json['maximumConferees'],
      accountID: json['accountID'],
      basePlanID: json['basePlanID'],
      addonPlanID: json['addonPlanID'],
      paymentAmountInPaise: json['paymentAmountInPaise'],
      planDurationInDays: json['planDurationInDays'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestProfilePaymentHistorySuccess extends RecievedMessage {
  int actionStatus;
  int paymentHistoryCount;
  int conferenceReferenceNumber;
  String uniqueId;
  List paymentHistory;
  late String failReason;

  RequestProfilePaymentHistorySuccess({
    super.status = false,
    required super.reactionType,
    this.actionStatus = 0,
    this.paymentHistoryCount = 0,
    this.conferenceReferenceNumber = 0,
    this.paymentHistory = const [],
    required this.uniqueId,
    this.failReason = "",
  });

  factory RequestProfilePaymentHistorySuccess.fromJson(
      Map<String, dynamic> json) {
    if (json['paymentStatus'] == 2) {
      return RequestProfilePaymentHistorySuccess(
        status: false,
        reactionType: json['reactionType'],
        conferenceReferenceNumber: json['conferenceReferenceNumber'],
        paymentHistoryCount: json['paymentHistoryCount'],
        paymentHistory: json['paymentHistory'],
        uniqueId: json["uniqueId"],
      );
    }
    return RequestProfilePaymentHistorySuccess(
      status: true,
      reactionType: json['reactionType'],
      conferenceReferenceNumber: json['conferenceReferenceNumber'],
      paymentHistoryCount: json['paymentHistoryCount'],
      paymentHistory: json['paymentHistory'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestAppRequestToSendEnterprisePlanToMcSupportSuccess
    extends RecievedMessage {
  String uniqueId;

  RequestAppRequestToSendEnterprisePlanToMcSupportSuccess({
    super.status = false,
    required super.reactionType,
    required this.uniqueId,
  });

  factory RequestAppRequestToSendEnterprisePlanToMcSupportSuccess.fromJson(
      Map<String, dynamic> json) {
    if (json['paymentStatus'] == 2) {
      return RequestAppRequestToSendEnterprisePlanToMcSupportSuccess(
        status: false,
        reactionType: json['reactionType'],
        uniqueId: json["uniqueId"],
      );
    }
    return RequestAppRequestToSendEnterprisePlanToMcSupportSuccess(
      status: true,
      reactionType: json['reactionType'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestSwitchPlanSuccess extends RecievedMessage {
  int profileRefNo;
  int overdueAmountInPaise;
  String uniqueId;

  RequestSwitchPlanSuccess({
    super.status = false,
    required super.reactionType,
    required this.profileRefNo,
    this.overdueAmountInPaise = 0,
    required this.uniqueId,
  });

  factory RequestSwitchPlanSuccess.fromJson(Map<String, dynamic> json) {
    if (json['actionStatus'] == 2) {
      return RequestSwitchPlanSuccess(
        status: false,
        reactionType: json['reactionType'],
        profileRefNo: json['profileRefNo'],
        uniqueId: json["uniqueId"],
      );
    }
    return RequestSwitchPlanSuccess(
      status: true,
      reactionType: json['reactionType'],
      profileRefNo: json['profileRefNo'],
      uniqueId: json['uniqueId'],
      overdueAmountInPaise: json["overdueAmountInPaise"],
    );
  }
}

class RequestCurrentPlanActiveStatusSuccess extends RecievedMessage {
  int requestType;
  int responseAllowedStatus;
  int reasonCode;
  String uniqueId;
  String failReason;

  RequestCurrentPlanActiveStatusSuccess({
    super.status = false,
    required super.reactionType,
    required this.requestType,
    this.responseAllowedStatus = 0,
    this.reasonCode = 0,
    this.failReason = "",
    required this.uniqueId,
  });

  static List<String> errorMessage = [
    'Base Plan Not Active',
    'Not Allowed for this plan.',
  ];

  factory RequestCurrentPlanActiveStatusSuccess.fromJson(
      Map<String, dynamic> json) {
    if (json['responseAllowedStatus'] == 2) {
      return RequestCurrentPlanActiveStatusSuccess(
        status: false,
        reactionType: json['reactionType'],
        requestType: json['requestType'],
        uniqueId: json["uniqueId"],
        failReason: errorMessage[json['reasonCode'] - 1],
      );
    }
    return RequestCurrentPlanActiveStatusSuccess(
      status: true,
      reactionType: json['reactionType'],
      requestType: json['requestType'],
      uniqueId: json['uniqueId'],
      reasonCode: json["reasonCode"],
    );
  }
}

class RequestActiveStatusSuccess extends RecievedMessage {
  int profileReferenceNumber;
  int registeredNumber;
  int responseAllowedStatus;
  String uniqueId;

  RequestActiveStatusSuccess({
    super.status = false,
    required super.reactionType,
    required this.profileReferenceNumber,
    required this.registeredNumber,
    required this.responseAllowedStatus,
    required this.uniqueId,
  });

  factory RequestActiveStatusSuccess.fromJson(Map<String, dynamic> json) {
    return RequestActiveStatusSuccess(
      status: true,
      reactionType: json['reactionType'],
      profileReferenceNumber: json['profileReferenceNumber'],
      registeredNumber: json['registeredNumber'],
      responseAllowedStatus: json['responseAllowedStatus'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestPrimaryEmailCheckSuccess extends RecievedMessage {
  int socialNetwFlag;
  String requestedEmailId;
  int primaryRegFlag;
  int regNum;
  String regPhone;
  String uniqueId;

  RequestPrimaryEmailCheckSuccess({
    super.status = false,
    required super.reactionType,
    required this.socialNetwFlag,
    required this.requestedEmailId,
    this.primaryRegFlag = 0,
    this.regNum = 0,
    this.regPhone = "",
    required this.uniqueId,
  });

  factory RequestPrimaryEmailCheckSuccess.fromJson(Map<String, dynamic> json) {
    if (json['actionStatus'] == 2) {
      return RequestPrimaryEmailCheckSuccess(
        status: false,
        reactionType: json['reactionType'],
        socialNetwFlag: json['socialNetwFlag'],
        requestedEmailId: json['requestedEmailId'],
        regNum: json['regNum'],
        regPhone: json['regPhone'],
        uniqueId: json["uniqueId"],
      );
    }
    return RequestPrimaryEmailCheckSuccess(
      status: true,
      reactionType: json['reactionType'],
      socialNetwFlag: json['socialNetwFlag'],
      requestedEmailId: json['requestedEmailId'],
      primaryRegFlag: json["primaryRegFlag"],
      regNum: json["regNum"],
      regPhone: json["regPhone"],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestTopUpSuccess extends RecievedMessage {
  String uniqueId;

  RequestTopUpSuccess({
    super.status = false,
    required super.reactionType,
    required this.uniqueId,
  });

  factory RequestTopUpSuccess.fromJson(Map<String, dynamic> json) {
    if (json['paymentStatus'] == 2) {
      return RequestTopUpSuccess(
        status: false,
        reactionType: json['reactionType'],
        uniqueId: json["uniqueId"],
      );
    }
    return RequestTopUpSuccess(
      status: true,
      reactionType: json['reactionType'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestRetailPaymentOptionSuccess extends RecievedMessage {
  String uniqueId;
  int retailPaymentOption;

  RequestRetailPaymentOptionSuccess({
    super.status = false,
    required super.reactionType,
    required this.retailPaymentOption,
    required this.uniqueId,
  });

  factory RequestRetailPaymentOptionSuccess.fromJson(
      Map<String, dynamic> json) {
    if (json['paymentStatus'] == 2) {
      return RequestRetailPaymentOptionSuccess(
        status: false,
        reactionType: json['reactionType'],
        uniqueId: json["uniqueId"],
        retailPaymentOption: 0,
      );
    }
    return RequestRetailPaymentOptionSuccess(
      status: true,
      reactionType: json['reactionType'],
      uniqueId: json['uniqueId'],
      retailPaymentOption: json["retailPaymentOption"],
    );
  }
}

class RequestForRegistrationStatusSuccess extends RecievedMessage {
  String uniqueId;
  String phoneNumber;
  String emailId;
  int regNum;

  RequestForRegistrationStatusSuccess({
    super.status = false,
    required super.reactionType,
    required this.uniqueId,
    required this.phoneNumber,
    required this.emailId,
    required this.regNum,
  });

  factory RequestForRegistrationStatusSuccess.fromJson(
      Map<String, dynamic> json) {
    if (json['paymentStatus'] == 2) {
      return RequestForRegistrationStatusSuccess(
        status: false,
        reactionType: json['reactionType'],
        phoneNumber: json["phoneNumber"],
        emailId: json["emailId"],
        regNum: json["regNum"],
        uniqueId: json["uniqueId"],
      );
    }
    return RequestForRegistrationStatusSuccess(
      status: true,
      reactionType: json['reactionType'],
      phoneNumber: json["phoneNumber"],
      emailId: json["emailId"],
      regNum: json["regNum"],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestUserResetRegistrationSuccess extends RecievedMessage {
  String uniqueId;

  RequestUserResetRegistrationSuccess({
    super.status = false,
    required super.reactionType,
    required this.uniqueId,
  });

  factory RequestUserResetRegistrationSuccess.fromJson(
      Map<String, dynamic> json) {
    if (json['paymentStatus'] == 2) {
      return RequestUserResetRegistrationSuccess(
        status: false,
        reactionType: json['reactionType'],
        uniqueId: json["uniqueId"],
      );
    }
    return RequestUserResetRegistrationSuccess(
      status: true,
      reactionType: json['reactionType'],
      uniqueId: json['uniqueId'],
    );
  }
}

class RequestScheduleEstimateSuccess extends RecievedMessage {
  String uniqueId;
  int estimateAmount;

  RequestScheduleEstimateSuccess({
    super.status = false,
    required super.reactionType,
    required this.uniqueId,
    required this.estimateAmount,
  });

  factory RequestScheduleEstimateSuccess.fromJson(Map<String, dynamic> json) {
    if (json['paymentStatus'] == 2) {
      return RequestScheduleEstimateSuccess(
        status: false,
        reactionType: json['reactionType'],
        uniqueId: json["uniqueId"],
        estimateAmount: 0,
      );
    }
    return RequestScheduleEstimateSuccess(
      status: true,
      reactionType: json['reactionType'],
      uniqueId: json['uniqueId'],
      estimateAmount: json['estimationAmount'],
    );
  }
}

class ResponseRequestFCMSuccess extends RecievedMessage {
  String uniqueId;
  int estimateAmount;

  ResponseRequestFCMSuccess({
    super.status = false,
    required super.reactionType,
    required this.uniqueId,
    required this.estimateAmount,
  });

  factory ResponseRequestFCMSuccess.fromJson(Map<String, dynamic> json) {
    return ResponseRequestFCMSuccess(
      status: true,
      reactionType: json['reactionType'],
      uniqueId: json['uniqueId'],
      estimateAmount: json['estimationAmount'],
    );
  }
}

class ResponseRequestHealthSuccess extends RecievedMessage {
  String statusRes;
  String message;

  ResponseRequestHealthSuccess({
    super.status = false,
    required super.reactionType,
    required this.message,
    required this.statusRes,
  });

  factory ResponseRequestHealthSuccess.fromJson(Map<String, dynamic> json) {
    return ResponseRequestHealthSuccess(
      status: true,
      reactionType: json['reactionType'],
      statusRes: json['status'],
      message: json['message'],
    );
  }
}

class ResponseEndCallSuccess extends RecievedMessage {
  ResponseEndCallSuccess({
    super.status = false,
    required super.reactionType,
  });

  factory ResponseEndCallSuccess.fromJson(Map<String, dynamic> json) {
    final currentContext = navigatorKey.currentContext;

    final callsController =
        Provider.of<CallsController>(currentContext!, listen: false);
    callsController.clearAllCallsHistory();
    callsController.callHistoryRestore();
    callsController.scheduleCallRestore(
        DateFormat('yyyy-MM-dd').format(DateTime.now()), 0);
    return ResponseEndCallSuccess(
      status: true,
      reactionType: json['reactionType'],
    );
  }
}
