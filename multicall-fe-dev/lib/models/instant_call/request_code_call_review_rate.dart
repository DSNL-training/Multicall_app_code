import 'package:multicall_mobile/models/message.dart';

class RequestCallReviewRate extends RequestMessage {
  int registrationNumber;
  int chairpersonPin;
  int callRate;

  RequestCallReviewRate({
    required this.registrationNumber,
    required this.chairpersonPin,
    required this.callRate,
  }) : super(action: 105, expectedReactionTypes: []);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['registrationNumber'] = registrationNumber;
    data['chairpersonPin'] = chairpersonPin;
    data['callRate'] = callRate;
    return data;
  }
}
