class UserRegisterRequest {
  final String email;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;

  UserRegisterRequest(
      {required this.email,
      required this.username,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.phone});

  Map<String, dynamic> toJson() => {
        'user': {
          'email': email,
          'username': username,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
        },
      };
}

class UserRegisterResponse {
  final String? email;
  final String? username;
  final String? token;
  final String? firstName;
  final String? lastName;
  final String? phone;

  UserRegisterResponse(
      {required this.email,
      required this.username,
      required this.token,
      required this.firstName,
      required this.lastName,
      required this.phone});

  factory UserRegisterResponse.fromJson(Map<String, dynamic> json) {
    return UserRegisterResponse(
      email: json['email'],
      username: json['username'],
      token: json['token'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
    );
  }
}
