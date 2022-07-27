import 'dart:async';

import 'package:pemuda_baik/src/models/master_kelurahan_model.dart';
import 'package:pemuda_baik/src/repositories/master_kelurahan_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class MasterKelurahanBloc {
  final MasterKelurahanRepo _repo = MasterKelurahanRepo();
  StreamController<ApiResponse<MasterKelurahanModel>>? _streamMasterKelurahan;
  StreamSink<ApiResponse<MasterKelurahanModel>> get masterKelurahanSink =>
      _streamMasterKelurahan!.sink;
  Stream<ApiResponse<MasterKelurahanModel>> get masterKelurahanStream =>
      _streamMasterKelurahan!.stream;
  Future<void> getMasterKelurahan() async {
    _streamMasterKelurahan = StreamController();
    masterKelurahanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getKelurahan();
      if (_streamMasterKelurahan!.isClosed) return;
      masterKelurahanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterKelurahan!.isClosed) return;
      masterKelurahanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterKelurahan?.close();
  }
}
