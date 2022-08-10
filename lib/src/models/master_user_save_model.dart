import 'dart:convert';

import 'package:pemuda_baik/src/models/user_model.dart';

String masterUserSaveModelToJson(MasterUserSaveModel data) =>
    json.encode(data.toJson());

class MasterUserSaveModel {
  MasterUserSaveModel({
    required this.nama,
    required this.email,
    this.password,
    this.passwordConfirmation,
    required this.role,
    this.pemuda,
  });

  String nama;
  String email;
  String? password;
  String? passwordConfirmation;
  int role;
  String? pemuda;

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "role": role,
        "pemuda": pemuda,
      };
}

ResponseMasterUserSaveModel responseMasterUserSaveModelFromJson(dynamic str) =>
    ResponseMasterUserSaveModel.fromJson(str);

class ResponseMasterUserSaveModel {
  ResponseMasterUserSaveModel({
    this.data,
    this.message,
  });

  User? data;
  String? message;

  factory ResponseMasterUserSaveModel.fromJson(Map<String, dynamic> json) =>
      ResponseMasterUserSaveModel(
        data: User.fromJson(json["data"]),
        message: json["message"],
      );
}
