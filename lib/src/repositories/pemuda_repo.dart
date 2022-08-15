import 'package:pemuda_baik/src/models/pemuda_page_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class PemudaRepo {
  Future<PemudaPageModel> getPemuda(int page) async {
    final response = await dio.get('/v1/pemuda/create?page=$page');
    return pemudaPageModelFromJson(response);
  }
}
