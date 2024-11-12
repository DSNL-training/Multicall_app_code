import 'package:multicall_mobile/models/response.dart';

class ResponseRescheduleCall extends RecievedMessage {
  final int regNum;
  final int scheduleRefNo;
  final int profileRefNo;
  final int reason;
  final String uniqueId;

  ResponseRescheduleCall({
    required super.reactionType,
    required super.status,
    required this.regNum,
    required this.scheduleRefNo,
    required this.profileRefNo,
    required this.reason,
    required this.uniqueId,
  });

  factory ResponseRescheduleCall.fromJson(Map<String, dynamic> json) {
    return ResponseRescheduleCall(
      reactionType: json['reactionType'],
      status: json['status'] ?? true,
      // Defaulting to true if not present
      regNum: json['regNum'],
      scheduleRefNo: json['scheduleRefNo'],
      profileRefNo: json['profileRefNo'],
      reason: json['reason'],
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': status,
      'regNum': regNum,
      'scheduleRefNo': scheduleRefNo,
      'profileRefNo': profileRefNo,
      'reason': reason,
      'uniqueId': uniqueId,
    };
  }
}
