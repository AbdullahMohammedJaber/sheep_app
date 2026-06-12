class SignupRequestModel {
  final String email;
  final String name;
  final String mobile;
  final String password;
  final String cPassword;

  SignupRequestModel({
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.cPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'mobile': mobile,
      'password': password,
      'name': name,
    };
  }
}
