import 'package:multicall_mobile/models/message.dart';

/// Model for Request Mute Call
class RequestMuteCall extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int scheduleRefNumber;
  String participantPhoneNumber;
  int profileRefNumber;

  RequestMuteCall({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.scheduleRefNumber,
    required this.participantPhoneNumber,
    required this.profileRefNumber,
  }) : super(
          action: 28,
          expectedReactionTypes: [120],
        ); // RES_MUTE_CALL_RESPONSE	- 120

  @override
  Map<String, dynamic> toJson() {
    return {
      'registrationNumber': registrationNumber,
      'telephone': telephone,
      'emailid': emailId,
      'scheduleRefNumber': scheduleRefNumber,
      'participantPhoneNumber': participantPhoneNumber,
      'profileRefNumber': profileRefNumber,
    };
  }
}
