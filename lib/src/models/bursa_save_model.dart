import 'dart:convert';

import 'package:pemuda_baik/src/models/bursa_model.dart';

String bursaSaveModelToJson(BursaSaveModel data) => json.encode(data.toJson());

class BursaSaveModel {
  BursaSaveModel({
    required this.judul,
    required this.persyaratan,
  });

  String judul;
  String persyaratan;

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "persyaratan": persyaratan,
      };
}

ResponseBursaSaveModel responseBursaSaveModelFromJson(dynamic str) =>
    ResponseBursaSaveModel.fromJson(str);

class ResponseBursaSaveModel {
  ResponseBursaSaveModel({
    this.data,
    this.message,
  });

  BursaKerja? data;
  String? message;

  factory ResponseBursaSaveModel.fromJson(Map<String, dynamic> json) =>
      ResponseBursaSaveModel(
        data: BursaKerja.fromJson(json["data"]),
        message: json["message"],
      );
}
