import 'package:multicall_mobile/models/response.dart';

class ResponseRestoreCallHistory extends RecievedMessage {
  final int participantCount;
  final int participantHere;
  final int sequenceNumber;
  final int profileRefNum;
  final int scheduleRefNum;
  final String startTime;
  final int confDuration;
  final int packetNumber;
  final int recordedFileNumberByte;
  final String? did1;
  final String? did2;
  final String? did3;
  final String expireDate;
  final List<Participant> participants;
  final int callCostByte;
  final int morePacket;
  final String uniqueId;

  ResponseRestoreCallHistory({
    required super.reactionType,
    super.status = true,
    required this.participantCount,
    required this.participantHere,
    required this.sequenceNumber,
    required this.profileRefNum,
    required this.scheduleRefNum,
    required this.startTime,
    required this.confDuration,
    required this.packetNumber,
    required this.recordedFileNumberByte,
    this.did1,
    this.did2,
    this.did3,
    required this.expireDate,
    required this.participants,
    required this.callCostByte,
    required this.morePacket,
    required this.uniqueId,
  });

  factory ResponseRestoreCallHistory.fromJson(Map<String, dynamic> json) {
    return ResponseRestoreCallHistory(
      reactionType: json['reactionType'],
      status: true, // Defaulting to true as per the requirement
      participantCount: json['participantCount'],
      participantHere: json['participantHere'],
      sequenceNumber: json['sequenceNumber'],
      profileRefNum: json['profileRefNum'],
      scheduleRefNum: json['scheduleRefNum'],
      startTime: json['startTime'],
      confDuration: json['confDuration'],
      packetNumber: json['packetNumber'],
      recordedFileNumberByte: json['recordedFileNumberByte'],
      did1: json['DID1'],
      did2: json['DID2'],
      did3: json['DID3'],
      expireDate: json['expireDate'],
      participants: (json['participants'] as List<dynamic>)
          .map((e) => Participant.fromJson(e as Map<String, dynamic>))
          .toList(),
      callCostByte: json['callCostByte'],
      morePacket: json['morePacket'],
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': status ? 1 : 0, // Abstract status
      'participantCount': participantCount,
      'participantHere': participantHere,
      'sequenceNumber': sequenceNumber,
      'profileRefNum': profileRefNum,
      'scheduleRefNum': scheduleRefNum,
      'startTime': startTime,
      'confDuration': confDuration,
      'packetNumber': packetNumber,
      'recordedFileNumberByte': recordedFileNumberByte,
      'DID1': did1,
      'DID2': did2,
      'DID3': did3,
      'expireDate': expireDate,
      'participants': participants.map((e) => e.toJson()).toList(),
      'callCostByte': callCostByte,
      'morePacket': morePacket,
      'uniqueId': uniqueId,
    };
  }

  /// Unique Key for the response
  /// @author: Darshak Kakkad
  String get uniqueKey => '$startTime-$profileRefNum-$scheduleRefNum';
}

class Participant {
  final String phoneNumber;
  final int phoneDuration;

  Participant({
    required this.phoneNumber,
    required this.phoneDuration,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      phoneNumber: json['phoneNumber'],
      phoneDuration: json['phoneDuration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'phoneDuration': phoneDuration,
    };
  }
}
