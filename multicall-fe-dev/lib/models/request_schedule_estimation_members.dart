import 'package:multicall_mobile/models/message.dart';

/// Model for Request Schedule Estimation
class RequestScheduleEstimationMembers extends RequestMessage {
  int registrationNumber;
  int profileRefNumber;
  int numberOfMembers;
  List<MemberEstimation> members;

  RequestScheduleEstimationMembers({
    required this.registrationNumber,
    required this.profileRefNumber,
    required this.numberOfMembers,
    required this.members,
  }) : super(action: 77, expectedReactionTypes: [170]);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['profileRefNumber'] = profileRefNumber;
    data['numberOfMembers'] = numberOfMembers;
    data['members'] = members.map((member) => member.toJson()).toList();
    return data;
  }
}

/// Model for Member Estimation
class MemberEstimation {
  String memberNumber;
  int callType;

  MemberEstimation({
    required this.memberNumber,
    required this.callType,
  });

  Map<String, dynamic> toJson() {
    return {
      'memberNumber': memberNumber,
      'callType':
          1, //Internal logic in the backend so it always should be one(conveyed from client)
    };
  }
}
