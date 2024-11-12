class EmailPinVerificationScreenArguments {
  final int registrationNumber;
  final String telephone;
  final String emailid;
  final String userName;

  const EmailPinVerificationScreenArguments({
    required this.registrationNumber,
    required this.emailid,
    required this.telephone,
    required this.userName,
  });
}

class MobilePinVerificationScreenArguments {
  final int registrationNumber;
  final String telephone;
  final String emailid;
  final bool isLogin;
  final String userName;

  const MobilePinVerificationScreenArguments({
    required this.registrationNumber,
    required this.emailid,
    required this.telephone,
    required this.userName,
    this.isLogin = false,
  });
}
