import 'package:multicall_mobile/models/response.dart';

class Profile extends RecievedMessage {
  final int profileRefNo;
  final int? confRefNum;
  final int chairpersonPin;
  final int participantPin;
  final String profilePhone;
  final String profileEmail;
  final String profileName;
  final int accountType;
  final int? allowStatusISD;
  final int profileSize;
  final int? facilityElement;
  final int profileStatus;
  final int defaultProfileFlag;
  final int? regNum;

  Profile(
      {required this.profileRefNo,
      this.confRefNum,
      required this.chairpersonPin,
      required this.participantPin,
      required this.profilePhone,
      required this.profileEmail,
      required this.profileName,
      required this.accountType,
      required this.allowStatusISD,
      this.profileSize = 0,
      this.facilityElement,
      required this.profileStatus,
      this.defaultProfileFlag = 1,
      this.regNum})
      : super(reactionType: 163, status: true);

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        profileRefNo: json['profileRefNo'] ?? 1,
        confRefNum: json['confRefNum'],
        chairpersonPin: json['chairpersonPin'] as int,
        participantPin: json['participantPin'] as int,
        profilePhone: json['profilePhone'] ?? "",
        profileEmail: json['profileEmail'] ?? "",
        profileName: json['profileName'] ?? "",
        accountType: json['accountType'] ?? 4,
        allowStatusISD: json['allowStatusISD'] ?? 2,
        profileSize: json['profileSize'] ?? 0,
        facilityElement: json['facilityElement'],
        profileStatus: json['profileStatus'] ?? 2,
        defaultProfileFlag: json['defaultProfileFlag'] ?? 2,
        regNum: json['regNum'],
      );
}
