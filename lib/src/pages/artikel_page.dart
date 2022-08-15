import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pemuda_baik/src/blocs/artikel_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/artikel_model.dart';
import 'package:pemuda_baik/src/pages/input_artikel_page.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/image_net_widget.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class ArtikelPage extends StatefulWidget {
  const ArtikelPage({Key? key}) : super(key: key);

  @override
  State<ArtikelPage> createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  final ArtikelBloc _artikelBloc = ArtikelBloc();
  List<Artikel> _data = [];

  @override
  void initState() {
    super.initState();
    _artikelBloc.getArtikel();
  }

  @override
  void dispose() {
    _artikelBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel Daerah'),
        backgroundColor: kPrimaryDarkColor,
        actions: [
          IconButton(
            onPressed: () {
              _artikelBloc.getArtikel();
              setState(() {});
            },
            icon: const Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: _streamArtikel(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'inputArtikel',
        onPressed: () => pushNewScreen(
          context,
          screen: const InputArtikelPage(),
          withNavBar: false,
        ).then((value) {
          if (value != null) {
            var data = value as ArtikelType;
            setState(() {
              _data.insert(0, data.data);
            });
          }
        }),
        backgroundColor: kPrimaryDarkColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _streamArtikel() {
    return StreamBuilder<ApiResponse<ArtikelModel>>(
      stream: _artikelBloc.artikelStream,
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
                    _artikelBloc.getArtikel();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              _data = snapshot.data!.data!.artikel!;
              return ListArtikelWidget(
                data: _data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListArtikelWidget extends StatefulWidget {
  const ListArtikelWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<Artikel> data;

  @override
  State<ListArtikelWidget> createState() => _ListArtikelWidgetState();
}

class _ListArtikelWidgetState extends State<ListArtikelWidget> {
  List<Artikel> _data = [];
  final _filter = TextEditingController();
  final DateFormat _tanggal = DateFormat('EEEE, dd MMMM yyyy', 'id');

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
              e.artikel!.toLowerCase().contains(_filter.text.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 22.0),
      itemBuilder: (context, i) {
        var artikel = _data[i];
        return Container(
          constraints: const BoxConstraints(
            maxHeight: 130,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(1.0, 2.0),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => pushNewScreen(
              context,
              screen: InputArtikelPage(data: artikel),
              withNavBar: false,
            ).then((value) {
              if (value != null) {
                var data = value as ArtikelType;
                if (data.type == 'update') {
                  setState(() {
                    _data[_data.indexWhere((e) => e.id == data.data.id)] =
                        data.data;
                  });
                } else {
                  setState(() {
                    _data.removeWhere((e) => e.id == data.data.id);
                  });
                }
              }
            }),
            child: Row(
              children: [
                if (artikel.urlImg == null)
                  Container(
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                    child: Center(
                      child: ImageNetWidget(
                        urlImg: artikel.urlImg!,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              contentPadding: EdgeInsets.zero,
                              title: RichText(
                                overflow: TextOverflow.ellipsis,
                                strutStyle: const StrutStyle(fontSize: 12.0),
                                text: TextSpan(
                                  text: '${artikel.judul}',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                              subtitle: Text('${artikel.penulis}'),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                _tanggal.format(artikel.createdAt!),
                                style: const TextStyle(
                                    fontSize: 11.0, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, i) => const SizedBox(
        height: 18,
      ),
      itemCount: _data.length,
    );
  }
}
