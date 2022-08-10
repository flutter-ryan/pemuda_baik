import 'package:pemuda_baik/src/models/bursa_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class BursaSaveRepo {
  Future<ResponseBursaSaveModel> saveBursa(
      BursaSaveModel bursaSaveModel) async {
    final response =
        await dio.post('/v1/bursa', bursaSaveModelToJson(bursaSaveModel));
    return responseBursaSaveModelFromJson(response);
  }
}
