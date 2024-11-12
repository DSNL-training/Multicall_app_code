
import 'package:multicall_mobile/models/response.dart';

class ReDialAllResponse extends RecievedMessage {
  int regNum;
  int scheduleRefNo;
  String uniqueId;

  ReDialAllResponse({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    required this.scheduleRefNo,
    required this.uniqueId,
  });

  factory ReDialAllResponse.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return ReDialAllResponse(
        status: false,
        reactionType: json['reactionType'],
        regNum: 0,
        scheduleRefNo: 0,
        uniqueId: "",
      );
    }
    return ReDialAllResponse(
      status: true,
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      scheduleRefNo: json['scheduleRefNo'],
      uniqueId: json['uniqueId'],
    );
  }
}