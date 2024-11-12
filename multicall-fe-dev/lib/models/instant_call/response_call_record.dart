import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/models/response_bulk_update.dart';

class ResponseCallRecord extends RecievedMessage {
  final int regNum;
  final int profileRefNo;
  final int conferenceRefNo;
  final int scheduleRefNo;
  final int callRecordType;
  final RecordStatus recordStatus;
  final String uniqueId;

  ResponseCallRecord({
    required super.reactionType,
    super.status = true,
    required this.regNum,
    required this.profileRefNo,
    required this.conferenceRefNo,
    required this.scheduleRefNo,
    required this.callRecordType,
    required this.recordStatus,
    required this.uniqueId,
  });

  factory ResponseCallRecord.fromJson(Map<String, dynamic> json) {
    return ResponseCallRecord(
      reactionType: json['reactionType'],
      status: true,
      // Defaulting to true as per the requirement
      regNum: json['regNum'],
      profileRefNo: json['profileRefNo'],
      conferenceRefNo: json['conferenceRefNo'],
      scheduleRefNo: json['scheduleRefNo'],
      callRecordType: json['callRecordType'],
      recordStatus: RecordStatusExtension.fromInt(json['callRecordType']),
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': status,
      'regNum': regNum,
      'profileRefNo': profileRefNo,
      'conferenceRefNo': conferenceRefNo,
      'scheduleRefNo': scheduleRefNo,
      'callRecordType': callRecordType.toInt(),
      'uniqueId': uniqueId,
    };
  }
}
