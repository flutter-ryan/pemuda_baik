import 'dart:convert';

import 'package:pemuda_baik/src/models/pemuda_page_model.dart';

String pencarianPemudaModelToJson(PencarianPemudaModel data) =>
    json.encode(data.toJson());

class PencarianPemudaModel {
  PencarianPemudaModel({
    required this.filter,
  });

  String filter;

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}

ResponsePencarianPemudaModel responsePencarianPemudaModelFromJson(
        dynamic str) =>
    ResponsePencarianPemudaModel.fromJson(str);

class ResponsePencarianPemudaModel {
  ResponsePencarianPemudaModel({
    this.data,
    this.message,
  });

  List<PemudaPage>? data;
  String? message;

  factory ResponsePencarianPemudaModel.fromJson(Map<String, dynamic> json) =>
      ResponsePencarianPemudaModel(
        data: List<PemudaPage>.from(
            json["data"].map((x) => PemudaPage.fromJson(x))),
        message: json["message"],
      );
}
