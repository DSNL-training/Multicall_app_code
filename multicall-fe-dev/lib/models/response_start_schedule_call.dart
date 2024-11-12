import 'package:multicall_mobile/models/response.dart';

class ResponseStartScheduledCall extends RecievedMessage {
  final int regNum;
  final int profileRefNo;
  final int scheduleRefNo;
  final String uniqueId;

  ResponseStartScheduledCall({
    required super.reactionType,
    super.status = true,
    required this.regNum,
    required this.profileRefNo,
    required this.scheduleRefNo,
    required this.uniqueId,
  });

  factory ResponseStartScheduledCall.fromJson(Map<String, dynamic> json) {
    return ResponseStartScheduledCall(
      reactionType: json['reactionType'],
      status: json['status'] ?? true, // Defaulting to true if not present
      regNum: json['regNum'],
      profileRefNo: json['profileRefNo'],
      scheduleRefNo: json['scheduleRefNo'],
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
      'uniqueId': uniqueId,
    };
  }
}
