import 'package:pemuda_baik/src/models/master_kelurahan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterKelurahanUpdateRepo {
  Future<ResponseMasterKelurahanSaveModel> updateKelurahan(
      MasterKelurahanSaveModel masterKelurahanSaveModel, int id) async {
    final response = await dio.put('/v1/master/kelurahan/$id',
        masterKelurahanSaveModelToJson(masterKelurahanSaveModel));
    return responseMasterKelurahanSaveModelFromJson(response);
  }
}
