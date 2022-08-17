import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pemuda_baik/src/blocs/pemuda_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/config/size_config.dart';
import 'package:pemuda_baik/src/models/pemuda_page_model.dart';
import 'package:pemuda_baik/src/pages/input_pemuda_page.dart';
import 'package:pemuda_baik/src/pages/search_pemuda_page.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/list_pemuda_widget.dart';
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
  final DateFormat _tanggal = DateFormat('dd MMMM yyyy', 'id');
  bool _show = true;
  PemudaPageModel? _pemuda;

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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _pemudaBloc.getPagePemuda();
    }
  }

  void _detailPemuda(PemudaPage data) {
    showBarModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: SizeConfig.blockSizeVertical * 82,
          ),
          child: _detailPemudaWidget(data),
        );
      },
    );
  }

  void _inputPemudaForm() {
    pushNewScreen(
      context,
      screen: const InputPemudaPage(),
      withNavBar: false,
    ).then((value) {
      if (value != null) {
        var pemuda = value as PemudaPage;
        setState(() {
          _pemuda!.data!.insert(0, pemuda);
        });
      }
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
          actions: [
            IconButton(
              onPressed: () => pushNewScreen(
                context,
                screen: const SearchPemudaPage(),
                withNavBar: false,
              ).then((value) {
                if (value != null) {
                  var data = value as PemudaPage;
                  Future.delayed(const Duration(milliseconds: 400), () {
                    _detailPemuda(data);
                  });
                }
              }),
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                _pemudaBloc.getPemuda();
                setState(() {});
              },
              icon: const Icon(Icons.refresh_rounded),
            )
          ],
        ),
        floatingActionButton: Visibility(
          visible: _show,
          child: FloatingActionButton(
            heroTag: 'inputPemuda',
            onPressed: _inputPemudaForm,
            backgroundColor: kPrimaryDarkColor,
            child: const Icon(Icons.add_rounded),
          ),
        ),
        body: _streamPemuda(),
      ),
    );
  }

  Widget _streamPemuda() {
    return StreamBuilder<ApiResponse<PemudaPageModel>>(
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
              return Center(
                child: Errorbox(
                  message: snapshot.data!.message,
                  button: true,
                  onTap: () {
                    _pemudaBloc.getPemuda();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              _pemuda = snapshot.data!.data!;
              return ListPemudaWidget(
                data: _pemuda!,
                scrollController: _scrollController,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _detailPemudaWidget(PemudaPage data) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 32),
      children: [
        const Text(
          'Identitas Pemuda',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const Divider(
          height: 42.0,
        ),
        TileIdentitas(
          title: "NIK",
          subtitle: '${data.nomorKtp}',
        ),
        const SizedBox(
          height: 8.0,
        ),
        TileIdentitas(
          title: "Nama",
          subtitle: '${data.nama}',
        ),
        const SizedBox(
          height: 8.0,
        ),
        TileIdentitas(
          title: "Tanggal Lahir",
          subtitle: _tanggal.format(DateTime.parse(data.tanggalLahir!)),
        ),
        const SizedBox(
          height: 8.0,
        ),
        TileIdentitas(
          title: "Jenis Kelamin",
          subtitle: "${data.jenisKelamin}",
        ),
        const SizedBox(
          height: 8.0,
        ),
        TileIdentitas(
          title: "Status",
          subtitle: "${data.statusNikah}",
        ),
        const SizedBox(
          height: 8.0,
        ),
        TileIdentitas(
          title: "Agama",
          subtitle: "${data.agama}",
        ),
        const SizedBox(
          height: 8.0,
        ),
        TileIdentitas(
          title: "Alamat",
          subtitle: "${data.alamat}",
        ),
        const SizedBox(
          height: 8.0,
        ),
        TileIdentitas(
          title: "Pendidikan Terakhir",
          subtitle: "${data.pendidikan!.namaPendidikan}",
        ),
        const SizedBox(
          height: 8.0,
        ),
        TileIdentitas(
          title: "Pekerjaan",
          subtitle: "${data.pekerjaan!.namaPekerjaan}",
        ),
        const SizedBox(
          height: 8.0,
        ),
        TileIdentitas(
          title: "Nomor Hp",
          subtitle: '${data.nomorKontak}',
        ),
        const SizedBox(
          height: 8.0,
        ),
        TileIdentitas(
          title: "Kecamatan",
          subtitle: '${data.kecamatan!.namaKecamatan}',
        ),
        const SizedBox(
          height: 8.0,
        ),
        TileIdentitas(
          title: "Kelurahan",
          subtitle: '${data.kelurahan!.namaKelurahan}',
        ),
      ],
    );
  }
}
