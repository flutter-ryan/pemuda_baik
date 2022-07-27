import 'package:pemuda_baik/src/models/pemuda_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class PemudaRepo {
  Future<PemudaModel> getPemuda() async {
    final response = await dio.get('/v1/pemuda/create');
    return pemudaModelFromJson(response);
  }
}
