import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pemuda_baik/src/blocs/artikel_save_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/artikel_model.dart';
import 'package:pemuda_baik/src/models/artikel_save_model.dart';
import 'package:pemuda_baik/src/pages/widget/error_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';
import 'package:pemuda_baik/src/pages/widget/loading_dialog.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:path/path.dart' as p;

class InputArtikelPage extends StatefulWidget {
  const InputArtikelPage({
    Key? key,
    this.data,
  }) : super(key: key);

  final Artikel? data;

  @override
  State<InputArtikelPage> createState() => _InputArtikelPageState();
}

class _InputArtikelPageState extends State<InputArtikelPage> {
  final ArtikelSaveBloc _artikelSaveBloc = ArtikelSaveBloc();
  final ImagePicker _picker = ImagePicker();
  final _judul = TextEditingController();
  final _penulis = TextEditingController();
  final _artikel = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _fileImage;
  String _image64 = '', _ext = '';

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _judul.text = '${widget.data!.judul}';
      _penulis.text = '${widget.data!.penulis}';
      _artikel.text = '${widget.data!.artikel}';
    }
  }

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      _artikelSaveBloc.judulSink.add(_judul.text);
      _artikelSaveBloc.penulisSink.add(_penulis.text);
      _artikelSaveBloc.artikelSink.add(_artikel.text);
      _artikelSaveBloc.imageSink.add(_image64);
      _artikelSaveBloc.extSink.add(_ext);
      _artikelSaveBloc.saveArtikel();
      _showStreamSaveArtikel();
    }
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      _artikelSaveBloc.idSink.add(widget.data!.id!);
      _artikelSaveBloc.judulSink.add(_judul.text);
      _artikelSaveBloc.penulisSink.add(_penulis.text);
      _artikelSaveBloc.artikelSink.add(_artikel.text);
      _artikelSaveBloc.imageSink.add(_image64);
      _artikelSaveBloc.extSink.add(_ext);
      _artikelSaveBloc.updateArtikel();
      _showStreamSaveArtikel();
    }
  }

  void _showStreamSaveArtikel() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSaveArtikel();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      var data = value as Artikel;
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context, data);
      });
    });
  }

  void _pickImage() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return _pickImageWidget();
      },
    );
  }

  void _select(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 30,
      );
      setState(() {
        _fileImage = File(pickedFile!.path);
        _image64 = base64Encode(File(pickedFile.path).readAsBytesSync());
        _ext = p.extension(pickedFile.path);
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void dispose() {
    _judul.dispose();
    _penulis.dispose();
    _artikel.dispose();
    _artikelSaveBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: _fileImage == null
                  ? widget.data == null || widget.data!.urlImg == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).padding.top,
                            ),
                            const Icon(
                              Icons.add_rounded,
                              size: 32,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Tap untuk menambahkan gambar',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        )
                      : CachedNetworkImage(imageUrl: '${widget.data!.urlImg}')
                  : Image.file(
                      _fileImage!,
                      fit: BoxFit.fitHeight,
                    ),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 22.0),
                children: [
                  const Text('Judul'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  InputFormWidget(
                    controller: _judul,
                    hint: 'Ketikkan judul artikel',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  const Text('Penulis'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  InputFormWidget(
                    controller: _penulis,
                    hint: 'Ketikkan penulis artikel',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  const Text('Artikel'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _artikel,
                    minLines: 5,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      hintText: 'Ketikkan isi artikel',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Input required';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: widget.data != null ? _update : _simpan,
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryDarkColor,
                      ),
                      child: widget.data != null
                          ? const Text('UPDATE')
                          : const Text('SIMPAN'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _streamSaveArtikel() {
    return StreamBuilder<ApiResponse<ResponseArtikelSaveModel>>(
      stream: _artikelSaveBloc.artikelSaveStream,
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
              Navigator.pop(context, snapshot.data!.data!.data);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _pickImageWidget() {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _select(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image,
                      color: Colors.red,
                      size: 52,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(
                        'Galery',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(
            width: 0,
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _select(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.green,
                      size: 52,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(
                        'Kamera',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
