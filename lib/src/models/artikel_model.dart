ArtikelModel artikelModelFromJson(dynamic str) => ArtikelModel.fromJson(str);

class ArtikelModel {
  ArtikelModel({
    this.artikel,
    this.message,
  });

  List<Artikel>? artikel;
  String? message;

  factory ArtikelModel.fromJson(Map<String, dynamic> json) => ArtikelModel(
        artikel:
            List<Artikel>.from(json["data"].map((x) => Artikel.fromJson(x))),
        message: json["message"],
      );
}

class Artikel {
  Artikel({
    this.id,
    this.judul,
    this.penulis,
    this.artikel,
    this.urlImg,
    this.createdAt,
  });

  int? id;
  String? judul;
  String? penulis;
  String? artikel;
  String? urlImg;
  DateTime? createdAt;

  factory Artikel.fromJson(Map<String, dynamic> json) => Artikel(
        id: json["id"],
        judul: json["judul"],
        penulis: json["penulis"],
        artikel: json["artikel"],
        urlImg: json["url"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}
