import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pemuda_baik/src/blocs/pemuda_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/pemuda_model.dart';
import 'package:pemuda_baik/src/pages/input_pemuda_page.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class Datapage extends StatefulWidget {
  const Datapage({Key? key}) : super(key: key);

  @override
  State<Datapage> createState() => _DatapageState();
}

class _DatapageState extends State<Datapage> {
  final PemudaBloc _pemudaBloc = PemudaBloc();
  final ScrollController _scrollController = ScrollController();
  bool _show = true;

  @override
  void initState() {
    super.initState();
    _pemudaBloc.getPemuda();
    _scrollController.addListener(_scrollListen);
  }

  void _scrollListen() {
    setState(() {
      _show = _scrollController.position.userScrollDirection ==
          ScrollDirection.forward;
    });
  }

  @override
  void dispose() {
    _pemudaBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPrimaryDarkColor,
          title: const Text('Data Pemuda'),
          centerTitle: true,
        ),
        floatingActionButton: Visibility(
          visible: _show,
          child: FloatingActionButton(
            heroTag: 'inputPemuda',
            onPressed: () => pushNewScreen(
              context,
              screen: const InputPemudaPage(),
              withNavBar: false,
            ),
            backgroundColor: kPrimaryDarkColor,
            child: const Icon(Icons.add_rounded),
          ),
        ),
        body: _streamPemuda(),
      ),
    );
  }

  Widget _streamPemuda() {
    return StreamBuilder<ApiResponse<PemudaModel>>(
      stream: _pemudaBloc.pemudaStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(snapshot.data!.message)
                  ],
                ),
              );
            case Status.error:
              return Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      size: 52,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      snapshot.data!.message,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 16.0),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              );
            case Status.completed:
              return ListPemudaWidget(
                data: snapshot.data!.data!.pemuda!,
                scrollController: _scrollController,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListPemudaWidget extends StatefulWidget {
  const ListPemudaWidget(
      {Key? key, required this.data, required this.scrollController})
      : super(key: key);

  final List<Pemuda> data;
  final ScrollController scrollController;

  @override
  State<ListPemudaWidget> createState() => _ListPemudaWidgetState();
}

class _ListPemudaWidgetState extends State<ListPemudaWidget>
    with AutomaticKeepAliveClientMixin {
  final _filter = TextEditingController();
  List<Pemuda> _data = [];
  final DateFormat _tanggal = DateFormat('dd MMMM yyyy', 'id');

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
          .where(
              (e) => e.nama!.toLowerCase().contains(_filter.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
          child: TextField(
            controller: _filter,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              hintText: 'Pencarian nama pemuda',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _filter.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => _filter.clear(),
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 22.0,
                      ),
                    ),
            ),
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
                  height: 12.0,
                ),
                Text(
                  'Data pemuda tidak ditemukan',
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              controller: widget.scrollController,
              padding: const EdgeInsets.all(15.0),
              itemCount: _data.length,
              itemBuilder: (context, i) {
                var pemuda = _data[i];
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 22.0, horizontal: 18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(2.0, 2.0),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pemuda.agama == 'Islam' && pemuda.jenisKelamin == 2)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4.0),
                              image: const DecorationImage(
                                image: AssetImage('images/female.jpg'),
                                fit: BoxFit.cover,
                              )),
                        )
                      else if (pemuda.agama != 'Islam' &&
                          pemuda.jenisKelamin == 2)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4.0),
                              image: const DecorationImage(
                                image: AssetImage('images/female2.jpeg'),
                                fit: BoxFit.cover,
                              )),
                        )
                      else
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.0),
                            image: const DecorationImage(
                              image: AssetImage('images/male.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TileIdentitas(
                              title: "NIK",
                              subtitle: '${pemuda.nomorKtp}',
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            TileIdentitas(
                              title: "Nama",
                              subtitle: '${pemuda.nama}',
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            TileIdentitas(
                              title: "Tanggal Lahir",
                              subtitle: _tanggal.format(pemuda.tanggalLahir!),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            TileIdentitas(
                              title: "Agama",
                              subtitle: '${pemuda.agama}',
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            TileIdentitas(
                              title: "Jenis kelamin",
                              subtitle: pemuda.jenisKelamin == 1
                                  ? 'Laki-laki'
                                  : 'Perempuan',
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            TileIdentitas(
                              title: "Status Pernikahan",
                              subtitle: pemuda.statusNikah == 1
                                  ? 'Nikah'
                                  : 'Belum nikah',
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            TileIdentitas(
                              title: "Status Pekerjaan",
                              subtitle: pemuda.statusNikah == 1
                                  ? 'Bekerja'
                                  : 'Belum bekerja',
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            TileIdentitas(
                              title: "Alamat",
                              subtitle: "${pemuda.alamat}",
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            TileIdentitas(
                              title: "Nomor Hp",
                              subtitle: '${pemuda.nomorKontak}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, i) => const SizedBox(
                height: 22,
              ),
            ),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TileIdentitas extends StatelessWidget {
  const TileIdentitas({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 2.0,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        Text(subtitle),
      ],
    );
  }
}
