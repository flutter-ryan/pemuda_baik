import 'dart:async';

import 'package:pemuda_baik/src/models/pencarian_pemuda_model.dart';
import 'package:pemuda_baik/src/repositories/pencarian_pemuda_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PencarianPemudaBloc {
  final PencarianPemudaRepo _repo = PencarianPemudaRepo();
  StreamController<ApiResponse<ResponsePencarianPemudaModel>>?
      _streamPencarianPemuda;
  final BehaviorSubject<String> _filter = BehaviorSubject();
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<ResponsePencarianPemudaModel>>
      get pencarianPemudaSink => _streamPencarianPemuda!.sink;
  Stream<ApiResponse<ResponsePencarianPemudaModel>> get pencarianPemudaStream =>
      _streamPencarianPemuda!.stream;
  Future<void> cariPemuda() async {
    _streamPencarianPemuda = StreamController();
    final filter = _filter.value;
    pencarianPemudaSink.add(ApiResponse.loading('Memuat...'));
    PencarianPemudaModel pencarianPemudaModel =
        PencarianPemudaModel(filter: filter);
    try {
      final res = await _repo.cariPemuda(pencarianPemudaModel);
      if (_streamPencarianPemuda!.isClosed) return;
      pencarianPemudaSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPencarianPemuda!.isClosed) return;
      pencarianPemudaSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPencarianPemuda?.close();
    _filter.close();
  }
}
