class AuthUser {
  String email;
  String name;
  String telephone;

  AuthUser({
    required this.email,
    required this.name,
    required this.telephone,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      email: json['email'],
      name: json['name'],
      telephone: json['telephone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'telephone': telephone,
    };
  }
}
