import 'package:pemuda_baik/src/models/bursa_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class BursaUpdateRepo {
  Future<ResponseBursaSaveModel> updateBursa(
      BursaSaveModel bursaSaveModel, int? id) async {
    final response =
        await dio.put('/v1/bursa/$id', bursaSaveModelToJson(bursaSaveModel));
    return responseBursaSaveModelFromJson(response);
  }
}
