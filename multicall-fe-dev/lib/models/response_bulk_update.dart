import 'package:multicall_mobile/models/response.dart';

class ResponseBulkUpdate extends RecievedMessage {
  final int regNum;
  final int profileRefNo;
  final int confRefNo;
  final int scheduleRefNo;
  final int callType;
  final RecordStatus recordStatus;
  final MuteUnMuteAllStatus muteUnMuteAllStatus;
  final int totalConfCount;
  final List<ConferenceParticipant> conferences;
  final String uniqueId;

  ResponseBulkUpdate({
    required super.reactionType,
    super.status = true,
    required this.regNum,
    required this.profileRefNo,
    required this.confRefNo,
    required this.scheduleRefNo,
    required this.callType,
    required this.recordStatus,
    required this.muteUnMuteAllStatus,
    required this.totalConfCount,
    required this.conferences,
    required this.uniqueId,
  });

  factory ResponseBulkUpdate.fromJson(Map<String, dynamic> json) {
    var conferenceList = (json['conferences'] as List)
        .map((i) => ConferenceParticipant.fromJson(i))
        .toList();

    return ResponseBulkUpdate(
      reactionType: json['reactionType'],
      status: true,
      regNum: json['regNum'],
      profileRefNo: json['profileRefNo'],
      confRefNo: json['confRefNo'],
      scheduleRefNo: json['scheduleRefNo'],
      callType: json['callType'],
      recordStatus: RecordStatusExtension.fromInt(json['recordStatus']),
      muteUnMuteAllStatus:
          MuteUnmuteAllStatusExtension.fromInt(json['muteUnmuteAllStatus']),
      totalConfCount: json['totalConfCount'],
      conferences: conferenceList,
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'regNum': regNum,
      'profileRefNo': profileRefNo,
      'confRefNo': confRefNo,
      'scheduleRefNo': scheduleRefNo,
      'callType': callType,
      'recordStatus': recordStatus.toInt(),
      'muteUnmuteAllStatus': muteUnMuteAllStatus.toInt(),
      'totalConfCount': totalConfCount,
      'conferences': conferences.map((e) => e.toJson()).toList(),
      'uniqueId': uniqueId,
    };
  }
}

class ConferenceParticipant {
  final String phoneNumber;
  CallStatus callStatus;
  MuteStatus muteStatus;

  ConferenceParticipant({
    required this.phoneNumber,
    required this.callStatus,
    required this.muteStatus,
  });

  factory ConferenceParticipant.fromJson(Map<String, dynamic> json) {
    return ConferenceParticipant(
      phoneNumber: json['phoneNumber'],
      callStatus: CallStatusExtension.fromInt(json['callStatus']),
      muteStatus: MuteStatusExtension.fromInt(json['muteStatus']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'callStatus': callStatus.toInt(),
      'muteStatus': muteStatus.toInt(),
    };
  }
}

enum RecordStatus { notRecording, recording, paused }

extension RecordStatusExtension on RecordStatus {
  static RecordStatus fromInt(int value) {
    switch (value) {
      case 1:
        return RecordStatus.recording;
      case 2:
        return RecordStatus.paused;
      case 0:
      default:
        return RecordStatus.notRecording;
    }
  }

  int toInt() {
    switch (this) {
      case RecordStatus.recording:
        return 1;
      case RecordStatus.paused:
        return 2;
      case RecordStatus.notRecording:
      default:
        return 0;
    }
  }
}

enum MuteUnMuteAllStatus { unMuted, muted }

extension MuteUnmuteAllStatusExtension on MuteUnMuteAllStatus {
  static MuteUnMuteAllStatus fromInt(int value) {
    switch (value) {
      case 1:
        return MuteUnMuteAllStatus.muted;
      case 0:
      default:
        return MuteUnMuteAllStatus.unMuted;
    }
  }

  int toInt() {
    switch (this) {
      case MuteUnMuteAllStatus.muted:
        return 1;
      case MuteUnMuteAllStatus.unMuted:
      default:
        return 0;
    }
  }
}

enum CallStatus {
  dialing,
  retrying,
  notReachable,
  joinedTheCall,
  leftTheCall,
  notStarted,
  userBusy,
  userNotResponding,
  noAnswerFromUser,
  subscriberAbsent,
  callRejected,
  networkBusy,
  connected,
  disconnected,
  onHold,
  ringing,
  failed,
  unknown
}

extension CallStatusExtension on CallStatus {
  static CallStatus fromInt(int value) {
    switch (value) {
      case 1:
        return CallStatus.dialing;
      case 2:
        return CallStatus.retrying;
      case 3:
        return CallStatus.notReachable;
      case 4:
        return CallStatus.joinedTheCall;
      case 5:
        return CallStatus.leftTheCall;
      case 9:
        return CallStatus.notStarted;
      case 10:
        return CallStatus.userBusy;
      case 11:
        return CallStatus.userNotResponding;
      case 12:
        return CallStatus.noAnswerFromUser;
      case 13:
        return CallStatus.subscriberAbsent;
      case 14:
        return CallStatus.callRejected;
      case 15:
        return CallStatus.networkBusy;
      default:
        return CallStatus.unknown;
    }
  }

  int toInt() {
    switch (this) {
      case CallStatus.dialing:
        return 1;
      case CallStatus.retrying:
        return 2;
      case CallStatus.notReachable:
        return 3;
      case CallStatus.joinedTheCall:
        return 4;
      case CallStatus.leftTheCall:
        return 5;
      case CallStatus.notStarted:
        return 9;
      case CallStatus.userBusy:
        return 10;
      case CallStatus.userNotResponding:
        return 11;
      case CallStatus.noAnswerFromUser:
        return 12;
      case CallStatus.subscriberAbsent:
        return 13;
      case CallStatus.callRejected:
        return 14;
      case CallStatus.networkBusy:
        return 15;
      default:
        return 0;
    }
  }

  String toReadableString() {
    switch (this) {
      case CallStatus.dialing:
        return "Dialing";
      case CallStatus.retrying:
        return "Retrying";
      case CallStatus.notReachable:
        return "Not Reachable";
      case CallStatus.joinedTheCall:
        return "Joined the Call";
      case CallStatus.leftTheCall:
        return "Left the Call";
      case CallStatus.notStarted:
        return "Not Started";
      case CallStatus.userBusy:
        return "User Busy";
      case CallStatus.userNotResponding:
        return "User Not Responding";
      case CallStatus.noAnswerFromUser:
        return "No Answer from User";
      case CallStatus.subscriberAbsent:
        return "Subscriber Absent";
      case CallStatus.callRejected:
        return "Call Rejected";
      case CallStatus.networkBusy:
        return "Network Busy";
      default:
        return "Unknown";
    }
  }
}

enum MuteStatus { unMuted, muted }

extension MuteStatusExtension on MuteStatus {
  static MuteStatus fromInt(int value) {
    switch (value) {
      case 1:
        return MuteStatus.muted;
      case 0:
      default:
        return MuteStatus.unMuted;
    }
  }

  int toInt() {
    switch (this) {
      case MuteStatus.muted:
        return 1;
      case MuteStatus.unMuted:
      default:
        return 0;
    }
  }
}
