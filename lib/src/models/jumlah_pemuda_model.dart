JumlahPemudaModel jumlahPemudaModelFromJson(dynamic str) =>
    JumlahPemudaModel.fromJson(str);

class JumlahPemudaModel {
  JumlahPemudaModel({
    this.data,
    this.message,
  });

  JumlahPemuda? data;
  String? message;

  factory JumlahPemudaModel.fromJson(Map<String, dynamic> json) =>
      JumlahPemudaModel(
        data: JumlahPemuda.fromJson(json["data"]),
        message: json["message"],
      );
}

class JumlahPemuda {
  JumlahPemuda({
    this.totalLaki,
    this.totalPerempuan,
  });

  String? totalLaki;
  String? totalPerempuan;

  factory JumlahPemuda.fromJson(Map<String, dynamic> json) => JumlahPemuda(
        totalLaki: json["total_laki"],
        totalPerempuan: json["total_perempuan"],
      );
}
