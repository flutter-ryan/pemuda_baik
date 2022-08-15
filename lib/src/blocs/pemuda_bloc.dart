import 'dart:async';

import 'package:pemuda_baik/src/models/pemuda_page_model.dart';
import 'package:pemuda_baik/src/repositories/pemuda_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class PemudaBloc {
  PemudaPageModel? pemuda;
  int initialPage = 1;
  int nextPage = 1;
  final PemudaRepo _repo = PemudaRepo();
  StreamController<ApiResponse<PemudaPageModel>>? _streamPemuda;
  StreamSink<ApiResponse<PemudaPageModel>> get pemudaSink =>
      _streamPemuda!.sink;
  Stream<ApiResponse<PemudaPageModel>> get pemudaStream =>
      _streamPemuda!.stream;

  Future<void> getPemuda() async {
    _streamPemuda = StreamController();
    pemudaSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPemuda(initialPage);
      if (_streamPemuda!.isClosed) return;
      pemuda = res;
      nextPage = 1;
      pemudaSink.add(ApiResponse.completed(pemuda));
    } catch (e) {
      if (_streamPemuda!.isClosed) return;
      pemudaSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getPagePemuda() async {
    nextPage = nextPage + 1;
    try {
      final res = await _repo.getPemuda(nextPage);
      if (_streamPemuda!.isClosed) return;
      pemuda!.currentPage = nextPage;
      pemuda!.data!.addAll(res.data!);
      pemudaSink.add(ApiResponse.completed(pemuda));
    } catch (e) {
      if (_streamPemuda!.isClosed) return;
      pemudaSink.add(ApiResponse.completed(pemuda));
    }
  }

  dispose() {
    _streamPemuda?.close();
  }
}
