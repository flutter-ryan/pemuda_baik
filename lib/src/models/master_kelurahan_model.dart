import 'package:pemuda_baik/src/models/master_kecamatan_model.dart';

MasterKelurahanModel masterKelurahanModelFromJson(dynamic str) =>
    MasterKelurahanModel.fromJson(str);

class MasterKelurahanModel {
  MasterKelurahanModel({
    this.kelurahan,
    this.message,
  });

  List<Kelurahan>? kelurahan;
  String? message;

  factory MasterKelurahanModel.fromJson(Map<String, dynamic> json) =>
      MasterKelurahanModel(
        kelurahan: List<Kelurahan>.from(
            json["data"].map((x) => Kelurahan.fromJson(x))),
        message: json["message"],
      );
}

class Kelurahan {
  Kelurahan({
    this.id,
    this.namaKelurahan,
    this.kecamatan,
  });

  int? id;
  String? namaKelurahan;
  Kecamatan? kecamatan;

  factory Kelurahan.fromJson(Map<String, dynamic> json) => Kelurahan(
        id: json["id"],
        namaKelurahan: json["nama_kelurahan"],
        kecamatan: Kecamatan.fromJson(json["kecamatan"]),
      );
}
