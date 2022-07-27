import 'package:pemuda_baik/src/models/master_kecamatan_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterKecamatanDeleteRepo {
  Future<ResponseMasterKecamatanSaveModel> deleteKecamatan(int id) async {
    final response = await dio.delete('/v1/master/kecamatan/$id');
    return responseMasterKecamatanSaveModelFromJson(response);
  }
}
