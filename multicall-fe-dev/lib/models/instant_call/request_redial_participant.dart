import 'package:multicall_mobile/models/message.dart';

/// Model for Request Redial Participant
class RequestRedialParticipant extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int scheduleRefNumber;
  String participantPhoneNumber;
  int profileRefNumber;

  RequestRedialParticipant({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.scheduleRefNumber,
    required this.participantPhoneNumber,
    required this.profileRefNumber,
  }) : super(action: 31, expectedReactionTypes: [165]);

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