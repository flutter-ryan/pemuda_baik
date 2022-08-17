import 'package:pemuda_baik/src/models/kecamatan_pendidikan_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class KecamatanPendidikanRepo {
  Future<KecamatanPendidikanModel> getKecamatanPendidikan(int id) async {
    final response = await dio.get('/v1/dashboard/kecamatan-pendidikan/$id');
    return kecamatanPendidikanModelFromJson(response);
  }

  Future<KecamatanPendidikanModel> getKecamatanPekerjaan(int id) async {
    final response = await dio.get('/v1/dashboard/kecamatan-pekerjaan/$id');
    return kecamatanPendidikanModelFromJson(response);
  }
}
