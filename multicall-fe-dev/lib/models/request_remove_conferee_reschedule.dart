import 'package:multicall_mobile/models/message.dart';

class RequestRemoveConfereeReschedule extends RequestMessage {
  int regNum;
  String telephone;
  String email;
  int profileRefNumber;
  int scheduleRefNumber;
  String confereeName;
  String confereeNumber;
  String confereeEmail;

  RequestRemoveConfereeReschedule({
    required this.regNum,
    required this.telephone,
    required this.email,
    required this.profileRefNumber,
    required this.scheduleRefNumber,
    required this.confereeName,
    required this.confereeNumber,
    required this.confereeEmail,
  }) : super(action: 61, expectedReactionTypes: [149]);

  @override
  Map<String, dynamic> toJson() {
    return {
      'registrationNumber': regNum,
      'telephone': telephone,
      'emailid': email,
      'profileRefNumber': profileRefNumber,
      'scheduleRefNumber': scheduleRefNumber,
      'confereeName': confereeName,
      'confereeNumber': confereeNumber,
      'confereeEmail': confereeEmail,
    };
  }
}
