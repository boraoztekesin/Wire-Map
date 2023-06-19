class UserLoginRequest {
  final String email;
  final String password;

  UserLoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'user': {
          'email': email,
          'password': password,
        },
      };
}

class UserLoginResponse {
  final String email;
  final String username;
  final String token;

  UserLoginResponse(
      {required this.email, required this.username, required this.token});

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
      email: json['user']['email'],
      username: json['user']['username'],
      token: json['user']['token'],
    );
  }
}
