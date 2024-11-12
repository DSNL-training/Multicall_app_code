import 'package:multicall_mobile/models/instant_call/mute_status_extension.dart';
import 'package:multicall_mobile/models/response.dart';

class ResponseUnMuteCall extends RecievedMessage {
  final int regNum;
  final MuteStatus muteStatus; // Using the enum for status
  final String phoneNumber;
  final String uniqueId;

  ResponseUnMuteCall({
    required super.reactionType,
    super.status = true,
    required this.regNum,
    required this.muteStatus,
    required this.phoneNumber,
    required this.uniqueId,
  });

  factory ResponseUnMuteCall.fromJson(Map<String, dynamic> json) {
    return ResponseUnMuteCall(
      reactionType: json['reactionType'],
      status: true,
      // Defaulting to true as per the requirement
      regNum: json['regNum'],
      muteStatus: MuteStatusExtension.fromInt(json['status']),
      // Convert int to enum
      phoneNumber: json['phoneNumber'],
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': muteStatus.toInt(), // Convert enum to int for serialization
      'regNum': regNum,
      'phoneNumber': phoneNumber,
      'uniqueId': uniqueId,
    };
  }
}
