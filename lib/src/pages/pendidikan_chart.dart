import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pemuda_baik/src/blocs/dashboard_chart_bloc.dart';
import 'package:pemuda_baik/src/blocs/kecamatan_pendidikan_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/config/size_config.dart';
import 'package:pemuda_baik/src/models/dashboard_chart_model.dart';
import 'package:pemuda_baik/src/models/kecamatan_pendidikan_model.dart';
import 'package:pemuda_baik/src/models/pemuda_page_model.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/error_sheet.dart';
import 'package:pemuda_baik/src/pages/widget/loading_box.dart';
import 'package:pemuda_baik/src/pages/widget/loading_sheet.dart';
import 'package:pemuda_baik/src/pages/widget/tab_detail.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:pie_chart/pie_chart.dart';

class PendidikanChart extends StatefulWidget {
  const PendidikanChart({
    Key? key,
  }) : super(key: key);

  @override
  State<PendidikanChart> createState() => _PendidikanChartState();
}

class _PendidikanChartState extends State<PendidikanChart>
    with AutomaticKeepAliveClientMixin {
  final DashboardChartBloc bloc = DashboardChartBloc();
  List<JenisData> _data = [];

  @override
  void initState() {
    super.initState();
    bloc.getChartPendidikan();
  }

  void _detail() {
    showBarModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return _buildDetail();
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig().init(context);
    return Container(
      width: double.infinity,
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
            children: [
              const Expanded(
                child: Text(
                  "Pendidikan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                onPressed: () {
                  bloc.getChartPendidikan();
                  setState(() {});
                },
                color: Colors.blue,
                icon: const Icon(Icons.refresh_rounded),
              ),
              IconButton(
                onPressed: _detail,
                color: Colors.blue,
                icon: const Icon(Icons.info_outline_rounded),
              )
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
      stream: bloc.dashboardChartStream,
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
                    bloc.getChartPendidikan();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              var data = snapshot.data!.data!.data!;
              _data = data;
              return DataChart(data: data);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildDetail() {
    return Container(
      constraints: BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 95),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 22.0),
            child: Text(
              'Detail Pendidikan Per Kecamatan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Flexible(
            child: TabDetail(
              data: _data,
              tabBarView: _data
                  .map(
                    (e) => DetailKecamatan(
                      id: e.id!,
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
      dataMap[data.nama!] = data.jumlah!.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 52,
        chartRadius: MediaQuery.of(context).size.width / 1.3,
        colorList: _colorList,
        initialAngleInDegree: 45,
        ringStrokeWidth: 45,
        chartType: ChartType.ring,
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.bottom,
          showLegends: true,
          legendShape: BoxShape.rectangle,
          legendTextStyle: TextStyle(
            fontSize: 13.0,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 0,
          chartValueStyle: TextStyle(fontSize: 12.0, color: Colors.black),
        ),
      ),
    );
  }
}

class DetailKecamatan extends StatefulWidget {
  const DetailKecamatan({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<DetailKecamatan> createState() => _DetailKecamatanState();
}

class _DetailKecamatanState extends State<DetailKecamatan> {
  final ScrollController _controller = ScrollController();
  final KecamatanPendidikanBloc _kecamatanPendidikanBloc =
      KecamatanPendidikanBloc();

  @override
  void initState() {
    super.initState();
    _kecamatanPendidikanBloc.idSink.add(widget.id);
    _kecamatanPendidikanBloc.getKecamatanPendidikan();
  }

  void _detailPemuda(List<PemudaPage>? pemuda) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _detailPemudaDialog(pemuda);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _kecamatanPendidikanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<KecamatanPendidikanModel>>(
      stream: _kecamatanPendidikanBloc.kecamatanPendidikanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingSheet(
                message: snapshot.data!.message,
              );
            case Status.error:
              return ErrorSheet(
                message: snapshot.data!.message,
                button: false,
              );
            case Status.completed:
              return ListView.separated(
                controller: _controller,
                padding: const EdgeInsets.all(18.0),
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  var data = snapshot.data!.data!.data![i];
                  return ListTile(
                    onTap: () => data.pemuda!.isNotEmpty
                        ? _detailPemuda(data.pemuda)
                        : null,
                    title: Text('${data.namaKecamatan}'),
                    trailing: Text(
                      '${data.jumlah} org',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kPrimaryDarkColor,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, i) => const Divider(
                  height: 8.0,
                ),
                itemCount: snapshot.data!.data!.data!.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _detailPemudaDialog(List<PemudaPage>? pemuda) {
    return Dialog(
      child: Container(
        constraints:
            BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Data Pemuda',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 0.0, bottom: 22.0),
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  var data = pemuda![i];
                  return ListTile(
                    title: Text('${data.nama} (${data.umur})'),
                    subtitle: Text(
                        '${data.jenisKelamin}, ${data.pekerjaan!.namaPekerjaan}'),
                  );
                },
                itemCount: pemuda!.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
