import 'package:multicall_mobile/models/response.dart';

class RestoreScheduleStartResponse extends RecievedMessage {
  int totalScheduleCallCount;
  int sequenceNumber;
  List<ScheduleDetail> schedules;
  String uniqueId;

  RestoreScheduleStartResponse({
    required super.reactionType,
    required super.status,
    required this.totalScheduleCallCount,
    required this.sequenceNumber,
    required this.schedules,
    required this.uniqueId,
  });

  factory RestoreScheduleStartResponse.fromJson(Map<String, dynamic> json) {
    return RestoreScheduleStartResponse(
      reactionType: json['reactionType'],
      status: json['status'] ?? true,
      totalScheduleCallCount: json['totalScheduleCallCount'],
      sequenceNumber: json['sequenceNumber'],
      schedules: (json['schedules'] as List)
          .map((i) => ScheduleDetail.fromJson(i))
          .toList(),
      uniqueId: json['uniqueId'],
    );
  }
}

class ScheduleDetail {
  int profileRefNum;
  int scheduleRefNo;
  String chairpersonPhone;
  int callType;
  int otherFeatures;
  int typeOfStart;
  String chairpersonName;
  int confDuration;
  String scheduleDateTime;
  int repeatType;
  String repeatEndDate;
  int recurrentID;
  int dialinFlag;
  String dialinDID;

  ScheduleDetail({
    required this.profileRefNum,
    required this.scheduleRefNo,
    required this.chairpersonPhone,
    required this.callType,
    required this.otherFeatures,
    required this.typeOfStart,
    required this.chairpersonName,
    required this.confDuration,
    required this.scheduleDateTime,
    required this.repeatType,
    required this.repeatEndDate,
    required this.recurrentID,
    required this.dialinFlag,
    required this.dialinDID,
  });

  factory ScheduleDetail.fromJson(Map<String, dynamic> json) {
    return ScheduleDetail(
      profileRefNum: json['profileRefNum'],
      scheduleRefNo: json['scheduleRefNo'],
      chairpersonPhone: json['chairpersonPhone'],
      callType: json['callType'],
      otherFeatures: json['otherFeatures'],
      typeOfStart: json['typeOfStart'],
      chairpersonName: json['chairpersonName'],
      confDuration: json['confDuration'],
      scheduleDateTime: json['scheduleDateTime'],
      repeatType: json['repeatType'],
      repeatEndDate: json['repeatEndDate'],
      recurrentID: json['recurrentID'],
      dialinFlag: json['dialinFlag'],
      dialinDID: json['dialinDID'],
    );
  }
}
