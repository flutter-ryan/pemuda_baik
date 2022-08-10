import 'dart:async';

import 'package:pemuda_baik/src/models/master_user_save_model.dart';
import 'package:pemuda_baik/src/repositories/master_user_delete_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterUserDeleteBloc {
  final MasterUserDeleteRepo _repo = MasterUserDeleteRepo();
  StreamController<ApiResponse<ResponseMasterUserSaveModel>>? _streamUserDelete;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<ResponseMasterUserSaveModel>> get userDeleteSink =>
      _streamUserDelete!.sink;
  Stream<ApiResponse<ResponseMasterUserSaveModel>> get userDeleteStream =>
      _streamUserDelete!.stream;

  Future<void> deleteUser() async {
    _streamUserDelete = StreamController();
    final id = _id.value;
    userDeleteSink.add(ApiResponse.loading('Mamuat'));
    try {
      final res = await _repo.deleteUser(id);
      if (_streamUserDelete!.isClosed) return;
      userDeleteSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamUserDelete!.isClosed) return;
      userDeleteSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamUserDelete?.close();
    _id.close();
  }
}
