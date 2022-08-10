import 'dart:convert';

import 'package:pemuda_baik/src/models/master_pendidikan_model.dart';

String masterPendidikanSaveModelToJson(MasterPendidikanSaveModel data) =>
    json.encode(data.toJson());

class MasterPendidikanSaveModel {
  MasterPendidikanSaveModel({
    required this.pendidikan,
  });

  String pendidikan;

  Map<String, dynamic> toJson() => {
        "pendidikan": pendidikan,
      };
}

ResponseMasterPendidikanSaveModel responseMasterPendidikanSaveModelFromJson(
        dynamic str) =>
    ResponseMasterPendidikanSaveModel.fromJson(str);

class ResponseMasterPendidikanSaveModel {
  ResponseMasterPendidikanSaveModel({
    this.data,
    this.message,
  });

  Pendidikan? data;
  String? message;

  factory ResponseMasterPendidikanSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseMasterPendidikanSaveModel(
        data: Pendidikan.fromJson(json["data"]),
        message: json["message"],
      );
}
