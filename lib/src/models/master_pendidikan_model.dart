MasterPendidikanModel masterPendidikanModelFromJson(dynamic str) =>
    MasterPendidikanModel.fromJson(str);

class MasterPendidikanModel {
  MasterPendidikanModel({
    this.pendidikan,
    this.message,
  });

  List<Pendidikan>? pendidikan;
  String? message;

  factory MasterPendidikanModel.fromJson(Map<String, dynamic> json) =>
      MasterPendidikanModel(
        pendidikan: List<Pendidikan>.from(
            json["data"].map((x) => Pendidikan.fromJson(x))),
        message: json["message"],
      );
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
}
