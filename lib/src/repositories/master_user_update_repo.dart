import 'package:pemuda_baik/src/models/master_user_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterUserUpdateRepo {
  Future<ResponseMasterUserSaveModel> updateUser(
      MasterUserSaveModel masterUserSaveModel, int id) async {
    final response = await dio.put(
        '/v1/master/user/$id', masterUserSaveModelToJson(masterUserSaveModel));
    return responseMasterUserSaveModelFromJson(response);
  }
}
