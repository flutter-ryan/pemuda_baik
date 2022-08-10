import 'package:pemuda_baik/src/models/master_kelurahan_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterKelurahanRepo {
  Future<MasterKelurahanModel> getKelurahan() async {
    final response = await dio.get('/v1/master/kelurahan/create');
    return masterKelurahanModelFromJson(response);
  }

  Future<MasterKelurahanModel> getKelurahanKecamatan(int id) async {
    final response = await dio.get('/v1/master/kelurahan/$id');
    return masterKelurahanModelFromJson(response);
  }
}
