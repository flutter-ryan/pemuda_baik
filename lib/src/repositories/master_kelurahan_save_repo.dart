import 'package:pemuda_baik/src/models/master_kelurahan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterKelurahanSaveRepo {
  Future<ResponseMasterKelurahanSaveModel> saveMasterKelurahan(
      MasterKelurahanSaveModel masterKelurahanSaveModel) async {
    final response = await dio.post('/v1/master/kelurahan',
        masterKelurahanSaveModelToJson(masterKelurahanSaveModel));
    return responseMasterKelurahanSaveModelFromJson(response);
  }
}
