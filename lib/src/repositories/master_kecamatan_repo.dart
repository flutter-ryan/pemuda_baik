import 'package:pemuda_baik/src/models/master_kecamatan_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterKecamatanRepo {
  Future<MasterKecamatanModel> getKecamatan() async {
    final response = await dio.get('/v1/master/kecamatan/create');
    return masterKecamatanModelFromJson(response);
  }
}
