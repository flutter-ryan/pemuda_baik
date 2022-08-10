import 'package:pemuda_baik/src/models/master_user_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterUserDeleteRepo {
  Future<ResponseMasterUserSaveModel> deleteUser(int id) async {
    final response = await dio.delete('/v1/master/user/$id');
    return responseMasterUserSaveModelFromJson(response);
  }
}
