import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pemuda_baik/src/blocs/master_pendidikan_bloc.dart';
import 'package:pemuda_baik/src/blocs/master_pendidikan_delete_bloc.dart';
import 'package:pemuda_baik/src/blocs/master_pendidikan_save_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/master_pendidikan_model.dart';
import 'package:pemuda_baik/src/models/master_pendidikan_save_model.dart';
import 'package:pemuda_baik/src/pages/widget/confirm_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/error_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';
import 'package:pemuda_baik/src/pages/widget/loading_box.dart';
import 'package:pemuda_baik/src/pages/widget/loading_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/search_input_widget.dart';
import 'package:pemuda_baik/src/pages/widget/success_dialog.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class PendidikanPage extends StatefulWidget {
  const PendidikanPage({Key? key}) : super(key: key);

  @override
  State<PendidikanPage> createState() => _PendidikanPageState();
}

class _PendidikanPageState extends State<PendidikanPage> {
  final MasterPendidikanSaveBloc _masterPendidikanSaveBloc =
      MasterPendidikanSaveBloc();
  final MasterPendidikanBloc _masterPendidikanBloc = MasterPendidikanBloc();
  final MasterPendidikanDeleteBloc _masterPendidikanDeleteBloc =
      MasterPendidikanDeleteBloc();
  final _pendidikan = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Pendidikan> _data = [];

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _tambah() {
    _pendidikan.clear();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _formPendidikan('create', null),
        );
      },
    );
  }

  void _simpan() {
    if (validateAndSave()) {
      Navigator.pop(context);
      _masterPendidikanSaveBloc.pendidikanSink.add(_pendidikan.text);
      _masterPendidikanSaveBloc.savePendidikan();
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
          _masterPendidikanBloc.getPendidikan();
        } else {
          if (saveMethod == 'edit') {
            var data = value as Pendidikan;
            _data[_data.indexWhere((e) => e.id == data.id)] = data;
          } else {
            var data = value as Pendidikan;
            _data.insert(0, data);
          }
        }
        setState(() {});
      }
    });
  }

  void _edit(Pendidikan data) {
    _pendidikan.text = '${data.namaPendidikan}';
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _formPendidikan('edit', data.id),
        );
      },
    ).then((value) {
      if (value != null) {
        var id = value as int;
        _masterPendidikanSaveBloc.idSink.add(id);
        _masterPendidikanSaveBloc.pendidikanSink.add(_pendidikan.text);
        _masterPendidikanSaveBloc.updatePendidikan();
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
        _masterPendidikanDeleteBloc.idSink.add(id);
        _masterPendidikanDeleteBloc.deletePendidikan();
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
        _pendidikan.clear();
        if (_data.isEmpty) {
          _masterPendidikanBloc.getPendidikan();
        }
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _masterPendidikanBloc.getPendidikan();
  }

  @override
  void dispose() {
    _pendidikan.dispose();
    _masterPendidikanBloc.dispose();
    _masterPendidikanSaveBloc.dispose();
    _masterPendidikanDeleteBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: const Text('Daftar Pendidikan'),
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
      body: StreamBuilder<ApiResponse<MasterPendidikanModel>>(
        stream: _masterPendidikanBloc.masterPendidikanStream,
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
                      _masterPendidikanBloc.getPendidikan();
                      setState(() {});
                    },
                  ),
                );
              case Status.completed:
                _data = snapshot.data!.data!.pendidikan!;
                return ListKecamatan(
                  data: _data,
                  edit: (Pendidikan data) => _edit(data),
                  delete: (int id) => _delete(id),
                );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _formPendidikan(String saveMethod, int? id) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              saveMethod == 'edit' ? 'Edit Pendidikan' : 'Input Pendidikan',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            InputFormWidget(
              controller: _pendidikan,
              hint: 'Pendidikan',
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
    return StreamBuilder<ApiResponse<ResponseMasterPendidikanSaveModel>>(
      stream: _masterPendidikanSaveBloc.pendidikanSaveStream,
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
    return StreamBuilder<ApiResponse<ResponseMasterPendidikanSaveModel>>(
      stream: _masterPendidikanDeleteBloc.pendidikanDeleteStream,
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

  final List<Pendidikan> data;
  final Function(Pendidikan data)? edit;
  final Function(int id)? delete;

  @override
  State<ListKecamatan> createState() => _ListKecamatanState();
}

class _ListKecamatanState extends State<ListKecamatan> {
  final _filter = TextEditingController();
  List<Pendidikan> _data = [];

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
          .where((e) => e.namaPendidikan!.toLowerCase().contains(
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
            hint: 'Pencarian pendidikan',
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
                  var pendidikan = _data[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 12.0),
                    title: Text('${pendidikan.namaPendidikan}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => widget.delete!(pendidikan.id!),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        IconButton(
                          onPressed: () => widget.edit!(pendidikan),
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
