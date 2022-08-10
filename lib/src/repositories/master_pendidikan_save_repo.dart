import 'package:pemuda_baik/src/models/master_pendidikan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterPendidikanSaveRepo {
  Future<ResponseMasterPendidikanSaveModel> savePendidikan(
      MasterPendidikanSaveModel masterPendidikanSaveModel) async {
    final response = await dio.post('/v1/master/pendidikan',
        masterPendidikanSaveModelToJson(masterPendidikanSaveModel));
    return responseMasterPendidikanSaveModelFromJson(response);
  }
}
