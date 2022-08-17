import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pemuda_baik/src/blocs/pencarian_pemuda_bloc.dart';
import 'package:pemuda_baik/src/models/pencarian_pemuda_model.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/loading_box.dart';
import 'package:pemuda_baik/src/pages/widget/search_input_widget.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class SearchPemudaPage extends StatefulWidget {
  const SearchPemudaPage({Key? key}) : super(key: key);

  @override
  State<SearchPemudaPage> createState() => _SearchPemudaPageState();
}

class _SearchPemudaPageState extends State<SearchPemudaPage> {
  final PencarianPemudaBloc _pencarianPemudaBloc = PencarianPemudaBloc();
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.length > 1) {
      _pencarianPemudaBloc.filterSink.add(_filter.text);
      _pencarianPemudaBloc.cariPemuda();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _filter.removeListener(_filterListen);
    _filter.dispose();
    _pencarianPemudaBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 18,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: SearchInputWidget(
                    controller: _filter,
                    hint: 'Pencarian nama',
                    onClear: () {
                      _filter.clear();
                    },
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child:
                _filter.text.length < 1 ? const SizedBox() : _streamPencarian(),
          )
        ],
      ),
    );
  }

  Widget _streamPencarian() {
    return StreamBuilder<ApiResponse<ResponsePencarianPemudaModel>>(
      stream: _pencarianPemudaBloc.pencarianPemudaStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingBox(
                message: snapshot.data!.message,
              );
            case Status.error:
              return Errorbox(
                message: snapshot.data!.message,
              );
            case Status.completed:
              return Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hasil pencarian',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        itemBuilder: (context, i) {
                          var data = snapshot.data!.data!.data![i];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                Navigator.pop(context, data);
                              });
                            },
                            title: Text('${data.nama}'),
                            subtitle: Text('${data.nomorKtp}'),
                          );
                        },
                        separatorBuilder: (context, i) => const Divider(),
                        itemCount: snapshot.data!.data!.data!.length,
                      ),
                    ),
                  ],
                ),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
