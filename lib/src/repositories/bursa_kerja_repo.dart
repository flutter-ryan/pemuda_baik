import 'package:pemuda_baik/src/models/bursa_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class BursaKerjaRepo {
  Future<BursaModel> getBursa() async {
    final response = await dio.get('/v1/bursa/create');
    return bursaModelFromJson(response);
  }
}
