import 'package:pemuda_baik/src/models/dashboard_chart_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class DashboardKecamatanRepo {
  Future<DashboardChartModel> getDataKecamatan() async {
    final response = await dio.get('/v1/dashboard/kecamatan');
    return dashboardChartModelFromJson(response);
  }
}
