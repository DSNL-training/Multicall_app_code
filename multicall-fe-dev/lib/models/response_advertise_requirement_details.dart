import 'package:multicall_mobile/models/response.dart';

class AdvertiseRequirementDetailsResponse extends RecievedMessage {
  int regNum;
  int profileRefNum;
  int memberCount;
  int adStatus;
  int adType;
  int adTimeFlag;
  String adStartTime;
  String adEndTime;
  String uniqueId;

  AdvertiseRequirementDetailsResponse({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    required this.profileRefNum,
    required this.memberCount,
    required this.adStatus,
    required this.adType,
    required this.adTimeFlag,
    required this.adStartTime,
    required this.adEndTime,
    required this.uniqueId,
  });

  factory AdvertiseRequirementDetailsResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return AdvertiseRequirementDetailsResponse(
        status: false,
        reactionType: json['reactionType'],
        regNum: 0,
        profileRefNum: 0,
        adStatus: 0,
        adType: 0,
        adTimeFlag: 0,
        memberCount: 0,
        adEndTime: "",
        adStartTime: "",
        uniqueId: "",
      );
    }
    return AdvertiseRequirementDetailsResponse(
      status: true,
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      profileRefNum: json['profileRefNum'],
      adStatus: json['adStatus'],
      adType: json['adType'],
      memberCount: json['memberCount'],
      adTimeFlag: json['adTimeFlag'],
      adStartTime: json['adStartTime'],
      adEndTime: json['adEndTime'],
      uniqueId: json['uniqueId'],
    );
  }
}
