import 'dart:convert';

import 'package:pemuda_baik/src/models/master_kelurahan_model.dart';

String masterKelurahanSaveModelToJson(MasterKelurahanSaveModel data) =>
    json.encode(data.toJson());

class MasterKelurahanSaveModel {
  MasterKelurahanSaveModel({
    required this.kelurahan,
    required this.kecamatan,
  });

  String kelurahan;
  int kecamatan;

  Map<String, dynamic> toJson() => {
        "kelurahan": kelurahan,
        "kecamatan": kecamatan,
      };
}

ResponseMasterKelurahanSaveModel responseMasterKelurahanSaveModelFromJson(
        dynamic str) =>
    ResponseMasterKelurahanSaveModel.fromJson(str);

class ResponseMasterKelurahanSaveModel {
  ResponseMasterKelurahanSaveModel({
    this.data,
    this.message,
  });

  Kelurahan? data;
  String? message;

  factory ResponseMasterKelurahanSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseMasterKelurahanSaveModel(
        data: Kelurahan.fromJson(json["data"]),
        message: json["message"],
      );
}
