import 'package:multicall_mobile/models/response.dart';

class ResponseConferenceStatus extends RecievedMessage {
  final int regNum;
  final int callStatus;
  final int scheduleRefNo;
  final int conferenceRefNo;
  final ConferenceStatus conferenceStatus; // Use the enum for status
  final String uniqueId;

  ResponseConferenceStatus({
    required super.reactionType,
    super.status = true,
    required this.regNum,
    required this.callStatus,
    required this.scheduleRefNo,
    required this.conferenceRefNo,
    required this.conferenceStatus,
    required this.uniqueId,
  });

  factory ResponseConferenceStatus.fromJson(Map<String, dynamic> json) {
    return ResponseConferenceStatus(
      reactionType: json['reactionType'],
      status: true,
      // Defaulting to true as per the requirement
      regNum: json['regNum'],
      callStatus: json['status'],
      scheduleRefNo: json['scheduleRefNo'],
      conferenceRefNo: json['conferenceRefNo'],
      conferenceStatus: ConferenceStatusExtension.fromInt(json['status']),
      // Convert int to enum
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': status ? 1 : 0,
      // Abstract status
      'regNum': regNum,
      'callStatus': callStatus,
      'scheduleRefNo': scheduleRefNo,
      'conferenceRefNo': conferenceRefNo,
      'conferenceStatus': conferenceStatus.toInt(),
      // Convert enum to int for serialization
      'uniqueId': uniqueId,
    };
  }
}

enum ConferenceStatus {
  connectingChairperson,
  couldNotConnectChairperson,
  connectingParticipant,
  minimumBalanceAlert,
  closeTheConference
}

extension ConferenceStatusExtension on ConferenceStatus {
  static ConferenceStatus fromInt(int value) {
    switch (value) {
      case 1:
        return ConferenceStatus.connectingChairperson;
      case 2:
        return ConferenceStatus.couldNotConnectChairperson;
      case 3:
        return ConferenceStatus.connectingParticipant;
      case 4:
        return ConferenceStatus.minimumBalanceAlert;
      case 5:
        return ConferenceStatus.closeTheConference;
      default:
        throw Exception("Invalid conference status value");
    }
  }

  int toInt() {
    switch (this) {
      case ConferenceStatus.connectingChairperson:
        return 1;
      case ConferenceStatus.couldNotConnectChairperson:
        return 2;
      case ConferenceStatus.connectingParticipant:
        return 3;
      case ConferenceStatus.minimumBalanceAlert:
        return 4;
      case ConferenceStatus.closeTheConference:
        return 5;
      default:
        throw Exception("Invalid conference status");
    }
  }

  String get message {
    switch (this) {
      case ConferenceStatus.connectingChairperson:
        return "Connecting to Chairperson";
      case ConferenceStatus.couldNotConnectChairperson:
        return "Could not connect to Chairperson";
      case ConferenceStatus.connectingParticipant:
        return "Connecting to Participant";
      case ConferenceStatus.minimumBalanceAlert:
        return "Minimum balance alert";
      case ConferenceStatus.closeTheConference:
        return "Close the conference";
      default:
        return "Unknown status";
    }
  }
}
