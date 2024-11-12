import 'package:multicall_mobile/models/message.dart';

/// Model for Request Unmute Call
class RequestUnMuteCall extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int scheduleRefNumber;
  String participantPhoneNumber;
  int profileRefNumber;

  RequestUnMuteCall({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.scheduleRefNumber,
    required this.participantPhoneNumber,
    required this.profileRefNumber,
  }) : super(action: 29, expectedReactionTypes: [121]);

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
