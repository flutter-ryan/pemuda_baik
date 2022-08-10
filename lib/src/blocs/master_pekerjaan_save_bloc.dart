import 'dart:async';

import 'package:pemuda_baik/src/models/master_pekerjaan_save_model.dart';
import 'package:pemuda_baik/src/repositories/master_pekerjaan_save_repo.dart';
import 'package:pemuda_baik/src/repositories/master_pekerjaan_update_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterPekerjaanSaveBloc {
  final MasterPekerjaanSaveRepo _repo = MasterPekerjaanSaveRepo();
  final MasterPekerjaanUpdateRepo _repoUpdate = MasterPekerjaanUpdateRepo();
  StreamController<ApiResponse<ResponseMasterPekerjaanSaveModel>>?
      _streamPekerjaanSave;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _pekerjaan = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get pekerjaanSink => _pekerjaan.sink;
  StreamSink<ApiResponse<ResponseMasterPekerjaanSaveModel>>
      get pekerjaanSaveSink => _streamPekerjaanSave!.sink;
  Stream<ApiResponse<ResponseMasterPekerjaanSaveModel>>
      get pekerjaanSaveStream => _streamPekerjaanSave!.stream;

  Future<void> savePekerjaan() async {
    _streamPekerjaanSave = StreamController();
    final pekerjaan = _pekerjaan.value;
    pekerjaanSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterPekerjaanSaveModel masterPekerjaanSaveModel =
        MasterPekerjaanSaveModel(pekerjaan: pekerjaan);
    try {
      final res = await _repo.savePekerjaan(masterPekerjaanSaveModel);
      if (_streamPekerjaanSave!.isClosed) return;
      pekerjaanSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPekerjaanSave!.isClosed) return;
      pekerjaanSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updatePekerjaan() async {
    _streamPekerjaanSave = StreamController();
    final id = _id.value;
    final pekerjaan = _pekerjaan.value;
    pekerjaanSaveSink.add(ApiResponse.loading('Memauat...'));
    MasterPekerjaanSaveModel masterPekerjaanSaveModel =
        MasterPekerjaanSaveModel(pekerjaan: pekerjaan);
    try {
      final res =
          await _repoUpdate.updatePekerjaan(masterPekerjaanSaveModel, id);
      if (_streamPekerjaanSave!.isClosed) return;
      pekerjaanSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPekerjaanSave!.isClosed) return;
      pekerjaanSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPekerjaanSave?.close();
    _id.close();
    _pekerjaan.close();
  }
}
