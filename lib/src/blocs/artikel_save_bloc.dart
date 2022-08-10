import 'dart:async';

import 'package:pemuda_baik/src/models/artikel_save_model.dart';
import 'package:pemuda_baik/src/repositories/artikel_save_repo.dart';
import 'package:pemuda_baik/src/repositories/artikel_update_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class ArtikelSaveBloc {
  final ArtikelSaveRepo _repo = ArtikelSaveRepo();
  final ArtikelUpdateRepo _repoUpdate = ArtikelUpdateRepo();
  StreamController<ApiResponse<ResponseArtikelSaveModel>>? _streamArtikelSave;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _judul = BehaviorSubject();
  final BehaviorSubject<String> _penulis = BehaviorSubject();
  final BehaviorSubject<String> _artikel = BehaviorSubject();
  final BehaviorSubject<String> _ext = BehaviorSubject();
  final BehaviorSubject<String> _image = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get judulSink => _judul.sink;
  StreamSink<String> get penulisSink => _penulis.sink;
  StreamSink<String> get artikelSink => _artikel.sink;
  StreamSink<String> get extSink => _ext.sink;
  StreamSink<String> get imageSink => _image.sink;
  StreamSink<ApiResponse<ResponseArtikelSaveModel>> get artikelSaveSink =>
      _streamArtikelSave!.sink;
  Stream<ApiResponse<ResponseArtikelSaveModel>> get artikelSaveStream =>
      _streamArtikelSave!.stream;

  Future<void> saveArtikel() async {
    _streamArtikelSave = StreamController();
    final judul = _judul.value;
    final penulis = _penulis.value;
    final artikel = _artikel.value;
    final ext = _ext.value;
    final image = _image.value;
    artikelSaveSink.add(ApiResponse.loading('Memuat...'));
    ArtikelSaveModel artikelSaveModel = ArtikelSaveModel(
      judul: judul,
      penulis: penulis,
      artikel: artikel,
      ext: ext,
      image: image,
    );
    try {
      final res = await _repo.saveArtikel(artikelSaveModel);
      if (_streamArtikelSave!.isClosed) return;
      artikelSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamArtikelSave!.isClosed) return;
      artikelSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateArtikel() async {
    _streamArtikelSave = StreamController();
    final id = _id.value;
    final judul = _judul.value;
    final penulis = _penulis.value;
    final artikel = _artikel.value;
    final ext = _ext.value;
    final image = _image.value;
    artikelSaveSink.add(ApiResponse.loading('Memuat...'));
    ArtikelSaveModel artikelSaveModel = ArtikelSaveModel(
      judul: judul,
      penulis: penulis,
      artikel: artikel,
      ext: ext,
      image: image,
    );
    try {
      final res = await _repoUpdate.updateArtikel(artikelSaveModel, id);
      if (_streamArtikelSave!.isClosed) return;
      artikelSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamArtikelSave!.isClosed) return;
      artikelSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamArtikelSave?.close();
    _id.close();
    _judul.close();
    _penulis.close();
    _artikel.close();
    _image.close();
    _ext.close();
  }
}
