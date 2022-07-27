import 'dart:async';

import 'package:pemuda_baik/src/models/pemuda_model.dart';
import 'package:pemuda_baik/src/repositories/pemuda_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class PemudaBloc {
  final PemudaRepo _repo = PemudaRepo();
  StreamController<ApiResponse<PemudaModel>>? _streamPemuda;
  StreamSink<ApiResponse<PemudaModel>> get pemudaSink => _streamPemuda!.sink;
  Stream<ApiResponse<PemudaModel>> get pemudaStream => _streamPemuda!.stream;
  Future<void> getPemuda() async {
    _streamPemuda = StreamController();
    pemudaSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPemuda();
      if (_streamPemuda!.isClosed) return;
      pemudaSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPemuda!.isClosed) return;
      pemudaSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPemuda?.close();
  }
}
