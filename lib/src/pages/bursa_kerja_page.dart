import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pemuda_baik/src/blocs/bursa_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/bursa_model.dart';
import 'package:pemuda_baik/src/pages/input_bursa_page.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/search_input_widget.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class BursaKerjaPage extends StatefulWidget {
  const BursaKerjaPage({Key? key}) : super(key: key);

  @override
  State<BursaKerjaPage> createState() => _BursaKerjaPageState();
}

class _BursaKerjaPageState extends State<BursaKerjaPage> {
  final BursaBloc _bursaBloc = BursaBloc();
  List<BursaKerja> _data = [];

  @override
  void initState() {
    super.initState();
    _bursaBloc.getBursa();
  }

  @override
  void dispose() {
    _bursaBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bursa Kerja'),
        backgroundColor: kPrimaryDarkColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _bursaBloc.getBursa();
              setState(() {});
            },
            icon: const Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: _streamBursa(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'inputBursa',
        onPressed: () => pushNewScreen(
          context,
          screen: const InputBursaPage(),
          withNavBar: false,
        ).then((value) {
          if (value != null) {
            var data = value as BursaType;
            Fluttertoast.showToast(
              msg: '${data.data.message}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            setState(() {
              _data.insert(0, data.data.data!);
            });
          }
        }),
        backgroundColor: kPrimaryDarkColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _streamBursa() {
    return StreamBuilder<ApiResponse<BursaModel>>(
      stream: _bursaBloc.bursaStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case Status.error:
              return Center(
                child: Errorbox(
                  message: snapshot.data!.message,
                  button: true,
                  onTap: () {
                    _bursaBloc.getBursa();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              _data = snapshot.data!.data!.data!;
              return ListBursa(
                data: _data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListBursa extends StatefulWidget {
  const ListBursa({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<BursaKerja> data;

  @override
  State<ListBursa> createState() => _ListBursaState();
}

class _ListBursaState extends State<ListBursa> {
  final _filter = TextEditingController();
  List<BursaKerja> _data = [];

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
          .where((e) =>
              e.title!.toLowerCase().contains(_filter.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: SearchInputWidget(
            controller: _filter,
            hint: 'Pencarian judul bursa',
            onClear: () {
              _filter.clear();
            },
          ),
        ),
        if (_data.isEmpty)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.warning_rounded,
                  size: 52,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 12,
                ),
                Text('Data tidak ditemukan')
              ],
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(22.0),
              itemBuilder: (context, i) {
                var data = _data[i];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4.0,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InputBursaPage(
                            data: data,
                          ),
                        )).then((value) {
                      if (value != null) {
                        var data = value as BursaType;
                        Fluttertoast.showToast(
                          msg: '${data.data.message}',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        if (data.type == 'update') {
                          setState(() {
                            _data[_data.indexWhere(
                                    (e) => e.id == data.data.data!.id)] =
                                data.data.data!;
                          });
                        } else {
                          setState(() {
                            _data
                                .removeWhere((e) => e.id == data.data.data!.id);
                          });
                        }
                      }
                    }),
                    title: Text('${data.title}'),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                );
              },
              separatorBuilder: (context, id) => const SizedBox(height: 22.0),
              itemCount: _data.length,
            ),
          )
      ],
    );
  }
}
