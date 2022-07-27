import 'dart:convert';

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

ResponseLoginModel responseLoginModelFromJson(dynamic str) =>
    ResponseLoginModel.fromJson(str);

class ResponseLoginModel {
  ResponseLoginModel({
    this.user,
  });

  User? user;

  factory ResponseLoginModel.fromJson(Map<String, dynamic> json) =>
      ResponseLoginModel(
        user: User.fromJson(json["data"]),
      );
}

class User {
  User({
    this.id,
    this.token,
    this.name,
    this.role,
  });

  int? id;
  String? token;
  String? name;
  int? role;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        token: json["token"],
        name: json["name"],
        role: json["role"],
      );
}
