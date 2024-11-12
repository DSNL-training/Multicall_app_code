import 'package:multicall_mobile/models/response.dart';

class ResponseMccmDeleteSchedule extends RecievedMessage {
  final int regNum;
  final int profileRefNo;
  final int scheduleRefNo;
  final int reason;
  final String accessCode;
  final int partyPin;
  final int leaderKey;
  final String uniqueId;

  ResponseMccmDeleteSchedule({
    required super.reactionType,
    required super.status,
    required this.regNum,
    required this.profileRefNo,
    required this.scheduleRefNo,
    required this.reason,
    required this.accessCode,
    required this.partyPin,
    required this.leaderKey,
    required this.uniqueId,
  });

  factory ResponseMccmDeleteSchedule.fromJson(Map<String, dynamic> json) {
    return ResponseMccmDeleteSchedule(
      reactionType: json['reactionType'],
      status: json['status'] ?? true,
      // Defaulting to true if not present
      regNum: json['regNum'],
      profileRefNo: json['profileRefNo'],
      scheduleRefNo: json['scheduleRefNo'],
      reason: json['reason'],
      accessCode: json['accessCode'] ?? '',
      partyPin: json['partyPin'],
      leaderKey: json['leaderKey'],
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
      'reason': reason,
      'accessCode': accessCode,
      'partyPin': partyPin,
      'leaderKey': leaderKey,
      'uniqueId': uniqueId,
    };
  }
}
