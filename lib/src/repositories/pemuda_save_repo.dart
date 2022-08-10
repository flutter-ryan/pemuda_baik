import 'package:pemuda_baik/src/models/save_pemuda_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class PemudaSaveRepo {
  Future<ResponseSavePemudaModel> savePemuda(
      SavePemudaModel savePemudaModel) async {
    final response =
        await dio.post('/v1/pemuda', savePemudaModelToJson(savePemudaModel));
    return responseSavePemudaModelFromJson(response);
  }

  Future<ResponseSavePemudaModel> deletePemuda(int id) async {
    final response = await dio.delete('/v1/pemuda/$id');
    return responseSavePemudaModelFromJson(response);
  }
}
