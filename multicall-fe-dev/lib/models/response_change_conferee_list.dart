import 'package:multicall_mobile/models/response.dart';

class ResponseChangeConfereeList extends RecievedMessage {
  final int regNum;
  final int profileRefNo;
  final int scheduleRefNo;
  final String uniqueId;

  ResponseChangeConfereeList({
    required super.reactionType,
    required super.status,
    required this.regNum,
    required this.profileRefNo,
    required this.scheduleRefNo,
    required this.uniqueId,
  });

  factory ResponseChangeConfereeList.fromJson(Map<String, dynamic> json) {
    return ResponseChangeConfereeList(
      reactionType: json['reactionType'],
      status: json['status'] ?? true,
      regNum: json['regNum'],
      profileRefNo: json['profileRefNo'],
      scheduleRefNo: json['scheduleRefNo'],
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': status, // Convert boolean status back to int
      'regNum': regNum,
      'profileRefNo': profileRefNo,
      'scheduleRefNo': scheduleRefNo,
      'uniqueId': uniqueId,
    };
  }
}
