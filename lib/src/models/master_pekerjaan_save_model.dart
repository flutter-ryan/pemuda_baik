import 'dart:convert';

import 'package:pemuda_baik/src/models/master_pekerjaan_model.dart';

String masterPekerjaanSaveModelToJson(MasterPekerjaanSaveModel data) =>
    json.encode(data.toJson());

class MasterPekerjaanSaveModel {
  MasterPekerjaanSaveModel({
    required this.pekerjaan,
  });

  String pekerjaan;

  Map<String, dynamic> toJson() => {
        "pekerjaan": pekerjaan,
      };
}

ResponseMasterPekerjaanSaveModel responseMasterPekerjaanSaveModelFromJson(
        dynamic str) =>
    ResponseMasterPekerjaanSaveModel.fromJson(str);

class ResponseMasterPekerjaanSaveModel {
  ResponseMasterPekerjaanSaveModel({
    this.data,
    this.message,
  });

  Pekerjaan? data;
  String? message;

  factory ResponseMasterPekerjaanSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseMasterPekerjaanSaveModel(
        data: Pekerjaan.fromJson(json["data"]),
        message: json["message"],
      );
}
