import 'package:flutter/material.dart';
import 'package:pemuda_baik/src/blocs/master_kecmatan_bloc.dart';
import 'package:pemuda_baik/src/models/master_kecamatan_model.dart';
import 'package:pemuda_baik/src/pages/widget/error_sheet.dart';
import 'package:pemuda_baik/src/pages/widget/loading_sheet.dart';
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
  List<Kecamatan> _data = [];

  @override
  void initState() {
    super.initState();
    _masterKecamatanBloc.getKecamatan();
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
              _data = snapshot.data!.data!.kecamatan!;
              return _listKecamatan(_data);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _listKecamatan(List<Kecamatan>? data) {
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
        ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 22.0),
          itemBuilder: (context, i) {
            var kecamatan = data![i];
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
          itemCount: data!.length,
        ),
      ],
    );
  }
}
