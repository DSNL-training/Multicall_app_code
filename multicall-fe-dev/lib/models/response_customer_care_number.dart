import 'package:multicall_mobile/models/response.dart';

class ResponseCustomerCareNumber extends RecievedMessage {
  int regNum;
  String customerCareNumber;

  ResponseCustomerCareNumber({
    super.status = false,
    required super.reactionType,
    required this.regNum,
    required this.customerCareNumber,
  });

  factory ResponseCustomerCareNumber.fromJson(Map<String, dynamic> json) {
    if (json['reactionType'] == 102) {
      return ResponseCustomerCareNumber(
        status: false,
        reactionType: json['reactionType'],
        regNum: 0,
        customerCareNumber: '',
      );
    }
    return ResponseCustomerCareNumber(
      status: true,
      reactionType: json['reactionType'],
      regNum: json['regNum'],
      customerCareNumber: json['customerCareNumber'],
    );
  }
}
