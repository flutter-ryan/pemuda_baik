import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pemuda_baik/src/blocs/dashboard_chart_bloc.dart';
import 'package:pemuda_baik/src/models/dashboard_chart_model.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/loading_box.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:pie_chart/pie_chart.dart';

class PekerjaanChart extends StatefulWidget {
  const PekerjaanChart({
    Key? key,
  }) : super(key: key);

  @override
  State<PekerjaanChart> createState() => _PekerjaanChartState();
}

class _PekerjaanChartState extends State<PekerjaanChart> {
  final DashboardChartBloc _dashboardChartBloc = DashboardChartBloc();
  @override
  void initState() {
    super.initState();
    _dashboardChartBloc.getChartPekerjaan();
  }

  @override
  void dispose() {
    _dashboardChartBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(2.0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pekerjaan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextButton(
                  onPressed: () {
                    _dashboardChartBloc.getChartPekerjaan();
                    setState(() {});
                  },
                  child:
                      const Text('Perbarui', style: TextStyle(fontSize: 12.0)))
            ],
          ),
          const SizedBox(
            height: 22.0,
          ),
          _streamDataChart(),
        ],
      ),
    );
  }

  Widget _streamDataChart() {
    return StreamBuilder<ApiResponse<DashboardChartModel>>(
      stream: _dashboardChartBloc.dashboardChartStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Center(
                child: LoadingBox(
                  message: snapshot.data!.message,
                ),
              );
            case Status.error:
              return Center(
                child: Errorbox(
                  message: snapshot.data!.message,
                  button: true,
                  onTap: () {
                    _dashboardChartBloc.getChartPekerjaan();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return DataChart(data: snapshot.data!.data!.data!);
          }
        }
        return const SizedBox();
      },
    );
  }
}

class DataChart extends StatefulWidget {
  const DataChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<JenisData> data;

  @override
  State<DataChart> createState() => _DataChartState();
}

class _DataChartState extends State<DataChart> {
  Map<String, double> dataMap = {};
  final List<Color> _colorList = [];
  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() {
    for (var data in widget.data) {
      _colorList
          .add(Colors.primaries[Random().nextInt(Colors.primaries.length)]);
      dataMap[data.nama!] = data.dataPemuda!.length.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 12.0),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 42,
        chartRadius: MediaQuery.of(context).size.width / 3,
        colorList: _colorList,
        initialAngleInDegree: 0,
        ringStrokeWidth: 45,
        chartType: ChartType.ring,
        legendOptions: const LegendOptions(
          showLegendsInRow: true,
          legendPosition: LegendPosition.bottom,
          showLegends: true,
          legendShape: BoxShape.rectangle,
          legendTextStyle: TextStyle(
            fontSize: 14.0,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 0,
        ),
      ),
    );
  }
}
