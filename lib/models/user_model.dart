class UserModel {
  final String email;
  final String username;
  final String token;
  final String firstName;
  final String lastName;
  final String phone;

  UserModel({
    required this.email,
    required this.username,
    required this.token,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var userJson = json['user'];
    return UserModel(
      email: userJson['email'],
      username: userJson['username'],
      token: userJson['token'],
      firstName: userJson['first_name'],
      lastName: userJson['last_name'],
      phone: userJson['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'token': token,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
    };
  }
}
