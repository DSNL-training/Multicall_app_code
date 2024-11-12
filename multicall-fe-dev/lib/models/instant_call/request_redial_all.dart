import 'package:multicall_mobile/models/message.dart';

/// Model for Request Redial All
class RequestRedialAll extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int scheduleRefNumber;
  int profileRefNumber;

  RequestRedialAll({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.scheduleRefNumber,
    required this.profileRefNumber,
  }) : super(action: 30, expectedReactionTypes: [165]);

  @override
  Map<String, dynamic> toJson() {
    return {
      'registrationNumber': registrationNumber,
      'telephone': telephone,
      'emailid': emailId,
      'scheduleRefNumber': scheduleRefNumber,
      'profileRefNumber': profileRefNumber,
    };
  }
}
