import 'dart:async';

import 'package:pemuda_baik/src/models/bursa_model.dart';
import 'package:pemuda_baik/src/repositories/bursa_kerja_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class BursaBloc {
  final BursaKerjaRepo _repo = BursaKerjaRepo();
  StreamController<ApiResponse<BursaModel>>? _streamBursa;
  StreamSink<ApiResponse<BursaModel>> get bursaSink => _streamBursa!.sink;
  Stream<ApiResponse<BursaModel>> get bursaStream => _streamBursa!.stream;
  Future<void> getBursa() async {
    _streamBursa = StreamController();
    bursaSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getBursa();
      if (_streamBursa!.isClosed) return;
      bursaSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBursa!.isClosed) return;
      bursaSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamBursa?.close();
  }
}
