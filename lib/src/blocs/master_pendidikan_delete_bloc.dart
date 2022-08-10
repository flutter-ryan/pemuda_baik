import 'dart:async';

import 'package:pemuda_baik/src/models/master_pendidikan_save_model.dart';
import 'package:pemuda_baik/src/repositories/master_pendidikan_delete_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterPendidikanDeleteBloc {
  final MasterPendidikanDeleteRepo _repo = MasterPendidikanDeleteRepo();
  StreamController<ApiResponse<ResponseMasterPendidikanSaveModel>>?
      _streamPendidikanDelete;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<ResponseMasterPendidikanSaveModel>>
      get pendidikanDeleteSink => _streamPendidikanDelete!.sink;
  Stream<ApiResponse<ResponseMasterPendidikanSaveModel>>
      get pendidikanDeleteStream => _streamPendidikanDelete!.stream;

  Future<void> deletePendidikan() async {
    _streamPendidikanDelete = StreamController();
    final id = _id.value;
    pendidikanDeleteSink.add(ApiResponse.loading('Memuat...'));
    try {
      final response = await _repo.deletePendidikan(id);
      if (_streamPendidikanDelete!.isClosed) return;
      pendidikanDeleteSink.add(ApiResponse.completed(response));
    } catch (e) {
      if (_streamPendidikanDelete!.isClosed) return;
      pendidikanDeleteSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPendidikanDelete?.close();
    _id.close();
  }
}
