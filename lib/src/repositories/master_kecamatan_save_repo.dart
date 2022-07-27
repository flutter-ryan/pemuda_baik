import 'package:pemuda_baik/src/models/master_kecamatan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterKecamatanSaveRepo {
  Future<ResponseMasterKecamatanSaveModel> saveKecamatan(
      MasterKecamatanSaveModel masterKecamatanSaveModel) async {
    final response = await dio.post('/v1/master/kecamatan',
        masterKecamatanSaveModelToJson(masterKecamatanSaveModel));
    return responseMasterKecamatanSaveModelFromJson(response);
  }
}
