import 'package:flutter/material.dart';
import 'package:pemuda_baik/src/blocs/master_kecmatan_bloc.dart';
import 'package:pemuda_baik/src/models/master_kecamatan_model.dart';
import 'package:pemuda_baik/src/pages/widget/error_sheet.dart';
import 'package:pemuda_baik/src/pages/widget/loading_sheet.dart';
import 'package:pemuda_baik/src/pages/widget/search_input_widget.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class ListKecamatanWidget extends StatefulWidget {
  const ListKecamatanWidget({
    Key? key,
    this.selected,
  }) : super(key: key);

  final int? selected;

  @override
  State<ListKecamatanWidget> createState() => _ListKecamatanWidgetState();
}

class _ListKecamatanWidgetState extends State<ListKecamatanWidget> {
  final MasterKecamatanBloc _masterKecamatanBloc = MasterKecamatanBloc();

  @override
  void initState() {
    super.initState();
    _masterKecamatanBloc.getKecamatan();
  }

  @override
  void dispose() {
    _masterKecamatanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterKecamatanModel>>(
      stream: _masterKecamatanBloc.masterKecamatanStream,
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
              );
            case Status.completed:
              var data = snapshot.data!.data!.kecamatan!;
              return ListKecamatan(
                data: data,
                selected: widget.selected,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListKecamatan extends StatefulWidget {
  const ListKecamatan({
    Key? key,
    required this.data,
    this.selected,
  }) : super(key: key);

  final List<Kecamatan> data;
  final int? selected;

  @override
  State<ListKecamatan> createState() => _ListKecamatanState();
}

class _ListKecamatanState extends State<ListKecamatan> {
  final _filter = TextEditingController();
  List<Kecamatan> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      _data = widget.data;
    } else {
      _data = widget.data
          .where((e) => e.namaKecamatan!
              .toLowerCase()
              .contains(_filter.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _filter.dispose();
    _filter.removeListener(_filterListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(22.0),
          child: Text(
            'Pilih Kecamatan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.0, right: 22.0, bottom: 22.0),
          child: SearchInputWidget(
            controller: _filter,
            hint: 'Pencarian pekerjaan',
            onClear: () => _filter.clear(),
          ),
        ),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 22.0),
            itemBuilder: (context, i) {
              var kecamatan = _data[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
                onTap: () => Navigator.pop(context, kecamatan),
                title: Text('${kecamatan.namaKecamatan}'),
                trailing: widget.selected == kecamatan.id
                    ? const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.green,
                      )
                    : null,
              );
            },
            separatorBuilder: (context, i) => const Divider(
              height: 0,
            ),
            itemCount: _data.length,
          ),
        ),
      ],
    );
  }
}
