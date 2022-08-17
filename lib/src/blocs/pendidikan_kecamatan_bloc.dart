import 'dart:async';

import 'package:pemuda_baik/src/models/pendidikan_kecamatan_model.dart';
import 'package:pemuda_baik/src/repositories/pendidikan_kecamatan_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PendidikanKecamatanBloc {
  final PendidikanKecamatanRepo _repo = PendidikanKecamatanRepo();
  StreamController<ApiResponse<PendidikanKecamatanModel>>?
      _streamPendidikanKecamatan;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<PendidikanKecamatanModel>>
      get pendidikanKecamatanSink => _streamPendidikanKecamatan!.sink;
  Stream<ApiResponse<PendidikanKecamatanModel>> get pendidikanKecamatanStream =>
      _streamPendidikanKecamatan!.stream;

  Future<void> getPedidikanKecamatan() async {
    _streamPendidikanKecamatan = StreamController();
    final id = _id.value;
    pendidikanKecamatanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPendidikanKecamatan(id);
      if (_streamPendidikanKecamatan!.isClosed) return;
      pendidikanKecamatanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPendidikanKecamatan!.isClosed) return;
      pendidikanKecamatanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPendidikanKecamatan!.close();
    _id.close();
  }
}
