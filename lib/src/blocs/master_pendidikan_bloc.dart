import 'dart:async';

import 'package:pemuda_baik/src/models/master_pendidikan_model.dart';
import 'package:pemuda_baik/src/repositories/master_pendidikan_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class MasterPendidikanBloc {
  final MasterPendidikanRepo _repo = MasterPendidikanRepo();
  StreamController<ApiResponse<MasterPendidikanModel>>? _streamMasterPendidikan;
  StreamSink<ApiResponse<MasterPendidikanModel>> get masterPendidikanSink =>
      _streamMasterPendidikan!.sink;
  Stream<ApiResponse<MasterPendidikanModel>> get masterPendidikanStream =>
      _streamMasterPendidikan!.stream;

  Future<void> getPendidikan() async {
    _streamMasterPendidikan = StreamController();
    masterPendidikanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPendidikan();
      if (_streamMasterPendidikan!.isClosed) return;
      masterPendidikanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterPendidikan!.isClosed) return;
      masterPendidikanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterPendidikan?.close();
  }
}
