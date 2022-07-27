import 'dart:async';

import 'package:pemuda_baik/src/models/master_kecamatan_save_model.dart';
import 'package:pemuda_baik/src/repositories/masetr_kecamatan_update_repo.dart';
import 'package:pemuda_baik/src/repositories/master_kecamatan_save_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterKecamatanSaveBloc {
  final MasterKecamatanSaveRepo _repo = MasterKecamatanSaveRepo();
  final MasterKecamatanUpdateRepo _repoUpdate = MasterKecamatanUpdateRepo();
  StreamController<ApiResponse<ResponseMasterKecamatanSaveModel>>?
      _streamKecamatanSave;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _kecamatan = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get kecamatanSink => _kecamatan.sink;
  StreamSink<ApiResponse<ResponseMasterKecamatanSaveModel>>
      get kecamataSaveSink => _streamKecamatanSave!.sink;
  Stream<ApiResponse<ResponseMasterKecamatanSaveModel>>
      get kecamataSaveStream => _streamKecamatanSave!.stream;

  Future<void> saveKecamatan() async {
    _streamKecamatanSave = StreamController();
    final kecamatan = _kecamatan.value;
    kecamataSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterKecamatanSaveModel masterKecamatanSaveModel =
        MasterKecamatanSaveModel(kecamatan: kecamatan);
    try {
      final res = await _repo.saveKecamatan(masterKecamatanSaveModel);
      if (_streamKecamatanSave!.isClosed) return;
      kecamataSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKecamatanSave!.isClosed) return;
      kecamataSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateKecamatan() async {
    _streamKecamatanSave = StreamController();
    final id = _id.value;
    final kecamatan = _kecamatan.value;
    kecamataSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterKecamatanSaveModel masterKecamatanSaveModel =
        MasterKecamatanSaveModel(kecamatan: kecamatan);
    try {
      final res =
          await _repoUpdate.updateKecamatan(masterKecamatanSaveModel, id);
      if (_streamKecamatanSave!.isClosed) return;
      kecamataSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKecamatanSave!.isClosed) return;
      kecamataSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _kecamatan.close();
    _id.close();
    _streamKecamatanSave?.close();
  }
}
