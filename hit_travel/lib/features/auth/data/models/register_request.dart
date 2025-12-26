class RegisterRequest {
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}