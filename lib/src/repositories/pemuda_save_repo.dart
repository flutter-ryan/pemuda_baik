import 'package:pemuda_baik/src/models/response_model.dart';
import 'package:pemuda_baik/src/models/save_pemuda_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class PemudaSaveRepo {
  Future<ResponseModel> savePemuda(SavePemudaModel savePemudaModel) async {
    final response =
        await dio.post('/v1/pemuda', savePemudaModelToJson(savePemudaModel));
    return responseModelFromJson(response);
  }
}
