import 'package:flutter/material.dart';
import 'package:pemuda_baik/src/blocs/master_kelurahan_bloc.dart';
import 'package:pemuda_baik/src/models/master_kelurahan_model.dart';
import 'package:pemuda_baik/src/pages/widget/error_sheet.dart';
import 'package:pemuda_baik/src/pages/widget/loading_sheet.dart';
import 'package:pemuda_baik/src/pages/widget/search_input_widget.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class ListKelurahanWidget extends StatefulWidget {
  const ListKelurahanWidget({
    Key? key,
    this.selected,
    required this.idKecamatan,
  }) : super(key: key);

  final int? selected;
  final int idKecamatan;

  @override
  State<ListKelurahanWidget> createState() => _ListKelurahanWidgetState();
}

class _ListKelurahanWidgetState extends State<ListKelurahanWidget> {
  final MasterKelurahanBloc _masterKelurahanBloc = MasterKelurahanBloc();

  @override
  void initState() {
    super.initState();
    _masterKelurahanBloc.idKecamatanSink.add(widget.idKecamatan);
    _masterKelurahanBloc.getMasterKelurahanById();
  }

  @override
  void dispose() {
    _masterKelurahanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterKelurahanModel>>(
      stream: _masterKelurahanBloc.masterKelurahanStream,
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
              var data = snapshot.data!.data!.kelurahan!;
              return ListKelurahan(data: data, selected: widget.selected);
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListKelurahan extends StatefulWidget {
  const ListKelurahan({
    Key? key,
    required this.data,
    this.selected,
  }) : super(key: key);

  final List<Kelurahan> data;
  final int? selected;

  @override
  State<ListKelurahan> createState() => _ListKelurahanState();
}

class _ListKelurahanState extends State<ListKelurahan> {
  final _filter = TextEditingController();
  List<Kelurahan> _data = [];

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
          .where((e) => e.namaKelurahan!
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
            'Pilih Kelurahan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.0, right: 22.0, bottom: 22.0),
          child: SearchInputWidget(
            controller: _filter,
            hint: 'Pencarian kelurahan',
            onClear: () => _filter.clear(),
          ),
        ),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 22.0),
            itemBuilder: (context, i) {
              var kelurahan = _data[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
                onTap: () => Navigator.pop(context, kelurahan),
                title: Text('${kelurahan.namaKelurahan}'),
                trailing: widget.selected == kelurahan.id
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
