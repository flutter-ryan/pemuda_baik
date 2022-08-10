import 'dart:async';

import 'package:pemuda_baik/src/models/user_model.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:pemuda_baik/src/repositories/user_repo.dart';

class UserBloc {
  final UserRepo _repo = UserRepo();
  StreamController<ApiResponse<UserModel>>? _streamUser;
  StreamSink<ApiResponse<UserModel>> get userSink => _streamUser!.sink;
  Stream<ApiResponse<UserModel>> get userStream => _streamUser!.stream;

  Future<void> getUser() async {
    _streamUser = StreamController();
    userSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getUser();
      if (_streamUser!.isClosed) return;
      userSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamUser!.isClosed) return;
      userSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamUser?.close();
  }
}
