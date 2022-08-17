import 'dart:async';

import 'package:pemuda_baik/src/models/kecamatan_pendidikan_model.dart';
import 'package:pemuda_baik/src/repositories/kecamtan_pendidikan_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class KecamatanPendidikanBloc {
  final KecamatanPendidikanRepo _repo = KecamatanPendidikanRepo();
  StreamController<ApiResponse<KecamatanPendidikanModel>>?
      _streamKecamatanPendidikan;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<KecamatanPendidikanModel>>
      get kecamatanPendidikanSink => _streamKecamatanPendidikan!.sink;
  Stream<ApiResponse<KecamatanPendidikanModel>> get kecamatanPendidikanStream =>
      _streamKecamatanPendidikan!.stream;

  Future<void> getKecamatanPendidikan() async {
    _streamKecamatanPendidikan = StreamController();
    final id = _id.value;
    kecamatanPendidikanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getKecamatanPendidikan(id);
      if (_streamKecamatanPendidikan!.isClosed) return;
      kecamatanPendidikanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKecamatanPendidikan!.isClosed) return;
      kecamatanPendidikanSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getKecamatanPekerjaan() async {
    _streamKecamatanPendidikan = StreamController();
    final id = _id.value;
    kecamatanPendidikanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getKecamatanPekerjaan(id);
      if (_streamKecamatanPendidikan!.isClosed) return;
      kecamatanPendidikanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKecamatanPendidikan!.isClosed) return;
      kecamatanPendidikanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKecamatanPendidikan?.close();
    _id.close();
  }
}
