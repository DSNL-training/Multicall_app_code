import 'package:multicall_mobile/models/response.dart';

class ResponseCallMeOnUpdate extends RecievedMessage {
  final int regNum;
  final String uniqueId;

  ResponseCallMeOnUpdate({
    required super.reactionType,
    required super.status,
    required this.regNum,
    required this.uniqueId,
  });

  factory ResponseCallMeOnUpdate.fromJson(Map<String, dynamic> json) {
    return ResponseCallMeOnUpdate(
      reactionType: json['reactionType'],
      status: json['status'] == 1,
      regNum: json['regNum'],
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': status ? 1 : 0, // Convert boolean status back to int
      'regNum': regNum,
      'uniqueId': uniqueId,
    };
  }
}
