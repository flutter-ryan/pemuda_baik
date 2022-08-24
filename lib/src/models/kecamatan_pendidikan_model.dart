import 'package:pemuda_baik/src/models/pemuda_page_model.dart';

KecamatanPendidikanModel kecamatanPendidikanModelFromJson(dynamic str) =>
    KecamatanPendidikanModel.fromJson(str);

class KecamatanPendidikanModel {
  KecamatanPendidikanModel({
    this.data,
    this.message,
    this.total = 0,
  });

  List<KecamatanPendidikan>? data;
  String? message;
  int total;

  factory KecamatanPendidikanModel.fromJson(Map<String, dynamic> json) =>
      KecamatanPendidikanModel(
        data: List<KecamatanPendidikan>.from(
            json["data"].map((x) => KecamatanPendidikan.fromJson(x))),
        message: json["message"],
        total: json["total"],
      );
}

class KecamatanPendidikan {
  KecamatanPendidikan({
    this.id,
    this.namaKecamatan,
    this.jumlah,
    this.pemuda,
  });

  int? id;
  String? namaKecamatan;
  int? jumlah;
  List<PemudaPage>? pemuda;

  factory KecamatanPendidikan.fromJson(Map<String, dynamic> json) =>
      KecamatanPendidikan(
        id: json["id"],
        namaKecamatan: json["nama_kecamatan"],
        jumlah: json["jumlah"],
        pemuda: List<PemudaPage>.from(
            json["pemuda"].map((x) => PemudaPage.fromJson(x))),
      );
}
