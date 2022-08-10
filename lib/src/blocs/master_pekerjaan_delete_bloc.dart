import 'dart:async';

import 'package:pemuda_baik/src/models/master_pekerjaan_save_model.dart';
import 'package:pemuda_baik/src/repositories/master_pekerjaan_delete_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterPekerjaanDeleteBloc {
  final MasterPekerjaanDeleteRepo _repo = MasterPekerjaanDeleteRepo();
  StreamController<ApiResponse<ResponseMasterPekerjaanSaveModel>>?
      _streamPekerjaanDelete;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<ResponseMasterPekerjaanSaveModel>>
      get pekerjaanDeleteSink => _streamPekerjaanDelete!.sink;
  Stream<ApiResponse<ResponseMasterPekerjaanSaveModel>>
      get pekerjaanDeleteStream => _streamPekerjaanDelete!.stream;

  Future<void> deletePekerjaan() async {
    _streamPekerjaanDelete = StreamController();
    final id = _id.value;
    pekerjaanDeleteSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deletePekerjaan(id);
      if (_streamPekerjaanDelete!.isClosed) return;
      pekerjaanDeleteSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPekerjaanDelete!.isClosed) return;
      pekerjaanDeleteSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPekerjaanDelete?.close();
    _id.close();
  }
}
