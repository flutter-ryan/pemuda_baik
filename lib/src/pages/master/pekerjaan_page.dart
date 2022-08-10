import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pemuda_baik/src/blocs/master_pekerjaan_bloc.dart';
import 'package:pemuda_baik/src/blocs/master_pekerjaan_delete_bloc.dart';
import 'package:pemuda_baik/src/blocs/master_pekerjaan_save_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/master_pekerjaan_model.dart';
import 'package:pemuda_baik/src/models/master_pekerjaan_save_model.dart';
import 'package:pemuda_baik/src/pages/widget/confirm_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/error_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';
import 'package:pemuda_baik/src/pages/widget/loading_box.dart';
import 'package:pemuda_baik/src/pages/widget/loading_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/search_input_widget.dart';
import 'package:pemuda_baik/src/pages/widget/success_dialog.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class PekerjaanPage extends StatefulWidget {
  const PekerjaanPage({Key? key}) : super(key: key);

  @override
  State<PekerjaanPage> createState() => _PekerjaanPageState();
}

class _PekerjaanPageState extends State<PekerjaanPage> {
  final MasterPekerjaanSaveBloc _masterPekerjaanSaveBloc =
      MasterPekerjaanSaveBloc();
  final MasterPekerjaanBloc _masterPekerjaanBloc = MasterPekerjaanBloc();
  final MasterPekerjaanDeleteBloc _masterPekerjaanDeleteBloc =
      MasterPekerjaanDeleteBloc();
  final _pekerjaan = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Pekerjaan> _data = [];

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _tambah() {
    _pekerjaan.clear();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _formPekerjaan('create', null),
        );
      },
    );
  }

  void _simpan() {
    if (validateAndSave()) {
      Navigator.pop(context);
      _masterPekerjaanSaveBloc.pekerjaanSink.add(_pekerjaan.text);
      _masterPekerjaanSaveBloc.savePekerjaan();
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
          _masterPekerjaanBloc.getPekerjaan();
        } else {
          if (saveMethod == 'edit') {
            var data = value as Pekerjaan;
            _data[_data.indexWhere((e) => e.id == data.id)] = data;
          } else {
            var data = value as Pekerjaan;
            _data.insert(0, data);
          }
        }
        setState(() {});
      }
    });
  }

  void _edit(Pekerjaan data) {
    _pekerjaan.text = '${data.namaPekerjaan}';
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _formPekerjaan('edit', data.id),
        );
      },
    ).then((value) {
      if (value != null) {
        var id = value as int;
        _masterPekerjaanSaveBloc.idSink.add(id);
        _masterPekerjaanSaveBloc.pekerjaanSink.add(_pekerjaan.text);
        _masterPekerjaanSaveBloc.updatePekerjaan();
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
        _masterPekerjaanDeleteBloc.idSink.add(id);
        _masterPekerjaanDeleteBloc.deletePekerjaan();
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
        _pekerjaan.clear();
        if (_data.isEmpty) {
          _masterPekerjaanBloc.getPekerjaan();
        }
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _masterPekerjaanBloc.getPekerjaan();
  }

  @override
  void dispose() {
    _pekerjaan.dispose();
    _masterPekerjaanBloc.dispose();
    _masterPekerjaanSaveBloc.dispose();
    _masterPekerjaanDeleteBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: const Text('Daftar Pekerjaan'),
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
      body: StreamBuilder<ApiResponse<MasterPekerjaanModel>>(
        stream: _masterPekerjaanBloc.masterPekerjaanStream,
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
                      _masterPekerjaanBloc.getPekerjaan();
                      setState(() {});
                    },
                  ),
                );
              case Status.completed:
                _data = snapshot.data!.data!.pekerjaan!;
                return ListKecamatan(
                  data: _data,
                  edit: (Pekerjaan data) => _edit(data),
                  delete: (int id) => _delete(id),
                );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _formPekerjaan(String saveMethod, int? id) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              saveMethod == 'edit' ? 'Edit Pekerjaan' : 'Input Pekerjaan',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            InputFormWidget(
              controller: _pekerjaan,
              hint: 'Pekerjaan',
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
    return StreamBuilder<ApiResponse<ResponseMasterPekerjaanSaveModel>>(
      stream: _masterPekerjaanSaveBloc.pekerjaanSaveStream,
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
    return StreamBuilder<ApiResponse<ResponseMasterPekerjaanSaveModel>>(
      stream: _masterPekerjaanDeleteBloc.pekerjaanDeleteStream,
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

class ListKecamatan extends StatefulWidget {
  const ListKecamatan({
    Key? key,
    required this.data,
    this.edit,
    this.delete,
  }) : super(key: key);

  final List<Pekerjaan> data;
  final Function(Pekerjaan data)? edit;
  final Function(int id)? delete;

  @override
  State<ListKecamatan> createState() => _ListKecamatanState();
}

class _ListKecamatanState extends State<ListKecamatan> {
  final _filter = TextEditingController();
  List<Pekerjaan> _data = [];

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
          .where((e) => e.namaPekerjaan!.toLowerCase().contains(
                _filter.text.toLowerCase(),
              ))
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
  void didUpdateWidget(covariant ListKecamatan oldWidget) {
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
            hint: 'Pencarian pekerjaan',
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
                  var pekerjaan = _data[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 12.0),
                    title: Text('${pekerjaan.namaPekerjaan}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => widget.delete!(pekerjaan.id!),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        IconButton(
                          onPressed: () => widget.edit!(pekerjaan),
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
                itemCount: _data.length),
          ),
      ],
    );
  }
}
