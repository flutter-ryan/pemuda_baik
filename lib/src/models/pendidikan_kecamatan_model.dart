import 'package:pemuda_baik/src/models/pemuda_page_model.dart';

PendidikanKecamatanModel pendidikanKecamatanModelFromJson(dynamic str) =>
    PendidikanKecamatanModel.fromJson(str);

class PendidikanKecamatanModel {
  PendidikanKecamatanModel({
    this.data,
    this.message,
    this.total = 0,
  });

  List<PendidikanKecamatan>? data;
  String? message;
  int total;

  factory PendidikanKecamatanModel.fromJson(Map<String, dynamic> json) =>
      PendidikanKecamatanModel(
        data: List<PendidikanKecamatan>.from(
            json["data"].map((x) => PendidikanKecamatan.fromJson(x))),
        message: json["message"],
        total: json["total"],
      );
}

class PendidikanKecamatan {
  PendidikanKecamatan({
    this.id,
    this.namaPendidikan,
    this.jumlah,
    this.pemuda,
  });

  int? id;
  String? namaPendidikan;
  int? jumlah;
  List<PemudaPage>? pemuda;

  factory PendidikanKecamatan.fromJson(Map<String, dynamic> json) =>
      PendidikanKecamatan(
        id: json["id"],
        namaPendidikan: json["nama_pendidikan"],
        jumlah: json["jumlah"],
        pemuda: List<PemudaPage>.from(
            json["pemuda"].map((x) => PemudaPage.fromJson(x))),
      );
}
