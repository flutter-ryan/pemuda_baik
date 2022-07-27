import 'dart:convert';

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
  });

  String nik;
  String nama;
  String tanggalLahir;
  int jenisKelamin;
  int statusNikah;
  String pendidikanTerakhir;
  int pekerjaan;
  String alamat;
  String nomorHp;
  int agama;

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
      };
}
