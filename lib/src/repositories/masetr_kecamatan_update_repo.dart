import 'package:pemuda_baik/src/models/master_kecamatan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterKecamatanUpdateRepo {
  Future<ResponseMasterKecamatanSaveModel> updateKecamatan(
      MasterKecamatanSaveModel masterKecamatanSaveModel, int id) async {
    final response = await dio.put('/v1/master/kecamatan/$id',
        masterKecamatanSaveModelToJson(masterKecamatanSaveModel));
    return responseMasterKecamatanSaveModelFromJson(response);
  }
}
