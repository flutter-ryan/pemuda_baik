import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pemuda_baik/src/blocs/pemuda_bloc.dart';
import 'package:pemuda_baik/src/blocs/pemuda_save_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/config/size_config.dart';
import 'package:pemuda_baik/src/models/pemuda_page_model.dart';
import 'package:pemuda_baik/src/models/save_pemuda_model.dart';
import 'package:pemuda_baik/src/pages/input_pemuda_page.dart';
import 'package:pemuda_baik/src/pages/search_pemuda_page.dart';
import 'package:pemuda_baik/src/pages/widget/confirm_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/error_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/loading_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/success_dialog.dart';
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
              ),
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
}

class ListPemudaWidget extends StatefulWidget {
  const ListPemudaWidget(
      {Key? key, required this.data, required this.scrollController})
      : super(key: key);

  final PemudaPageModel data;
  final ScrollController scrollController;

  @override
  State<ListPemudaWidget> createState() => _ListPemudaWidgetState();
}

class _ListPemudaWidgetState extends State<ListPemudaWidget>
    with AutomaticKeepAliveClientMixin {
  final PemudaSaveBloc _pemudaSaveBloc = PemudaSaveBloc();
  List<PemudaPage> _data = [];
  final DateFormat _tanggal = DateFormat('dd MMMM yyyy', 'id');

  @override
  void initState() {
    super.initState();
    _data = widget.data.data!;
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

  void _deletePemuda(int? id) {
    if (id != null) {
      showAnimatedDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            message: 'Anda yakin menghapus data ini?',
            onConfirm: () => Navigator.pop(context, 'delete'),
          );
        },
        animationType: DialogTransitionType.slideFromBottomFade,
        duration: const Duration(milliseconds: 500),
      ).then((value) {
        if (value != null) {
          _pemudaSaveBloc.idSink.add(id);
          _pemudaSaveBloc.deletePemuda();
          _showStreamDelete();
        }
      });
    }
  }

  void _showStreamDelete() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDelete();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as PemudaPage;
        _data.removeWhere((e) => e.id == data.id);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pemudaSaveBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    super.build(context);
    return ListView.separated(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 32.0),
      itemCount: widget.data.currentPage != widget.data.totalPage
          ? _data.length + 1
          : _data.length,
      itemBuilder: (context, i) {
        if (i == _data.length) {
          return SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.transparent,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(
                  width: 12,
                ),
                Text('Memuat...'),
              ],
            ),
          );
        }
        var pemuda = _data[i];
        return _dataPemuda(pemuda);
      },
      separatorBuilder: (context, i) => const SizedBox(
        height: 22,
      ),
    );
  }

  Container _dataPemuda(PemudaPage pemuda) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pemuda.agama == 'Islam' && pemuda.jenisKelamin == 'Perempuan')
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12.0),
                    image: const DecorationImage(
                      image: AssetImage('images/female.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else if (pemuda.agama != 'Islam' &&
                  pemuda.jenisKelamin == 'Perempuan')
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
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
                      borderRadius: BorderRadius.circular(12.0),
                      image: const DecorationImage(
                        image: AssetImage('images/male.jpg'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 12.0)
                      ]),
                ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _deletePemuda(pemuda.id),
                    color: Colors.red,
                    icon: const Icon(Icons.delete),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  IconButton(
                    onPressed: () => _detailPemuda(pemuda),
                    color: Colors.blue,
                    icon: const Icon(Icons.info_outline_rounded),
                  ),
                ],
              ),
            ],
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
          subtitle: _tanggal.format(data.tanggalLahir!),
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

  Widget _streamDelete() {
    return StreamBuilder<ApiResponse<ResponseSavePemudaModel>>(
      stream: _pemudaSaveBloc.savePemudaStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingDialog(
                message: snapshot.data!.message,
              );
            case Status.error:
              return ErrorDialog(
                message: snapshot.data!.message,
              );
            case Status.completed:
              return SuccessDialog(
                message: snapshot.data!.data!.message,
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        Text(subtitle)
      ],
    );
  }
}
