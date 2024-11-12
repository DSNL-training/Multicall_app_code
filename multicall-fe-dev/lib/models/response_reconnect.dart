import 'package:multicall_mobile/models/response.dart';

class ReconnectResponse extends RecievedMessage {
  int regNum;
  String uniqueId;

  ReconnectResponse({
    required super.reactionType,
    required this.regNum,
    super.status = false,
    required this.uniqueId,
  });

  factory ReconnectResponse.fromJson(Map<String, dynamic> json) {
    return ReconnectResponse(
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      status: json['status'] != 0,
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'regNum': regNum,
      'status': status,
      'uniqueId': uniqueId,
    };
  }
}
