import 'package:pemuda_baik/src/models/master_pendidikan_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterPendidikanRepo {
  Future<MasterPendidikanModel> getPendidikan() async {
    final response = await dio.get('/v1/master/pendidikan/create');
    return masterPendidikanModelFromJson(response);
  }
}
