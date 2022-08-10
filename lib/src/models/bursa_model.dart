BursaModel bursaModelFromJson(dynamic str) => BursaModel.fromJson(str);

class BursaModel {
  BursaModel({
    this.data,
    this.message,
  });

  List<BursaKerja>? data;
  String? message;

  factory BursaModel.fromJson(Map<String, dynamic> json) => BursaModel(
        data: List<BursaKerja>.from(
            json["data"].map((x) => BursaKerja.fromJson(x))),
        message: json["message"],
      );
}

class BursaKerja {
  BursaKerja({
    this.id,
    this.title,
    this.persyaratan,
  });

  int? id;
  String? title;
  String? persyaratan;

  factory BursaKerja.fromJson(Map<String, dynamic> json) => BursaKerja(
        id: json["id"],
        title: json["title"],
        persyaratan: json["persyaratan"],
      );
}
