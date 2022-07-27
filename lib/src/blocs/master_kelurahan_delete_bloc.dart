import 'dart:async';

import 'package:pemuda_baik/src/models/master_kelurahan_save_model.dart';
import 'package:pemuda_baik/src/repositories/master_kelurahan_delete_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterKelurahanDeleteBloc {
  final MasterKelurahanDeleteRepo _repo = MasterKelurahanDeleteRepo();
  StreamController<ApiResponse<ResponseMasterKelurahanSaveModel>>?
      _streamKelurahanDelete;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<ResponseMasterKelurahanSaveModel>>
      get kelurahanDeleteSink => _streamKelurahanDelete!.sink;
  Stream<ApiResponse<ResponseMasterKelurahanSaveModel>>
      get kelurahanDeleteStream => _streamKelurahanDelete!.stream;

  Future<void> deleteKelurahan() async {
    _streamKelurahanDelete = StreamController();
    final id = _id.value;
    kelurahanDeleteSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteKelurahan(id);
      if (_streamKelurahanDelete!.isClosed) return;
      kelurahanDeleteSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKelurahanDelete!.isClosed) return;
      kelurahanDeleteSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKelurahanDelete?.close();
    _id.close();
  }
}
