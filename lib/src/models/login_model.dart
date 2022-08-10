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

  LoginUser? user;

  factory ResponseLoginModel.fromJson(Map<String, dynamic> json) =>
      ResponseLoginModel(
        user: LoginUser.fromJson(json["data"]),
      );
}

class LoginUser {
  LoginUser({
    this.id,
    this.token,
    this.name,
    this.role,
  });

  int? id;
  String? token;
  String? name;
  int? role;

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
        id: json["id"],
        token: json["token"],
        name: json["name"],
        role: json["role"],
      );
}
