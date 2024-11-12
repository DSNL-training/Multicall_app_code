import 'package:multicall_mobile/models/response.dart';

class ResponseScheduleMembers extends RecievedMessage {
  final int regNum;
  final int profileRefNo;
  final int scheduleRefNo;
  final int failureReason;
  final int accessCode;
  final int partyPin;
  final int leaderKey;
  final int recurrentID;
  final int appGuid;
  final String scheduleStartDateTime;
  final int firstScheduleRefNo;
  final int lastScheduleRefNo;

  ResponseScheduleMembers({
    required super.reactionType,
    required super.status,
    required this.regNum,
    required this.profileRefNo,
    required this.scheduleRefNo,
    required this.failureReason,
    required this.accessCode,
    required this.partyPin,
    required this.leaderKey,
    required this.recurrentID,
    required this.appGuid,
    required this.scheduleStartDateTime,
    required this.firstScheduleRefNo,
    required this.lastScheduleRefNo,
  });

  factory ResponseScheduleMembers.fromJson(Map<String, dynamic> json) {
    return ResponseScheduleMembers(
      reactionType: json['reactionType'],
      status: json['status'] ?? true,
      regNum: json['regNum'],
      profileRefNo: json['profileRefNo'],
      scheduleRefNo: json['scheduleRefNo'],
      failureReason: json['failureReason'],
      accessCode: json['accessCode'],
      partyPin: json['partyPin'],
      leaderKey: json['leaderKey'],
      recurrentID: json['recurrentID'],
      appGuid: json['appGuid'],
      scheduleStartDateTime: json['scheduleStartDateTime'],
      firstScheduleRefNo: json['firstScheduleRefNo'],
      lastScheduleRefNo: json['lastScheduleRefNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': status,
      'regNum': regNum,
      'profileRefNo': profileRefNo,
      'scheduleRefNo': scheduleRefNo,
      'failureReason': failureReason,
      'accessCode': accessCode,
      'partyPin': partyPin,
      'leaderKey': leaderKey,
      'recurrentID': recurrentID,
      'appGuid': appGuid,
      'scheduleStartDateTime': scheduleStartDateTime,
      'firstScheduleRefNo': firstScheduleRefNo,
      'lastScheduleRefNo': lastScheduleRefNo,
    };
  }
}
