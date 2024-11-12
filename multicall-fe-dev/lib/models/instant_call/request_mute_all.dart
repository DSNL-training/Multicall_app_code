
import 'package:multicall_mobile/models/message.dart';

/// Model for Request Mute All
class RequestMuteAll extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int profileRefNumber;
  int conferenceRefNumber;
  int scheduleRefNumber;
  int actionValue;

  RequestMuteAll({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.profileRefNumber,
    required this.conferenceRefNumber,
    required this.scheduleRefNumber,
    required this.actionValue,
  }) : super(action: 74, expectedReactionTypes: [120]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    data['profileRefNumber'] = profileRefNumber;
    data['conferenceRefNumber'] = conferenceRefNumber;
    data['scheduleRefNumber'] = scheduleRefNumber;
    data['actionValue'] = actionValue;
    return data;
  }
}
