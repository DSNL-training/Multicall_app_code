import 'package:multicall_mobile/models/response.dart';

class ResponseCancelSync extends RecievedMessage {
  int regNum;
  int scheduleRefNo;
  String uniqueId;

  ResponseCancelSync({
    required super.reactionType,
    required super.status,
    required this.regNum,
    required this.scheduleRefNo,
    required this.uniqueId,
  });

  factory ResponseCancelSync.fromJson(Map<String, dynamic> json) {
    return ResponseCancelSync(
      reactionType: json['reactionType'],
      status: true,
      // Assuming status is true if the response is received successfully
      regNum: json['regNum'],
      scheduleRefNo: json['scheduleRefNo'],
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': status,
      'regNum': regNum,
      'scheduleRefNo': scheduleRefNo,
      'uniqueId': uniqueId,
    };
  }
}
