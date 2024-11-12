import 'package:multicall_mobile/models/message.dart';

class RequestChangeConfereesHeader extends RequestMessage {
  int regNum;
  String telephone;
  String email;
  int profileRefNumber;
  int scheduleRefNumber;
  int totalMessages;
  int totalConfereeCount;

  RequestChangeConfereesHeader({
    required this.regNum,
    required this.telephone,
    required this.email,
    required this.profileRefNumber,
    required this.scheduleRefNumber,
    required this.totalMessages,
    required this.totalConfereeCount,
  }) : super(action: 54, expectedReactionTypes: []);

  @override
  Map<String, dynamic> toJson() {
    return {
      'registrationNumber': regNum,
      'telephone': telephone,
      'emailid': email,
      'profileRefNumber': profileRefNumber,
      'scheduleRefNumber': scheduleRefNumber,
      'totalMessages': totalMessages,
      'totalConfereeCount': totalConfereeCount,
    };
  }
}
