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
    this.jumlah,
    this.jenisKelamin,
  });

  int? id;
  String? nama;
  int? jumlah;
  JenisKelamin? jenisKelamin;

  factory JenisData.fromJson(Map<String, dynamic> json) => JenisData(
        id: json["id"],
        nama: json["nama"],
        jumlah: json["jumlah"],
        jenisKelamin: JenisKelamin.fromJson(json["jenisKelamin"]),
      );
}

class JenisKelamin {
  JenisKelamin({
    this.lakiLaki,
    this.perempuan,
  });

  int? lakiLaki;
  int? perempuan;

  factory JenisKelamin.fromJson(Map<String, dynamic> json) => JenisKelamin(
        lakiLaki: json["laki-laki"],
        perempuan: json["perempuan"],
      );
}
