import 'package:pemuda_baik/src/models/master_kecamatan_model.dart';
import 'package:pemuda_baik/src/models/master_kelurahan_model.dart';
import 'package:pemuda_baik/src/models/master_pekerjaan_model.dart';
import 'package:pemuda_baik/src/models/master_pendidikan_model.dart';

PemudaModel pemudaModelFromJson(dynamic str) => PemudaModel.fromJson(str);

class PemudaModel {
  PemudaModel({
    this.pemuda,
    this.message,
  });

  List<Pemuda>? pemuda;
  String? message;

  factory PemudaModel.fromJson(Map<String, dynamic> json) => PemudaModel(
        pemuda: List<Pemuda>.from(json["data"].map((x) => Pemuda.fromJson(x))),
        message: json["message"],
      );
}

class Pemuda {
  Pemuda({
    this.id,
    this.nomorKtp,
    this.nama,
    this.tanggalLahir,
    this.jenisKelamin,
    this.statusNikah,
    this.agama,
    this.alamat,
    this.nomorKontak,
    this.pekerjaan,
    this.pendidikan,
    this.kecamatan,
    this.kelurahan,
  });

  int? id;
  String? nomorKtp;
  String? nama;
  DateTime? tanggalLahir;
  String? jenisKelamin;
  String? statusNikah;
  String? agama;
  String? alamat;
  String? nomorKontak;
  Pekerjaan? pekerjaan;
  Pendidikan? pendidikan;
  Kecamatan? kecamatan;
  Kelurahan? kelurahan;

  factory Pemuda.fromJson(Map<String, dynamic> json) => Pemuda(
        id: json["id"],
        nomorKtp: json["nomor_ktp"],
        nama: json["nama"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jenisKelamin: json["jenis_kelamin"],
        statusNikah: json["status_nikah"],
        agama: json["agama"],
        alamat: json["alamat"],
        nomorKontak: json["nomor_kontak"],
        pekerjaan: json["pekerjaan"] == null
            ? null
            : Pekerjaan.fromJson(json["pekerjaan"]),
        pendidikan: json["pendidikan"] == null
            ? null
            : Pendidikan.fromJson(json["pendidikan"]),
        kecamatan: json["kecamatan"] == null
            ? null
            : Kecamatan.fromJson(json["kecamatan"]),
        kelurahan: json["kelurahan"] == null
            ? null
            : Kelurahan.fromJson(json["kelurahan"]),
      );
}
