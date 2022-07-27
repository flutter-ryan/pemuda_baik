import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pemuda_baik/src/blocs/artikel_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/artikel_model.dart';
import 'package:pemuda_baik/src/pages/input_artikel_page.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class ArtikelPage extends StatefulWidget {
  const ArtikelPage({Key? key}) : super(key: key);

  @override
  State<ArtikelPage> createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  final ArtikelBloc _artikelBloc = ArtikelBloc();

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
        centerTitle: true,
      ),
      body: _streamArtikel(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'inputArtikel',
        onPressed: () => pushNewScreen(context,
            screen: const InputArtikelPage(), withNavBar: false),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                      size: 52,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(snapshot.data!.message)
                  ],
                ),
              );
            case Status.completed:
              return ListArtikelWidget(
                data: snapshot.data!.data!.artikel!,
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
            onTap: () {},
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('${artikel.urlImg}'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0))),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('${artikel.judul}'),
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
