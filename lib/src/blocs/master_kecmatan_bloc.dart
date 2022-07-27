import 'dart:async';

import 'package:pemuda_baik/src/models/master_kecamatan_model.dart';
import 'package:pemuda_baik/src/repositories/master_kecamatan_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class MasterKecamatanBloc {
  final MasterKecamatanRepo _repo = MasterKecamatanRepo();
  StreamController<ApiResponse<MasterKecamatanModel>>? _streamMasterKecamatan;
  StreamSink<ApiResponse<MasterKecamatanModel>> get masterKecamatanSink =>
      _streamMasterKecamatan!.sink;
  Stream<ApiResponse<MasterKecamatanModel>> get masterKecamatanStream =>
      _streamMasterKecamatan!.stream;
  Future<void> getKecamatan() async {
    _streamMasterKecamatan = StreamController();
    masterKecamatanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getKecamatan();
      if (_streamMasterKecamatan!.isClosed) return;
      masterKecamatanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterKecamatan!.isClosed) return;
      masterKecamatanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterKecamatan?.close();
  }
}
