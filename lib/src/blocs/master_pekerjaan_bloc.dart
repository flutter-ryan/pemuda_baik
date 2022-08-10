import 'dart:async';

import 'package:pemuda_baik/src/models/master_pekerjaan_model.dart';
import 'package:pemuda_baik/src/repositories/master_pekerjaan_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class MasterPekerjaanBloc {
  final MasterPekerjaanRepo _repo = MasterPekerjaanRepo();
  StreamController<ApiResponse<MasterPekerjaanModel>>? _streamMasterPekerjaan;
  StreamSink<ApiResponse<MasterPekerjaanModel>> get masterPekerjaanSink =>
      _streamMasterPekerjaan!.sink;
  Stream<ApiResponse<MasterPekerjaanModel>> get masterPekerjaanStream =>
      _streamMasterPekerjaan!.stream;

  Future<void> getPekerjaan() async {
    _streamMasterPekerjaan = StreamController();
    masterPekerjaanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPekerjaan();
      if (_streamMasterPekerjaan!.isClosed) return;
      masterPekerjaanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterPekerjaan!.isClosed) return;
      masterPekerjaanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterPekerjaan?.close();
  }
}
