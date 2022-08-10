import 'package:pemuda_baik/src/models/master_pekerjaan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterPekerjaanDeleteRepo {
  Future<ResponseMasterPekerjaanSaveModel> deletePekerjaan(int id) async {
    final response = await dio.delete('/v1/master/pekerjaan/$id');
    return responseMasterPekerjaanSaveModelFromJson(response);
  }
}
