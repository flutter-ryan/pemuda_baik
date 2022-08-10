import 'package:pemuda_baik/src/models/master_pekerjaan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterPekerjaanUpdateRepo {
  Future<ResponseMasterPekerjaanSaveModel> updatePekerjaan(
      MasterPekerjaanSaveModel masterPekerjaanSaveModel, int id) async {
    final response = await dio.put('/v1/master/pekerjaan/$id',
        masterPekerjaanSaveModelToJson(masterPekerjaanSaveModel));
    return responseMasterPekerjaanSaveModelFromJson(response);
  }
}
