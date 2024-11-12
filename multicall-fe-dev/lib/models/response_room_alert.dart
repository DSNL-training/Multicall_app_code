import 'package:multicall_mobile/models/response.dart';

class RoomAlertResponse extends RecievedMessage {
  int regNum;
  int profileRefNum;
  int scheduleRefNo;
  int roomAlert;
  String uniqueId;

  RoomAlertResponse({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    required this.profileRefNum,
    required this.scheduleRefNo,
    required this.roomAlert,
    required this.uniqueId,
  });

  factory RoomAlertResponse.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return RoomAlertResponse(
        status: false,
        reactionType: json['reactionType'],
        regNum: 0,
        profileRefNum: 0,
        scheduleRefNo: 0,
        roomAlert: 0,
        uniqueId: "",
      );
    }
    return RoomAlertResponse(
      status: true,
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      profileRefNum: json['profileRefNum'],
      scheduleRefNo: json['scheduleRefNo'],
      roomAlert: json['roomAlert'],
      uniqueId: json['uniqueId'],
    );
  }
}