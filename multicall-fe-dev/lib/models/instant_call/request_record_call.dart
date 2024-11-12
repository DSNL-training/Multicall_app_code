import 'package:multicall_mobile/models/message.dart';

/// Model for Request Record Call Action
class RequestRecordCallAction extends RequestMessage {
  int registrationNumber;
  String telephone;
  String emailId;
  int profileRefNumber;
  int conferenceRefNumber;
  int scheduleRefNumber;
  int recordAction;
  int lastConnectedEpochTime;
  int groupId;

  RequestRecordCallAction({
    required this.registrationNumber,
    required this.telephone,
    required this.emailId,
    required this.profileRefNumber,
    required this.conferenceRefNumber,
    required this.scheduleRefNumber,
    required this.recordAction,
    required this.lastConnectedEpochTime,
    required this.groupId,
  }) : super(action: 73, expectedReactionTypes: [166, 165]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['telephone'] = telephone;
    data['emailid'] = emailId;
    data['profileRefNumber'] = profileRefNumber;
    data['conferenceRefNumber'] = conferenceRefNumber;
    data['scheduleRefNumber'] = scheduleRefNumber;
    data['recordAction'] = recordAction;
    data['lastConnectedEpochTime'] = lastConnectedEpochTime;
    data['groupId'] = groupId;
    return data;
  }
}
