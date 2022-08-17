import 'dart:async';

import 'package:pemuda_baik/src/models/save_pemuda_model.dart';
import 'package:pemuda_baik/src/repositories/pemuda_save_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class PemudaSaveBloc {
  final PemudaSaveRepo _repo = PemudaSaveRepo();
  StreamController<ApiResponse<ResponseSavePemudaModel>>? _streamSavePemuda;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _nik = BehaviorSubject();
  final BehaviorSubject<String> _nama = BehaviorSubject();
  final BehaviorSubject<String> _tanggalLahir = BehaviorSubject();
  final BehaviorSubject<int> _jenisKelaimn = BehaviorSubject();
  final BehaviorSubject<int> _statusNikah = BehaviorSubject();
  final BehaviorSubject<int> _pekerjaan = BehaviorSubject();
  final BehaviorSubject<int> _pendidikanTerakhir = BehaviorSubject();
  final BehaviorSubject<String> _alamat = BehaviorSubject();
  final BehaviorSubject<String> _nomorHp = BehaviorSubject();
  final BehaviorSubject<String> _agama = BehaviorSubject();
  final BehaviorSubject<int> _kecamatan = BehaviorSubject();
  final BehaviorSubject<int> _kelurahan = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get nikSink => _nik.sink;
  StreamSink<String> get namaSink => _nama.sink;
  StreamSink<String> get tanggalLahirSink => _tanggalLahir.sink;
  StreamSink<int> get jenisKelaminSink => _jenisKelaimn.sink;
  StreamSink<int> get statusNikahSink => _statusNikah.sink;
  StreamSink<int> get pekerjaanSink => _pekerjaan.sink;
  StreamSink<int> get pendidikanTerakhirSink => _pendidikanTerakhir.sink;
  StreamSink<String> get alamatSink => _alamat.sink;
  StreamSink<String> get nomorHpSink => _nomorHp.sink;
  StreamSink<String> get agamaSink => _agama.sink;
  StreamSink<int> get kelurahanSink => _kelurahan.sink;
  StreamSink<int> get kecamatanSink => _kecamatan.sink;

  StreamSink<ApiResponse<ResponseSavePemudaModel>> get savePemudaSink =>
      _streamSavePemuda!.sink;
  Stream<ApiResponse<ResponseSavePemudaModel>> get savePemudaStream =>
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
    final kecamatan = _kecamatan.value;
    final kelurahan = _kelurahan.value;
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
      nomorHp: nomorHp,
      kecamatan: kecamatan,
      kelurahan: kelurahan,
    );
    try {
      final res = await _repo.savePemuda(savePemudaModel);
      if (_streamSavePemuda!.isClosed) return;
      savePemudaSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamSavePemuda!.isClosed) return;
      savePemudaSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updatePemuda() async {
    _streamSavePemuda = StreamController();
    final id = _id.value;
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
    final kecamatan = _kecamatan.value;
    final kelurahan = _kelurahan.value;
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
      nomorHp: nomorHp,
      kecamatan: kecamatan,
      kelurahan: kelurahan,
    );
    try {
      final res = await _repo.updatePemuda(savePemudaModel, id);
      if (_streamSavePemuda!.isClosed) return;
      savePemudaSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamSavePemuda!.isClosed) return;
      savePemudaSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deletePemuda() async {
    _streamSavePemuda = StreamController();
    final id = _id.value;
    savePemudaSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deletePemuda(id);
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
    _kelurahan.close();
    _kecamatan.close();
  }
}
