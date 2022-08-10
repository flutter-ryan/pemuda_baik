import 'package:pemuda_baik/src/models/master_users_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class MasterUsersRepo {
  Future<MasterUsersModel> getUsers() async {
    final response = await dio.get('/v1/master/user');
    return masterUsersModelFromJson(response);
  }
}
