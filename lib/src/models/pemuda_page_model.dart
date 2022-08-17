import 'package:pemuda_baik/src/models/master_kecamatan_model.dart';
import 'package:pemuda_baik/src/models/master_kelurahan_model.dart';
import 'package:pemuda_baik/src/models/master_pekerjaan_model.dart';
import 'package:pemuda_baik/src/models/master_pendidikan_model.dart';

PemudaPageModel pemudaPageModelFromJson(dynamic str) =>
    PemudaPageModel.fromJson(str);

class PemudaPageModel {
  PemudaPageModel({
    this.data,
    this.totalPage,
    this.currentPage,
  });

  List<PemudaPage>? data;
  int? currentPage;
  int? totalPage;

  factory PemudaPageModel.fromJson(Map<String, dynamic> json) =>
      PemudaPageModel(
        data: List<PemudaPage>.from(
            json["data"].map((x) => PemudaPage.fromJson(x))),
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
      );
}

class PemudaPage {
  PemudaPage({
    this.id,
    this.noreg,
    this.nomorKtp,
    this.nama,
    this.tanggalLahir,
    this.umur,
    this.jenisKelamin,
    this.statusNikah,
    this.intStatus,
    this.agama,
    this.alamat,
    this.nomorKontak,
    this.pekerjaan,
    this.pendidikan,
    this.kecamatan,
    this.kelurahan,
  });

  int? id;
  String? noreg;
  String? nomorKtp;
  String? nama;
  String? tanggalLahir;
  String? umur;
  String? jenisKelamin;
  String? statusNikah;
  int? intStatus;
  String? agama;
  String? alamat;
  String? nomorKontak;
  Pekerjaan? pekerjaan;
  Pendidikan? pendidikan;
  Kecamatan? kecamatan;
  Kelurahan? kelurahan;

  factory PemudaPage.fromJson(Map<String, dynamic> json) => PemudaPage(
        id: json["id"],
        noreg: json["noreg"],
        nomorKtp: json["nomor_ktp"],
        nama: json["nama"],
        tanggalLahir: json["tanggal_lahir"],
        umur: json["umur"],
        jenisKelamin: json["jenis_kelamin"],
        statusNikah: json["status_nikah"],
        intStatus: json["int_status"],
        agama: json["agama"],
        alamat: json["alamat"],
        nomorKontak: json["nomor_kontak"],
        pekerjaan: Pekerjaan.fromJson(json["pekerjaan"]),
        pendidikan: Pendidikan.fromJson(json["pendidikan"]),
        kecamatan: Kecamatan.fromJson(json["kecamatan"]),
        kelurahan: Kelurahan.fromJson(json["kelurahan"]),
      );
}
