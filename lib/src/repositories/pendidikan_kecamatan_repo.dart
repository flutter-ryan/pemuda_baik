import 'package:pemuda_baik/src/models/pendidikan_kecamatan_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class PendidikanKecamatanRepo {
  Future<PendidikanKecamatanModel> getPendidikanKecamatan(int id) async {
    final response = await dio.get('/v1/dashboard/pendidikan-kecamatan/$id');
    return pendidikanKecamatanModelFromJson(response);
  }
}
