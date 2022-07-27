import 'package:flutter/material.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';

class InputArtikelPage extends StatefulWidget {
  const InputArtikelPage({Key? key}) : super(key: key);

  @override
  State<InputArtikelPage> createState() => _InputArtikelPageState();
}

class _InputArtikelPageState extends State<InputArtikelPage> {
  final _judul = TextEditingController();
  final _penulis = TextEditingController();
  final _artikel = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _simpan() {
    if (validateAndSave()) {
      //
    }
  }

  @override
  void dispose() {
    _judul.dispose();
    _penulis.dispose();
    _artikel.dispose();
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
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                const Icon(
                  Icons.add_rounded,
                  size: 32,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Tap untuk menambahkan gambar')
              ],
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
                      onPressed: _simpan,
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryDarkColor,
                      ),
                      child: const Text('SIMPAN'),
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
}
