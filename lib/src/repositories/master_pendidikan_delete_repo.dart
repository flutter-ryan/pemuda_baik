import 'package:pemuda_baik/src/models/master_pendidikan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterPendidikanDeleteRepo {
  Future<ResponseMasterPendidikanSaveModel> deletePendidikan(int id) async {
    final response = await dio.delete('/v1/master/pendidikan/$id');
    return responseMasterPendidikanSaveModelFromJson(response);
  }
}
