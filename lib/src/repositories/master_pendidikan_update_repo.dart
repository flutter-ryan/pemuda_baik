import 'package:pemuda_baik/src/models/master_pendidikan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterPendidikanUpdateRepo {
  Future<ResponseMasterPendidikanSaveModel> updatePendidikan(
      MasterPendidikanSaveModel masterPendidikanSaveModel, int id) async {
    final response = await dio.put('/v1/master/pendidikan/$id',
        masterPendidikanSaveModelToJson(masterPendidikanSaveModel));
    return responseMasterPendidikanSaveModelFromJson(response);
  }
}
