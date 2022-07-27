import 'dart:async';

import 'package:pemuda_baik/src/models/response_model.dart';
import 'package:pemuda_baik/src/models/save_pemuda_model.dart';
import 'package:pemuda_baik/src/repositories/pemuda_save_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class PemudaSaveBloc {
  final PemudaSaveRepo _repo = PemudaSaveRepo();
  StreamController<ApiResponse<ResponseModel>>? _streamSavePemuda;
  final BehaviorSubject<String> _nik = BehaviorSubject();
  final BehaviorSubject<String> _nama = BehaviorSubject();
  final BehaviorSubject<String> _tanggalLahir = BehaviorSubject();
  final BehaviorSubject<int> _jenisKelaimn = BehaviorSubject();
  final BehaviorSubject<int> _statusNikah = BehaviorSubject();
  final BehaviorSubject<int> _pekerjaan = BehaviorSubject();
  final BehaviorSubject<String> _pendidikanTerakhir = BehaviorSubject();
  final BehaviorSubject<String> _alamat = BehaviorSubject();
  final BehaviorSubject<String> _nomorHp = BehaviorSubject();
  final BehaviorSubject<int> _agama = BehaviorSubject();

  StreamSink<String> get nikSink => _nik.sink;
  StreamSink<String> get namaSink => _nama.sink;
  StreamSink<String> get tanggalLahirSink => _tanggalLahir.sink;
  StreamSink<int> get jenisKelaminSink => _jenisKelaimn.sink;
  StreamSink<int> get statusNikahSink => _statusNikah.sink;
  StreamSink<int> get pekerjaanSink => _pekerjaan.sink;
  StreamSink<String> get pendidikanTerakhirSink => _pendidikanTerakhir.sink;
  StreamSink<String> get alamatSink => _alamat.sink;
  StreamSink<String> get nomorHpSink => _nomorHp.sink;
  StreamSink<int> get agamaSink => _agama.sink;

  StreamSink<ApiResponse<ResponseModel>> get savePemudaSink =>
      _streamSavePemuda!.sink;
  Stream<ApiResponse<ResponseModel>> get savePemudaStream =>
      _streamSavePemuda!.stream;

  Future<void> savePemuda() async {
    _streamSavePemuda = StreamController();
    final nik = _nik.value;
    final nama = _nama.value;
    final tanggalLahir = _tanggalLahir.value;
    final jenisKelamin = _jenisKelaimn.value;
    final statusNikah = _statusNikah.value;
    final pekerjaan = _pekerjaan.value;
    final pendidikanTerakhir = _pendidikanTerakhir.value;
    final alamat = _alamat.value;
    final nomorHp = _nomorHp.value;
    final agama = _agama.value;
    savePemudaSink.add(ApiResponse.loading('Memuat...'));
    SavePemudaModel savePemudaModel = SavePemudaModel(
        nik: nik,
        nama: nama,
        tanggalLahir: tanggalLahir,
        jenisKelamin: jenisKelamin,
        statusNikah: statusNikah,
        agama: agama,
        pendidikanTerakhir: pendidikanTerakhir,
        pekerjaan: pekerjaan,
        alamat: alamat,
        nomorHp: nomorHp);
    try {
      final res = await _repo.savePemuda(savePemudaModel);
      if (_streamSavePemuda!.isClosed) return;
      savePemudaSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamSavePemuda!.isClosed) return;
      savePemudaSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _nik.close();
    _nama.close();
    _tanggalLahir.close();
    _jenisKelaimn.close();
    _statusNikah.close();
    _pendidikanTerakhir.close();
    _pekerjaan.close();
    _alamat.close();
    _nomorHp.close();
  }
}
