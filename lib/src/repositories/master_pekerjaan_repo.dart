import 'package:pemuda_baik/src/models/master_pekerjaan_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterPekerjaanRepo {
  Future<MasterPekerjaanModel> getPekerjaan() async {
    final response = await dio.get('/v1/master/pekerjaan/create');
    return masterPekerjaanModelFromJson(response);
  }
}
