import 'package:multicall_mobile/models/response.dart';

class ResponseScheduleDelete extends RecievedMessage {
  final int regNum;
  final int scheduleRefNo;
  final int reason;
  final String uniqueId;

  ResponseScheduleDelete({
    required super.reactionType,
    required super.status,
    required this.regNum,
    required this.scheduleRefNo,
    required this.reason,
    required this.uniqueId,
  });

  factory ResponseScheduleDelete.fromJson(Map<String, dynamic> json) {
    return ResponseScheduleDelete(
      reactionType: json['reactionType'],
      status: json['status'] ?? true,
      // Defaulting to true if not present
      regNum: json['regNum'],
      scheduleRefNo: json['scheduleRefNo'],
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
      'reason': reason,
      'uniqueId': uniqueId,
    };
  }
}
