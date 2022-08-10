import 'package:pemuda_baik/src/models/user_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class UserRepo {
  Future<UserModel> getUser() async {
    final response = await dio.get('/v1/user/create');
    return userModelFromJson(response);
  }
}
