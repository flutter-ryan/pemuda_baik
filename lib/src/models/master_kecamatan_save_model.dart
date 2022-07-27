import 'dart:convert';

import 'package:pemuda_baik/src/models/master_kecamatan_model.dart';

String masterKecamatanSaveModelToJson(MasterKecamatanSaveModel data) =>
    json.encode(data.toJson());

class MasterKecamatanSaveModel {
  MasterKecamatanSaveModel({
    required this.kecamatan,
  });

  String kecamatan;

  Map<String, dynamic> toJson() => {
        "kecamatan": kecamatan,
      };
}

ResponseMasterKecamatanSaveModel responseMasterKecamatanSaveModelFromJson(
        dynamic str) =>
    ResponseMasterKecamatanSaveModel.fromJson(str);

class ResponseMasterKecamatanSaveModel {
  ResponseMasterKecamatanSaveModel({
    this.data,
    this.message,
  });

  Kecamatan? data;
  String? message;

  factory ResponseMasterKecamatanSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseMasterKecamatanSaveModel(
        data: Kecamatan.fromJson(json["data"]),
        message: json["message"],
      );
}
