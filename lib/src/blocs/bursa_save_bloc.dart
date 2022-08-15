import 'dart:async';

import 'package:pemuda_baik/src/models/bursa_save_model.dart';
import 'package:pemuda_baik/src/repositories/bursa_save_repo.dart';
import 'package:pemuda_baik/src/repositories/bursa_update_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class BursaSaveBloc {
  final BursaSaveRepo _repo = BursaSaveRepo();
  final BursaUpdateRepo _repoUpdate = BursaUpdateRepo();
  StreamController<ApiResponse<ResponseBursaSaveModel>>? _streamBursaSave;
  final BehaviorSubject<String> _judul = BehaviorSubject();
  final BehaviorSubject<String> _persyaratan = BehaviorSubject();
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get judulSink => _judul.sink;
  StreamSink<String> get persyaratanSink => _persyaratan.sink;
  StreamSink<ApiResponse<ResponseBursaSaveModel>> get bursaSaveSink =>
      _streamBursaSave!.sink;
  Stream<ApiResponse<ResponseBursaSaveModel>> get bursaSaveStream =>
      _streamBursaSave!.stream;
  Future<void> saveBursa() async {
    _streamBursaSave = StreamController();
    final judul = _judul.value;
    final persyaratan = _persyaratan.value;
    bursaSaveSink.add(ApiResponse.loading('Memuat...'));
    BursaSaveModel bursaSaveModel =
        BursaSaveModel(judul: judul, persyaratan: persyaratan);
    try {
      final res = await _repo.saveBursa(bursaSaveModel);
      if (_streamBursaSave!.isClosed) return;
      bursaSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBursaSave!.isClosed) return;
      bursaSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateBursa() async {
    _streamBursaSave = StreamController();
    final id = _id.value;
    final judul = _judul.value;
    final persyaratan = _persyaratan.value;
    bursaSaveSink.add(ApiResponse.loading('Memuat...'));
    BursaSaveModel bursaSaveModel =
        BursaSaveModel(judul: judul, persyaratan: persyaratan);
    try {
      final res = await _repoUpdate.updateBursa(bursaSaveModel, id);
      if (_streamBursaSave!.isClosed) return;
      bursaSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBursaSave!.isClosed) return;
      bursaSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteBursa() async {
    _streamBursaSave = StreamController();
    final id = _id.value;
    bursaSaveSink.add(ApiResponse.loading('Memuat...'));

    try {
      final res = await _repo.deleteBursa(id);
      if (_streamBursaSave!.isClosed) return;
      bursaSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBursaSave!.isClosed) return;
      bursaSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamBursaSave?.close();
    _id.close();
    _judul.close();
    _persyaratan.close();
  }
}
