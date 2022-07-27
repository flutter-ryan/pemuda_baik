MasterKecamatanModel masterKecamatanModelFromJson(dynamic str) =>
    MasterKecamatanModel.fromJson(str);

class MasterKecamatanModel {
  MasterKecamatanModel({
    this.kecamatan,
    this.message,
  });

  List<Kecamatan>? kecamatan;
  String? message;

  factory MasterKecamatanModel.fromJson(Map<String, dynamic> json) =>
      MasterKecamatanModel(
        kecamatan: List<Kecamatan>.from(
            json["data"].map((x) => Kecamatan.fromJson(x))),
        message: json["message"],
      );
}

class Kecamatan {
  Kecamatan({
    this.id,
    this.namaKecamatan,
  });

  int? id;
  String? namaKecamatan;

  factory Kecamatan.fromJson(Map<String, dynamic> json) => Kecamatan(
        id: json["id"],
        namaKecamatan: json["nama_kecamatan"],
      );
}
