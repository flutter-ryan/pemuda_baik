import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pemuda_baik/src/blocs/master_kelurahan_bloc.dart';
import 'package:pemuda_baik/src/blocs/master_kelurahan_delete_bloc.dart';
import 'package:pemuda_baik/src/blocs/master_kelurahan_save_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/master_kecamatan_model.dart';
import 'package:pemuda_baik/src/models/master_kelurahan_model.dart';
import 'package:pemuda_baik/src/models/master_kelurahan_save_model.dart';
import 'package:pemuda_baik/src/pages/widget/confirm_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/error_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';
import 'package:pemuda_baik/src/pages/widget/list_kecamatan_widget.dart';
import 'package:pemuda_baik/src/pages/widget/loading_box.dart';
import 'package:pemuda_baik/src/pages/widget/loading_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/search_input_widget.dart';
import 'package:pemuda_baik/src/pages/widget/success_dialog.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class KelurahanPage extends StatefulWidget {
  const KelurahanPage({Key? key}) : super(key: key);

  @override
  State<KelurahanPage> createState() => _KelurahanPageState();
}

class _KelurahanPageState extends State<KelurahanPage> {
  final MasterKelurahanSaveBloc _masterKelurahanSaveBloc =
      MasterKelurahanSaveBloc();

  final MasterKelurahanBloc _masterKelurahanBloc = MasterKelurahanBloc();
  final MasterKelurahanDeleteBloc _masterKelurahanDeleteBloc =
      MasterKelurahanDeleteBloc();
  final _kecamatan = TextEditingController();
  final _kelurahan = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Kelurahan> _data = [];
  int? _selectedKecamatan;

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _showKecamatan() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListKecamatanWidget(
            selected: _selectedKecamatan,
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as Kecamatan;
        _kecamatan.text = '${data.namaKecamatan}';
        setState(() {
          _selectedKecamatan = data.id;
        });
      }
    });
  }

  void _tambah() {
    _kecamatan.clear();
    _kelurahan.clear();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _formKelurahan('create', null),
        );
      },
    );
  }

  void _simpan() {
    if (validateAndSave()) {
      Navigator.pop(context);
      _masterKelurahanSaveBloc.kecamatanSink.add(_selectedKecamatan!);
      _masterKelurahanSaveBloc.kelurahanSink.add(_kelurahan.text);
      _masterKelurahanSaveBloc.saveKelurahan();
      _streamSaveDialog('create');
    }
  }

  void _streamSaveDialog(String saveMethod) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDialog();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        if (_data.isEmpty) {
          _masterKelurahanBloc.getMasterKelurahan();
        } else {
          if (saveMethod == 'edit') {
            var data = value as Kelurahan;
            _data[_data.indexWhere((e) => e.id == data.id)] = data;
          } else {
            var data = value as Kelurahan;
            _data.insert(0, data);
          }
        }
        setState(() {});
      }
    });
  }

  void _edit(Kelurahan data) {
    _selectedKecamatan = data.kecamatan!.id;
    _kecamatan.text = '${data.kecamatan!.namaKecamatan}';
    _kelurahan.text = '${data.namaKelurahan}';
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _formKelurahan('edit', data.id),
        );
      },
    ).then((value) {
      if (value != null) {
        var id = value as int;
        _masterKelurahanSaveBloc.idSink.add(id);
        _masterKelurahanSaveBloc.kecamatanSink.add(_selectedKecamatan!);
        _masterKelurahanSaveBloc.kelurahanSink.add(_kelurahan.text);
        _masterKelurahanSaveBloc.updateKelurahan();
        _streamSaveDialog('edit');
      }
    });
  }

  void _update(int id) {
    if (validateAndSave()) {
      Navigator.pop(context, id);
    }
  }

  void _delete(int? id) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          message: 'Anda yakin menghapus data ini?',
          onConfirm: () => Navigator.pop(context, id),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var id = value as int;
        _masterKelurahanDeleteBloc.idSink.add(id);
        _masterKelurahanDeleteBloc.deleteKelurahan();
        _streamDeleteDialog();
      }
    });
  }

  void _streamDeleteDialog() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDialogDelete();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var id = value as int;
        _data.removeWhere((data) => data.id == id);
        _kecamatan.clear();
        if (_data.isEmpty) {
          _masterKelurahanBloc.getMasterKelurahan();
        }
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _masterKelurahanBloc.getMasterKelurahan();
  }

  @override
  void dispose() {
    _kecamatan.dispose();
    _masterKelurahanBloc.dispose();
    _masterKelurahanSaveBloc.dispose();
    _masterKelurahanDeleteBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: const Text('Daftar Kelurahan'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
        actions: [
          IconButton(
            onPressed: _tambah,
            icon: const Icon(Icons.add_rounded),
          )
        ],
      ),
      body: StreamBuilder<ApiResponse<MasterKelurahanModel>>(
        stream: _masterKelurahanBloc.masterKelurahanStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.loading:
                return LoadingBox(
                  message: snapshot.data!.message,
                );
              case Status.error:
                return Center(
                  child: Errorbox(
                    message: snapshot.data!.message,
                    onTap: () {
                      _masterKelurahanBloc.getMasterKelurahan();
                      setState(() {});
                    },
                  ),
                );
              case Status.completed:
                _data = snapshot.data!.data!.kelurahan!;
                return ListKelurahan(
                  data: _data,
                  edit: (Kelurahan? data) => _edit(data!),
                  delete: (int? id) => _delete(id),
                );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _formKelurahan(String saveMethod, int? id) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              saveMethod == 'edit' ? 'Edit Kelurahan' : 'Input Kelurahan',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            InputFormWidget(
              controller: _kecamatan,
              hint: 'Kecamatan',
              readOnly: true,
              keyType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.words,
              onTap: _showKecamatan,
            ),
            const SizedBox(
              height: 18.0,
            ),
            InputFormWidget(
              controller: _kelurahan,
              hint: 'Kelurahan',
              keyType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(
              height: 32.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: saveMethod == 'edit' ? () => _update(id!) : _simpan,
                style: ElevatedButton.styleFrom(
                    primary: kSecondaryColor, onPrimary: Colors.black),
                child: Text(saveMethod == 'edit' ? 'UPDATE' : 'SIMPAN'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamDialog() {
    return StreamBuilder<ApiResponse<ResponseMasterKelurahanSaveModel>>(
      stream: _masterKelurahanSaveBloc.kelurahanSaveStream,
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

  Widget _streamDialogDelete() {
    return StreamBuilder<ApiResponse<ResponseMasterKelurahanSaveModel>>(
      stream: _masterKelurahanDeleteBloc.kelurahanDeleteStream,
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
                onTap: () =>
                    Navigator.pop(context, snapshot.data!.data!.data!.id),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListKelurahan extends StatefulWidget {
  const ListKelurahan({
    Key? key,
    required this.data,
    this.edit,
    this.delete,
  }) : super(key: key);

  final List<Kelurahan> data;
  final Function(Kelurahan?)? edit;
  final Function(int?)? delete;

  @override
  State<ListKelurahan> createState() => _ListKelurahanState();
}

class _ListKelurahanState extends State<ListKelurahan> {
  final _filter = TextEditingController();
  List<Kelurahan> _data = [];

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
          .where((e) => e.namaKelurahan!
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
  void didUpdateWidget(covariant ListKelurahan oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      setState(() {
        _data = widget.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: SearchInputWidget(
            controller: _filter,
            hint: 'Pencarian kelurahan',
            onClear: () => _filter.clear(),
          ),
        ),
        if (_data.isEmpty)
          const Expanded(
            child: Errorbox(
              message: 'Data tidak tersedia',
              button: false,
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 0.0, bottom: 18.0),
              itemBuilder: (context, i) {
                if (_data.isEmpty) {
                  return const Errorbox(
                    message: 'Data tidak tersedia',
                  );
                }
                var kelurahan = _data[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 22.0, vertical: 12.0),
                  title: Text('${kelurahan.namaKelurahan}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => widget.delete!(kelurahan.id),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      IconButton(
                        onPressed: () => widget.edit!(kelurahan),
                        icon: const Icon(
                          Icons.edit_rounded,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
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
