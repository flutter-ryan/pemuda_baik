import 'package:pemuda_baik/src/models/jumlah_pemuda_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class JumlahPemudaRepo {
  Future<JumlahPemudaModel> getJumlahPemuda() async {
    final response = await dio.get('/v1/dashboard/jenis-kelamin');
    return jumlahPemudaModelFromJson(response);
  }
}
