import 'package:pemuda_baik/src/models/master_pekerjaan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterPekerjaanSaveRepo {
  Future<ResponseMasterPekerjaanSaveModel> savePekerjaan(
      MasterPekerjaanSaveModel masterPekerjaanSaveModel) async {
    final response = await dio.post('/v1/master/pekerjaan',
        masterPekerjaanSaveModelToJson(masterPekerjaanSaveModel));
    return responseMasterPekerjaanSaveModelFromJson(response);
  }
}
