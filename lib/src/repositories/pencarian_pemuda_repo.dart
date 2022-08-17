import 'package:pemuda_baik/src/models/pencarian_pemuda_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class PencarianPemudaRepo {
  Future<ResponsePencarianPemudaModel> cariPemuda(
      PencarianPemudaModel pencarianPemudaModel) async {
    final response = await dio.post(
        '/v1/pemuda/search', pencarianPemudaModelToJson(pencarianPemudaModel));
    return responsePencarianPemudaModelFromJson(response);
  }
}
