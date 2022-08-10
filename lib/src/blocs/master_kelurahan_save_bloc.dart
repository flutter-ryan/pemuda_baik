import 'dart:async';

import 'package:pemuda_baik/src/models/master_kelurahan_save_model.dart';
import 'package:pemuda_baik/src/repositories/master_kelurahan_save_repo.dart';
import 'package:pemuda_baik/src/repositories/master_kelurahan_update_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterKelurahanSaveBloc {
  final MasterKelurahanSaveRepo _repo = MasterKelurahanSaveRepo();
  final MasterKelurahanUpdateRepo _repoUpdate = MasterKelurahanUpdateRepo();
  StreamController<ApiResponse<ResponseMasterKelurahanSaveModel>>?
      _streamKelurahanSave;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _kecamatan = BehaviorSubject();
  final BehaviorSubject<String> _kelurahan = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<int> get kecamatanSink => _kecamatan.sink;
  StreamSink<String> get kelurahanSink => _kelurahan.sink;
  StreamSink<ApiResponse<ResponseMasterKelurahanSaveModel>>
      get kelurahanSaveSink => _streamKelurahanSave!.sink;
  Stream<ApiResponse<ResponseMasterKelurahanSaveModel>>
      get kelurahanSaveStream => _streamKelurahanSave!.stream;

  Future<void> saveKelurahan() async {
    _streamKelurahanSave = StreamController();
    final kelurahan = _kelurahan.value;
    final kecamatan = _kecamatan.value;
    kelurahanSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterKelurahanSaveModel masterKelurahanSaveModel =
        MasterKelurahanSaveModel(kecamatan: kecamatan, kelurahan: kelurahan);
    try {
      final res = await _repo.saveMasterKelurahan(masterKelurahanSaveModel);
      if (_streamKelurahanSave!.isClosed) return;
      kelurahanSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKelurahanSave!.isClosed) return;
      kelurahanSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateKelurahan() async {
    _streamKelurahanSave = StreamController();
    final id = _id.value;
    final kelurahan = _kelurahan.value;
    final kecamatan = _kecamatan.value;
    kelurahanSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterKelurahanSaveModel masterKelurahanSaveModel =
        MasterKelurahanSaveModel(kecamatan: kecamatan, kelurahan: kelurahan);
    try {
      final res =
          await _repoUpdate.updateKelurahan(masterKelurahanSaveModel, id);
      if (_streamKelurahanSave!.isClosed) return;
      kelurahanSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKelurahanSave!.isClosed) return;
      kelurahanSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _kecamatan.close();
    _kelurahan.close();
    _id.close();
    _streamKelurahanSave?.close();
  }
}
