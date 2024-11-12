

import 'package:multicall_mobile/models/message.dart';

/// Model for Add Conferee To Call
class RequestAddConfereeToCall extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int profileRefNumber;
  int scheduleRefNumber;
  int conferenceRefNumber;
  String contactName;
  String contactNumber;
  String contactEmail;

  RequestAddConfereeToCall({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.profileRefNumber,
    required this.scheduleRefNumber,
    required this.conferenceRefNumber,
    required this.contactName,
    required this.contactNumber,
    required this.contactEmail,
  }) : super(action: 56, expectedReactionTypes: [151]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    data['profileRefNumber'] = profileRefNumber;
    data['scheduleRefNumber'] = scheduleRefNumber;
    data['conferenceRefNumber'] = conferenceRefNumber;
    data['contactName'] = contactName;
    data['contactNumber'] = contactNumber;
    data['contactEmail'] = contactEmail;
    return data;
  }
}