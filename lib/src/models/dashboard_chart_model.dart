DashboardChartModel dashboardChartModelFromJson(dynamic str) =>
    DashboardChartModel.fromJson(str);

class DashboardChartModel {
  DashboardChartModel({
    this.data,
    this.message,
  });

  List<JenisData>? data;
  String? message;

  factory DashboardChartModel.fromJson(Map<String, dynamic> json) =>
      DashboardChartModel(
        data: List<JenisData>.from(
            json["data"].map((x) => JenisData.fromJson(x))),
        message: json["message"],
      );
}

class JenisData {
  JenisData({
    this.id,
    this.nama,
    this.dataPemuda,
  });

  int? id;
  String? nama;
  List<DataPemuda>? dataPemuda;

  factory JenisData.fromJson(Map<String, dynamic> json) => JenisData(
        id: json["id"],
        nama: json["nama"],
        dataPemuda: List<DataPemuda>.from(
            json["dataPemuda"].map((x) => DataPemuda.fromJson(x))),
      );
}

class DataPemuda {
  DataPemuda({
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

  factory DataPemuda.fromJson(Map<String, dynamic> json) => DataPemuda(
        id: json["id"],
        nomorKtp: json["nomor_ktp"],
        nama: json["nama"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jenisKelamin: json["jenis_kelamin"],
        statusNikah: json["status_nikah"],
        agama: json["agama"],
        alamat: json["alamat"],
        nomorKontak: json["nomor_kontak"],
        pekerjaan: Pekerjaan.fromJson(json["pekerjaan"]),
        pendidikan: Pendidikan.fromJson(json["pendidikan"]),
        kecamatan: Kecamatan.fromJson(json["kecamatan"]),
        kelurahan: Kelurahan.fromJson(json["kelurahan"]),
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

class Pekerjaan {
  Pekerjaan({
    this.id,
    this.namaPekerjaan,
  });

  int? id;
  String? namaPekerjaan;

  factory Pekerjaan.fromJson(Map<String, dynamic> json) => Pekerjaan(
        id: json["id"],
        namaPekerjaan: json["nama_pekerjaan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_pekerjaan": namaPekerjaan,
      };
}

class Pendidikan {
  Pendidikan({
    this.id,
    this.namaPendidikan,
  });

  int? id;
  String? namaPendidikan;

  factory Pendidikan.fromJson(Map<String, dynamic> json) => Pendidikan(
        id: json["id"],
        namaPendidikan: json["nama_pendidikan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_pendidikan": namaPendidikan,
      };
}
