import 'package:pemuda_baik/src/models/master_kelurahan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterKelurahanDeleteRepo {
  Future<ResponseMasterKelurahanSaveModel> deleteKelurahan(int id) async {
    final response = await dio.delete('/v1/master/kelurahan/$id');
    return responseMasterKelurahanSaveModelFromJson(response);
  }
}
