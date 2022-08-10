import 'package:flutter/material.dart';
import 'package:pemuda_baik/src/blocs/master_pekerjaan_bloc.dart';
import 'package:pemuda_baik/src/models/master_pekerjaan_model.dart';
import 'package:pemuda_baik/src/pages/widget/error_sheet.dart';
import 'package:pemuda_baik/src/pages/widget/loading_sheet.dart';
import 'package:pemuda_baik/src/pages/widget/search_input_widget.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class ListPekerjaanWidget extends StatefulWidget {
  const ListPekerjaanWidget({
    Key? key,
    this.selected,
  }) : super(key: key);

  final int? selected;

  @override
  State<ListPekerjaanWidget> createState() => _ListPekerjaanWidgetState();
}

class _ListPekerjaanWidgetState extends State<ListPekerjaanWidget> {
  final MasterPekerjaanBloc _masterPekerjaanBloc = MasterPekerjaanBloc();

  @override
  void initState() {
    super.initState();
    _masterPekerjaanBloc.getPekerjaan();
  }

  @override
  void dispose() {
    _masterPekerjaanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterPekerjaanModel>>(
      stream: _masterPekerjaanBloc.masterPekerjaanStream,
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
              var data = snapshot.data!.data!.pekerjaan!;
              return ListPekerjaan(data: data, selected: widget.selected);
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListPekerjaan extends StatefulWidget {
  const ListPekerjaan({
    Key? key,
    required this.data,
    this.selected,
  }) : super(key: key);

  final List<Pekerjaan> data;
  final int? selected;

  @override
  State<ListPekerjaan> createState() => _ListPekerjaanState();
}

class _ListPekerjaanState extends State<ListPekerjaan> {
  final _filter = TextEditingController();
  List<Pekerjaan> _data = [];

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
          .where((e) => e.namaPekerjaan!
              .toLowerCase()
              .contains(_filter.text.toLowerCase()))
          .toList();
    }
    setState(() {});
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
            'Pilih Pekerjaan',
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
              var pekerjaan = _data[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
                onTap: () => Navigator.pop(context, pekerjaan),
                title: Text('${pekerjaan.namaPekerjaan}'),
                trailing: widget.selected == pekerjaan.id
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
