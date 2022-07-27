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
    this.pendidikanTerakhir,
    this.pekerjaan,
    this.alamat,
    this.nomorKontak,
    this.agama,
  });

  int? id;
  String? nomorKtp;
  String? nama;
  DateTime? tanggalLahir;
  int? jenisKelamin;
  int? statusNikah;
  String? pendidikanTerakhir;
  String? pekerjaan;
  String? alamat;
  String? nomorKontak;
  String? agama;

  factory Pemuda.fromJson(Map<String, dynamic> json) => Pemuda(
        id: json["id"],
        nomorKtp: json["nomor_ktp"],
        nama: json["nama"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jenisKelamin: json["jenis_kelamin"],
        statusNikah: json["status_nikah"],
        pendidikanTerakhir: json["pendidikan_terakhir"],
        pekerjaan: json["pekerjaan"],
        alamat: json["alamat"],
        nomorKontak: json["nomor_kontak"],
        agama: json["agama"],
      );
}
