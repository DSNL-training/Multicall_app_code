class UserDetails {
  final String accountId;
  final String registrationNumber;
  final String profileReferenceNumber;
  final String name;
  final String address;
  final String state;
  final String city;
  final String postalCode;
  final String gstNumber;
  final String paymentStateCode;
  final String addressFlag;

  UserDetails({
    required this.accountId,
    required this.registrationNumber,
    required this.profileReferenceNumber,
    required this.name,
    required this.address,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.gstNumber,
    required this.paymentStateCode,
    required this.addressFlag,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      accountId: json['account_id'],
      registrationNumber: json['registration_number'],
      profileReferenceNumber: json['profile_reference_number'],
      name: json['name'],
      address: json['address'],
      state: json['state'],
      city: json['city'],
      postalCode: json['postalcode'],
      gstNumber: json['gstnumber'],
      addressFlag: json['addressflag'],
      paymentStateCode: json['payment_state_code'],
    );
  }
}
