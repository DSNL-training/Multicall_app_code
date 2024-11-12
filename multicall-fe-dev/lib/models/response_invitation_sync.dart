import 'package:multicall_mobile/models/response.dart';

class ResponseInvitationSync extends RecievedMessage {
  int regNum;
  int profileRefNo;
  int scheduleRefNo;
  String accessCode;
  int partyPin;
  int leaderKey;
  int callType;
  String chairpersonName;
  String chairpersonNumber;
  String confName;
  String scheduleDateTime;
  int confDuration;
  int repeatType;
  String repeatEndDate;
  int lastScheduleRefNo;
  int totalCalls;
  int inviteStatus;
  int recurrentId;
  String uniqueId;

  ResponseInvitationSync({
    required super.reactionType,
    required super.status,
    required this.regNum,
    required this.profileRefNo,
    required this.scheduleRefNo,
    required this.accessCode,
    required this.partyPin,
    required this.leaderKey,
    required this.callType,
    required this.chairpersonName,
    required this.chairpersonNumber,
    required this.confName,
    required this.scheduleDateTime,
    required this.confDuration,
    required this.repeatType,
    required this.repeatEndDate,
    required this.lastScheduleRefNo,
    required this.totalCalls,
    required this.inviteStatus,
    required this.recurrentId,
    required this.uniqueId,
  });

  factory ResponseInvitationSync.fromJson(Map<String, dynamic> json) {
    return ResponseInvitationSync(
      reactionType: json['reactionType'],
      status: true, // Assuming status is true if the response is received successfully
      regNum: json['regNum'],
      profileRefNo: json['profileRefNo'],
      scheduleRefNo: json['scheduleRefNo'],
      accessCode: json['accessCode'],
      partyPin: json['partyPin'],
      leaderKey: json['leaderKey'],
      callType: json['callType'],
      chairpersonName: json['chairpersonName'],
      chairpersonNumber: json['chairpersonNumber'],
      confName: json['confName'],
      scheduleDateTime: json['scheduleDateTime'],
      confDuration: json['confDuration'],
      repeatType: json['repeatType'],
      repeatEndDate: json['repeatEndDate'],
      lastScheduleRefNo: json['lastScheduleRefNo'],
      totalCalls: json['totalCalls'],
      inviteStatus: json['inviteStatus'],
      recurrentId: json['recurrentId'],
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': status,
      'regNum': regNum,
      'profileRefNo': profileRefNo,
      'scheduleRefNo': scheduleRefNo,
      'accessCode': accessCode,
      'partyPin': partyPin,
      'leaderKey': leaderKey,
      'callType': callType,
      'chairpersonName': chairpersonName,
      'chairpersonNumber': chairpersonNumber,
      'confName': confName,
      'scheduleDateTime': scheduleDateTime,
      'confDuration': confDuration,
      'repeatType': repeatType,
      'repeatEndDate': repeatEndDate,
      'lastScheduleRefNo': lastScheduleRefNo,
      'totalCalls': totalCalls,
      'inviteStatus': inviteStatus,
      'recurrentId': recurrentId,
      'uniqueId': uniqueId,
    };
  }
}
