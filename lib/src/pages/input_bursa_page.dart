import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:pemuda_baik/src/blocs/bursa_save_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/bursa_model.dart';
import 'package:pemuda_baik/src/models/bursa_save_model.dart';
import 'package:pemuda_baik/src/pages/widget/confirm_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/error_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';
import 'package:pemuda_baik/src/pages/widget/loading_dialog.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class InputBursaPage extends StatefulWidget {
  const InputBursaPage({
    Key? key,
    this.data,
  }) : super(key: key);

  final BursaKerja? data;

  @override
  State<InputBursaPage> createState() => _InputBursaPageState();
}

class _InputBursaPageState extends State<InputBursaPage> {
  final BursaSaveBloc _bursaSaveBloc = BursaSaveBloc();
  final _title = TextEditingController();
  final _persyaratan = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _title.text = '${widget.data!.title}';
      _persyaratan.text = '${widget.data!.persyaratan}';
    }
  }

  bool validateAndSave() {
    var formsState = _formKey.currentState;
    if (formsState!.validate()) {
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      _bursaSaveBloc.judulSink.add(_title.text);
      _bursaSaveBloc.persyaratanSink.add(_persyaratan.text);
      _bursaSaveBloc.saveBursa();
      _showStreamSave('create');
    }
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      _bursaSaveBloc.idSink.add(widget.data!.id!);
      _bursaSaveBloc.judulSink.add(_title.text);
      _bursaSaveBloc.persyaratanSink.add(_persyaratan.text);
      _bursaSaveBloc.updateBursa();
      _showStreamSave('update');
    }
  }

  void _delete() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).unfocus();
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          message: 'Anda yaking menghapus data ini?',
          onConfirm: () => Navigator.pop(context, 'delete'),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _bursaSaveBloc.idSink.add(widget.data!.id!);
        _bursaSaveBloc.deleteBursa();
        _showStreamSave('delete');
      }
    });
  }

  void _showStreamSave(String? type) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSaveBursa(type);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      var data = value as BursaType;
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context, data);
      });
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _persyaratan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: const Text('Input Bursa Kerja'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
          children: [
            const Text('Judul'),
            const SizedBox(
              height: 10.0,
            ),
            InputFormWidget(
              controller: _title,
              hint: 'Ketikkan judul',
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Persyaratan'),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: _persyaratan,
              minLines: 10,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: 'Ketikkan isi persyaratan',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(
              height: 52,
            ),
            if (widget.data != null)
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _delete,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          primary: Colors.grey[200],
                          onPrimary: Colors.red,
                        ),
                        child: const Icon(Icons.delete),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _update,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          primary: kPrimaryDarkColor,
                        ),
                        child: const Text('UPDATE'),
                      ),
                    ),
                  )
                ],
              )
            else
              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpan,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    primary: kPrimaryDarkColor,
                  ),
                  child: const Text('SIMPAN'),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _streamSaveBursa(String? type) {
    return StreamBuilder<ApiResponse<ResponseBursaSaveModel>>(
      stream: _bursaSaveBloc.bursaSaveStream,
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
              Navigator.pop(
                  context, BursaType(type: type!, data: snapshot.data!.data!));
          }
        }
        return const SizedBox();
      },
    );
  }
}

class BursaType {
  BursaType({
    required this.type,
    required this.data,
  });

  String type;
  ResponseBursaSaveModel data;
}
