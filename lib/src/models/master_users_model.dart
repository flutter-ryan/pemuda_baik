import 'package:pemuda_baik/src/models/user_model.dart';

MasterUsersModel masterUsersModelFromJson(dynamic str) =>
    MasterUsersModel.fromJson(str);

class MasterUsersModel {
  MasterUsersModel({
    this.data,
    this.message,
  });

  List<User>? data;
  String? message;

  factory MasterUsersModel.fromJson(Map<String, dynamic> json) =>
      MasterUsersModel(
        data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
        message: json["message"],
      );
}
