import 'dart:async';

import 'package:pemuda_baik/src/models/jumlah_pemuda_model.dart';
import 'package:pemuda_baik/src/repositories/jumlah_pemuda_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class JumlahPemudaBloc {
  final _repo = JumlahPemudaRepo();
  StreamController<ApiResponse<JumlahPemudaModel>>? _streamJumlahPemuda;
  StreamSink<ApiResponse<JumlahPemudaModel>> get jumlahPemudaSink =>
      _streamJumlahPemuda!.sink;
  Stream<ApiResponse<JumlahPemudaModel>> get jumlahPemudaStream =>
      _streamJumlahPemuda!.stream;

  Future<void> getJumlahPemuda() async {
    _streamJumlahPemuda = StreamController();
    jumlahPemudaSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getJumlahPemuda();
      if (_streamJumlahPemuda!.isClosed) return;
      jumlahPemudaSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamJumlahPemuda!.isClosed) return;
      jumlahPemudaSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamJumlahPemuda?.close();
  }
}
