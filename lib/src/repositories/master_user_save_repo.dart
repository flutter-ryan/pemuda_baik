import 'package:pemuda_baik/src/models/master_user_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterUserSaveRepo {
  Future<ResponseMasterUserSaveModel> saveUser(
      MasterUserSaveModel masterUserSaveModel) async {
    final response = await dio.post(
        '/v1/master/user', masterUserSaveModelToJson(masterUserSaveModel));
    return responseMasterUserSaveModelFromJson(response);
  }
}
