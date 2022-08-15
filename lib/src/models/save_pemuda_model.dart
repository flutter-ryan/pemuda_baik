import 'dart:convert';
import 'package:pemuda_baik/src/models/pemuda_page_model.dart';

String savePemudaModelToJson(SavePemudaModel data) =>
    json.encode(data.toJson());

class SavePemudaModel {
  SavePemudaModel({
    required this.nik,
    required this.nama,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.statusNikah,
    required this.agama,
    required this.pendidikanTerakhir,
    required this.pekerjaan,
    required this.alamat,
    required this.nomorHp,
    required this.kecamatan,
    required this.kelurahan,
  });

  String nik;
  String nama;
  String tanggalLahir;
  int jenisKelamin;
  int statusNikah;
  int pendidikanTerakhir;
  int pekerjaan;
  String alamat;
  String nomorHp;
  int agama;
  int kelurahan;
  int kecamatan;

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "nama": nama,
        "tanggalLahir": tanggalLahir,
        "jenisKelamin": jenisKelamin,
        "statusNikah": statusNikah,
        "agama": agama,
        "pendidikanTerakhir": pendidikanTerakhir,
        "pekerjaan": pekerjaan,
        "alamat": alamat,
        "nomorHp": nomorHp,
        "kelurahan": kelurahan,
        "kecamatan": kecamatan
      };
}

ResponseSavePemudaModel responseSavePemudaModelFromJson(dynamic str) =>
    ResponseSavePemudaModel.fromJson(str);

class ResponseSavePemudaModel {
  ResponseSavePemudaModel({
    this.data,
    this.message,
  });

  PemudaPage? data;
  String? message;

  factory ResponseSavePemudaModel.fromJson(Map<String, dynamic> json) =>
      ResponseSavePemudaModel(
        data: PemudaPage.fromJson(json["data"]),
        message: json["message"],
      );
}
