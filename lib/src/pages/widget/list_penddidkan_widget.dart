import 'package:flutter/material.dart';
import 'package:pemuda_baik/src/blocs/master_pendidikan_bloc.dart';
import 'package:pemuda_baik/src/models/master_pendidikan_model.dart';
import 'package:pemuda_baik/src/pages/widget/error_sheet.dart';
import 'package:pemuda_baik/src/pages/widget/loading_sheet.dart';
import 'package:pemuda_baik/src/pages/widget/search_input_widget.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class ListPendidikanWidget extends StatefulWidget {
  const ListPendidikanWidget({
    Key? key,
    this.selected,
  }) : super(key: key);

  final int? selected;

  @override
  State<ListPendidikanWidget> createState() => _ListPendidikanWidgetState();
}

class _ListPendidikanWidgetState extends State<ListPendidikanWidget> {
  final MasterPendidikanBloc _masterPendidikanBloc = MasterPendidikanBloc();

  @override
  void initState() {
    super.initState();
    _masterPendidikanBloc.getPendidikan();
  }

  @override
  void dispose() {
    _masterPendidikanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterPendidikanModel>>(
      stream: _masterPendidikanBloc.masterPendidikanStream,
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
              var data = snapshot.data!.data!.pendidikan!;
              return ListPendidikan(data: data, selected: widget.selected);
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListPendidikan extends StatefulWidget {
  const ListPendidikan({
    Key? key,
    required this.data,
    this.selected,
  }) : super(key: key);

  final List<Pendidikan> data;
  final int? selected;

  @override
  State<ListPendidikan> createState() => _ListPendidikanState();
}

class _ListPendidikanState extends State<ListPendidikan> {
  final _filter = TextEditingController();
  List<Pendidikan> _data = [];

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
          .where((e) => e.namaPendidikan!
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
            'Pilih Pendidikan Terakhir',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.0, right: 22.0, bottom: 22.0),
          child: SearchInputWidget(
            controller: _filter,
            hint: 'Pencarian pendidikan',
            onClear: () => _filter.clear(),
          ),
        ),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 22.0),
            itemBuilder: (context, i) {
              var pendidikan = _data[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
                onTap: () => Navigator.pop(context, pendidikan),
                title: Text('${pendidikan.namaPendidikan}'),
                trailing: widget.selected == pendidikan.id
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
