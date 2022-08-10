import 'dart:async';

import 'package:pemuda_baik/src/models/dashboard_chart_model.dart';
import 'package:pemuda_baik/src/repositories/dashboard_kecamatan_repo.dart';
import 'package:pemuda_baik/src/repositories/dashboard_kelurahan_repo.dart';
import 'package:pemuda_baik/src/repositories/dashboard_pekerjaan_repo.dart';
import 'package:pemuda_baik/src/repositories/dashboard_pendidikan_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class DashboardChartBloc {
  final DashboardPendidikanRepo _repoPendidikan = DashboardPendidikanRepo();
  final DashboardPekerjaanRepo _repoPekerjaan = DashboardPekerjaanRepo();
  final DashboardKecamatanRepo _repoKecamatan = DashboardKecamatanRepo();
  final DashboardKelurahanRepo _repoKelurahan = DashboardKelurahanRepo();
  StreamController<ApiResponse<DashboardChartModel>>? _streamDashboardChart;
  StreamSink<ApiResponse<DashboardChartModel>> get dashboardChartSink =>
      _streamDashboardChart!.sink;
  Stream<ApiResponse<DashboardChartModel>> get dashboardChartStream =>
      _streamDashboardChart!.stream;

  Future<void> getChartPendidikan() async {
    _streamDashboardChart = StreamController();
    dashboardChartSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoPendidikan.getDataPendidikan();
      if (_streamDashboardChart!.isClosed) return;
      dashboardChartSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDashboardChart!.isClosed) return;
      dashboardChartSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getChartPekerjaan() async {
    _streamDashboardChart = StreamController();
    dashboardChartSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoPekerjaan.getDataPekerjaan();
      if (_streamDashboardChart!.isClosed) return;
      dashboardChartSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDashboardChart!.isClosed) return;
      dashboardChartSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getChartKecamatan() async {
    _streamDashboardChart = StreamController();
    dashboardChartSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoKecamatan.getDataKecamatan();
      if (_streamDashboardChart!.isClosed) return;
      dashboardChartSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDashboardChart!.isClosed) return;
      dashboardChartSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getChartKelurahan() async {
    _streamDashboardChart = StreamController();
    dashboardChartSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoKelurahan.getDataKelurahan();
      if (_streamDashboardChart!.isClosed) return;
      dashboardChartSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDashboardChart!.isClosed) return;
      dashboardChartSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamDashboardChart?.close();
  }
}
