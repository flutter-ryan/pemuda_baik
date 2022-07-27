import 'dart:async';

import 'package:pemuda_baik/src/models/artikel_model.dart';
import 'package:pemuda_baik/src/repositories/artikel_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class ArtikelBloc {
  final ArtikelRepo _repo = ArtikelRepo();
  StreamController<ApiResponse<ArtikelModel>>? _streamArtikel;
  StreamSink<ApiResponse<ArtikelModel>> get artikelSink => _streamArtikel!.sink;
  Stream<ApiResponse<ArtikelModel>> get artikelStream => _streamArtikel!.stream;

  Future<void> getArtikel() async {
    _streamArtikel = StreamController();
    artikelSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getArtikel();
      if (_streamArtikel!.isClosed) return;
      artikelSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamArtikel!.isClosed) return;
      artikelSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamArtikel?.close();
  }
}
