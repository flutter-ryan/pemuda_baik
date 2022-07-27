import 'dart:async';

import 'package:pemuda_baik/src/models/master_kecamatan_save_model.dart';
import 'package:pemuda_baik/src/repositories/master_kecamatan_delete_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterKecamatanDeleteBloc {
  final MasterKecamatanDeleteRepo _repo = MasterKecamatanDeleteRepo();
  StreamController<ApiResponse<ResponseMasterKecamatanSaveModel>>?
      _streamKecamatanDelete;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<ResponseMasterKecamatanSaveModel>>
      get kecamatanDeleteSink => _streamKecamatanDelete!.sink;
  Stream<ApiResponse<ResponseMasterKecamatanSaveModel>>
      get kecamataDeleteStream => _streamKecamatanDelete!.stream;

  Future<void> deleteKecamatan() async {
    _streamKecamatanDelete = StreamController();
    final id = _id.value;
    kecamatanDeleteSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteKecamatan(id);
      if (_streamKecamatanDelete!.isClosed) return;
      kecamatanDeleteSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKecamatanDelete!.isClosed) return;
      kecamatanDeleteSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKecamatanDelete?.close();
    _id.close();
  }
}
