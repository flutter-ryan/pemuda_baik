import 'dart:async';

import 'package:pemuda_baik/src/models/master_pendidikan_save_model.dart';
import 'package:pemuda_baik/src/repositories/master_pendidikan_save_repo.dart';
import 'package:pemuda_baik/src/repositories/master_pendidikan_update_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterPendidikanSaveBloc {
  final MasterPendidikanSaveRepo _repo = MasterPendidikanSaveRepo();
  final MasterPendidikanUpdateRepo _repoUpdate = MasterPendidikanUpdateRepo();
  StreamController<ApiResponse<ResponseMasterPendidikanSaveModel>>?
      _streamPendidikanSave;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _pendidikan = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get pendidikanSink => _pendidikan.sink;
  StreamSink<ApiResponse<ResponseMasterPendidikanSaveModel>>
      get pendidikanSaveSink => _streamPendidikanSave!.sink;
  Stream<ApiResponse<ResponseMasterPendidikanSaveModel>>
      get pendidikanSaveStream => _streamPendidikanSave!.stream;

  Future<void> savePendidikan() async {
    _streamPendidikanSave = StreamController();
    final pendidikan = _pendidikan.value;
    pendidikanSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterPendidikanSaveModel masterPendidikanSaveModel =
        MasterPendidikanSaveModel(pendidikan: pendidikan);
    try {
      final res = await _repo.savePendidikan(masterPendidikanSaveModel);
      if (_streamPendidikanSave!.isClosed) return;
      pendidikanSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPendidikanSave!.isClosed) return;
      pendidikanSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updatePendidikan() async {
    _streamPendidikanSave = StreamController();
    final id = _id.value;
    final pendidikan = _pendidikan.value;
    pendidikanSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterPendidikanSaveModel masterPendidikanSaveModel =
        MasterPendidikanSaveModel(pendidikan: pendidikan);
    try {
      final res =
          await _repoUpdate.updatePendidikan(masterPendidikanSaveModel, id);
      if (_streamPendidikanSave!.isClosed) return;
      pendidikanSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPendidikanSave!.isClosed) return;
      pendidikanSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPendidikanSave?.close();
    _id.close();
    _pendidikan.close();
  }
}
