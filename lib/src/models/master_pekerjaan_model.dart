MasterPekerjaanModel masterPekerjaanModelFromJson(dynamic str) =>
    MasterPekerjaanModel.fromJson(str);

class MasterPekerjaanModel {
  MasterPekerjaanModel({
    this.pekerjaan,
    this.message,
  });

  List<Pekerjaan>? pekerjaan;
  String? message;

  factory MasterPekerjaanModel.fromJson(Map<String, dynamic> json) =>
      MasterPekerjaanModel(
        pekerjaan: List<Pekerjaan>.from(
            json["data"].map((x) => Pekerjaan.fromJson(x))),
        message: json["message"],
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
}
