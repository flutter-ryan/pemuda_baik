import 'dart:async';

import 'package:pemuda_baik/src/models/master_users_model.dart';
import 'package:pemuda_baik/src/repositories/master_users_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class MasterUsersBloc {
  final MasterUsersRepo _repo = MasterUsersRepo();
  StreamController<ApiResponse<MasterUsersModel>>? _streamMasterUsers;
  StreamSink<ApiResponse<MasterUsersModel>> get masterUsersSink =>
      _streamMasterUsers!.sink;
  Stream<ApiResponse<MasterUsersModel>> get masterUsersStream =>
      _streamMasterUsers!.stream;

  Future<void> getUsers() async {
    _streamMasterUsers = StreamController();
    masterUsersSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getUsers();
      if (_streamMasterUsers!.isClosed) return;
      masterUsersSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterUsers!.isClosed) return;
      masterUsersSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterUsers?.close();
  }
}
