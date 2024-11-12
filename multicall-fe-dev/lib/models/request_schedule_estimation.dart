import 'package:multicall_mobile/models/message.dart';

/// Model for Request Schedule Estimation
class RequestScheduleEstimation extends RequestMessage {
  int registrationNumber;
  int profileRefNumber;
  int confDuration;
  int totalNumberOfMessages;
  String chairPersonPhoneNumber;
  int dialType;
  int otherFeatures;
  int typeOfStart;
  int totalMembers;

  RequestScheduleEstimation({
    required this.registrationNumber,
    required this.profileRefNumber,
    required this.confDuration,
    required this.totalNumberOfMessages,
    required this.chairPersonPhoneNumber,
    required this.dialType,
    required this.otherFeatures,
    required this.typeOfStart,
    required this.totalMembers,
  }) : super(action: 76, expectedReactionTypes: [170]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['profileRefNumber'] = profileRefNumber;
    data['confDuration'] = confDuration;
    data['totalNumberOfMessages'] = totalNumberOfMessages;
    data['chairPersonPhoneNumber'] = chairPersonPhoneNumber;
    data['dialType'] =
        1; //Internal logic in the backend so it always should be one(conveyed from client)
    data['otherFeatures'] = otherFeatures;
    data['typeOfStart'] = typeOfStart;
    data['totalMembers'] = totalMembers;
    return data;
  }
}
