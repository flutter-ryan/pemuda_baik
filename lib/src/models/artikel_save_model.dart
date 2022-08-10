import 'dart:convert';

import 'package:pemuda_baik/src/models/artikel_model.dart';

String artikelSaveModelToJson(ArtikelSaveModel data) =>
    json.encode(data.toJson());

class ArtikelSaveModel {
  ArtikelSaveModel({
    required this.judul,
    required this.penulis,
    required this.artikel,
    required this.ext,
    required this.image,
  });

  String judul;
  String penulis;
  String artikel;
  String ext;
  String image;

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "penulis": penulis,
        "artikel": artikel,
        "ext": ext,
        "image": image,
      };
}

ResponseArtikelSaveModel responseArtikelSaveModelFromJson(dynamic str) =>
    ResponseArtikelSaveModel.fromJson(str);

class ResponseArtikelSaveModel {
  ResponseArtikelSaveModel({
    this.message,
    this.data,
  });

  String? message;
  Artikel? data;

  factory ResponseArtikelSaveModel.fromJson(Map<String, dynamic> json) =>
      ResponseArtikelSaveModel(
        message: json["message"],
        data: Artikel.fromJson(json["data"]),
      );
}
