import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:pemuda_baik/src/blocs/pemuda_save_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/response_model.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';
import 'package:pemuda_baik/src/pages/widget/loading_dialog_widget.dart';

class InputPemudaPage extends StatefulWidget {
  const InputPemudaPage({Key? key}) : super(key: key);

  @override
  State<InputPemudaPage> createState() => _InputPemudaPageState();
}

class _InputPemudaPageState extends State<InputPemudaPage> {
  final PemudaSaveBloc _pemudaSaveBloc = PemudaSaveBloc();
  final _nik = TextEditingController();
  final _nama = TextEditingController();
  final _tanggalLahir = TextEditingController();
  final _pendidkanTerakhir = TextEditingController();
  final _pekerjaan = TextEditingController();
  final _alamat = TextEditingController();
  final _nomorHp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? selectedRadioTile;
  int? selectedRadioTileNikah;
  int? selectedRadioTilePekerjaan;
  int? selectedRadioTileAgama;
  final DateTime _selectedDate = DateTime(2000, 1, 1);
  final DateFormat _tanggal = DateFormat('yyyy-MM-dd');

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
      _pemudaSaveBloc.nikSink.add(_nik.text);
      _pemudaSaveBloc.namaSink.add(_nama.text);
      _pemudaSaveBloc.tanggalLahirSink.add(_tanggalLahir.text);
      _pemudaSaveBloc.jenisKelaminSink.add(selectedRadioTile!);
      _pemudaSaveBloc.statusNikahSink.add(selectedRadioTileNikah!);
      _pemudaSaveBloc.pekerjaanSink.add(selectedRadioTilePekerjaan!);
      _pemudaSaveBloc.agamaSink.add(selectedRadioTileAgama!);
      _pemudaSaveBloc.pendidikanTerakhirSink.add(_pendidkanTerakhir.text);
      _pemudaSaveBloc.alamatSink.add(_alamat.text);
      _pemudaSaveBloc.nomorHpSink.add(_nomorHp.text);
      _pemudaSaveBloc.savePemuda();
      showAnimatedDialog(
        context: context,
        builder: (context) {
          return _streamSavePemuda();
        },
        animationType: DialogTransitionType.slideFromBottomFade,
        duration: const Duration(milliseconds: 300),
      ).then((value) {
        if (value != null) {
          _nik.clear();
          _nama.clear();
          _tanggalLahir.clear();
          _pendidkanTerakhir.clear();
          _pekerjaan.clear();
          _alamat.clear();
          _nomorHp.clear();
          setState(() {
            selectedRadioTile = null;
            selectedRadioTileNikah = null;
            selectedRadioTilePekerjaan = null;
          });
        }
      });
    }
  }

  void _showDate() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
            ),
          ),
          child: DatePickerDialog(
            initialDate: _selectedDate,
            firstDate: DateTime(1900),
            currentDate: _selectedDate,
            lastDate: DateTime.now(),
            helpText: 'Pilih tanggal lahir',
            cancelText: 'Batal',
            confirmText: 'Pilih',
            fieldLabelText: 'Tanggal lahir',
            fieldHintText: 'Tanggal/Bulan/Tahun',
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var tanggal = value as DateTime;
        _tanggalLahir.text = _tanggal.format(tanggal);
      }
    });
  }

  @override
  void dispose() {
    _pemudaSaveBloc.dispose();
    _nik.dispose();
    _nama.dispose();
    _tanggalLahir.dispose();
    _pendidkanTerakhir.dispose();
    _pekerjaan.dispose();
    _alamat.dispose();
    _nomorHp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: const Text('Input Data Pemuda'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
          children: [
            const Text('NIK'),
            const SizedBox(
              height: 10.0,
            ),
            InputFormWidget(
              controller: _nik,
              hint: 'Ketikkan Nomor KTP',
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Nama'),
            const SizedBox(
              height: 10.0,
            ),
            InputFormWidget(
              controller: _nama,
              hint: 'Ketikkan Nama Sesuai Identitas',
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Tangga Lahir'),
            const SizedBox(
              height: 10.0,
            ),
            InputFormWidget(
              controller: _tanggalLahir,
              readOnly: true,
              hint: 'Ketikkan Tanggal Lahir Sesuai Identitas',
              onTap: _showDate,
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Jenis Kelamin'),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: 1,
                      groupValue: selectedRadioTile,
                      title: const Text("Laki-laki"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTile = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 18.0,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: 2,
                      groupValue: selectedRadioTile,
                      title: const Text("Perempuan"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTile = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Status Nikah'),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: 1,
                      groupValue: selectedRadioTileNikah,
                      title: const Text("Nikah"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileNikah = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 18.0,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: 2,
                      groupValue: selectedRadioTileNikah,
                      title: const Text("Belum Nikah"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileNikah = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Agama'),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: 1,
                      groupValue: selectedRadioTileAgama,
                      title: const Text("Islam"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileAgama = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 18.0,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: 2,
                      groupValue: selectedRadioTileAgama,
                      title: const Text("Protestan"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileAgama = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: 3,
                      groupValue: selectedRadioTileAgama,
                      title: const Text("Katolik"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileAgama = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 18.0,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: 4,
                      groupValue: selectedRadioTileAgama,
                      title: const Text("Hindu"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileAgama = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: 5,
                      groupValue: selectedRadioTileAgama,
                      title: const Text("Budha"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileAgama = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 18.0,
                ),
                const Expanded(
                  child: SizedBox(),
                )
              ],
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Status Pekerjaan'),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: 1,
                      groupValue: selectedRadioTilePekerjaan,
                      title: const Text("Bekerja"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTilePekerjaan = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 18.0,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: 2,
                      groupValue: selectedRadioTilePekerjaan,
                      title: const Text("Belum Bekerja"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTilePekerjaan = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Pendidikan Terakhir'),
            const SizedBox(
              height: 10.0,
            ),
            InputFormWidget(
              controller: _pendidkanTerakhir,
              hint: 'Ketikkan Pendidikan Terakhir',
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Alamat'),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: _alamat,
              minLines: 3,
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
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Nomor Hp'),
            const SizedBox(
              height: 10.0,
            ),
            InputFormWidget(
              controller: _nomorHp,
              hint: 'Ketikkan nomor aktif',
              keyType: TextInputType.number,
            ),
            const SizedBox(
              height: 52.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                    primary: kPrimaryDarkColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                child: const Text('SIMPAN'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamSavePemuda() {
    return StreamBuilder<ApiResponse<ResponseModel>>(
      stream: _pemudaSaveBloc.savePemudaStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingDialogWidget(
                messages: snapshot.data!.message,
              );
            case Status.error:
              return AlertDialog(
                title: const Text('Warning'),
                content: Text(snapshot.data!.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  )
                ],
              );
            case Status.completed:
              return AlertDialog(
                title: const Text('Sukses'),
                content: Text('${snapshot.data!.data!.message}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'reload'),
                    child: const Text('Tutup'),
                  ),
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
