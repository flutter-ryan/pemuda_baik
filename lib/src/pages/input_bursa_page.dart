import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';

class InputBursaPage extends StatefulWidget {
  const InputBursaPage({Key? key}) : super(key: key);

  @override
  State<InputBursaPage> createState() => _InputBursaPageState();
}

class _InputBursaPageState extends State<InputBursaPage> {
  final _title = TextEditingController();
  final _persyaratan = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    var formsState = _formKey.currentState;
    if (formsState!.validate()) {
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
            const Text('Nama Pekerja'),
            const SizedBox(
              height: 10.0,
            ),
            InputFormWidget(
              controller: _title,
              hint: 'Ketikkan nama pekerjaan',
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
            ),
            const SizedBox(
              height: 52,
            ),
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
}
