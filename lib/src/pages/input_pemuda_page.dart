import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pemuda_baik/src/blocs/pemuda_save_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/config/size_config.dart';
import 'package:pemuda_baik/src/models/master_kecamatan_model.dart';
import 'package:pemuda_baik/src/models/master_kelurahan_model.dart';
import 'package:pemuda_baik/src/models/master_pekerjaan_model.dart';
import 'package:pemuda_baik/src/models/master_pendidikan_model.dart';
import 'package:pemuda_baik/src/models/pemuda_page_model.dart';
import 'package:pemuda_baik/src/models/save_pemuda_model.dart';
import 'package:pemuda_baik/src/pages/widget/list_kecamatan_widget.dart';
import 'package:pemuda_baik/src/pages/widget/list_kelurahan_widget.dart';
import 'package:pemuda_baik/src/pages/widget/list_pekerjaan_widget.dart';
import 'package:pemuda_baik/src/pages/widget/list_penddidkan_widget.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';
import 'package:pemuda_baik/src/pages/widget/loading_dialog_widget.dart';

class InputPemudaPage extends StatefulWidget {
  const InputPemudaPage({
    Key? key,
    this.data,
  }) : super(key: key);

  final PemudaPage? data;

  @override
  State<InputPemudaPage> createState() => _InputPemudaPageState();
}

class _InputPemudaPageState extends State<InputPemudaPage> {
  final PemudaSaveBloc _pemudaSaveBloc = PemudaSaveBloc();
  final _nik = TextEditingController();
  final _nama = TextEditingController();
  final _tanggalLahir = TextEditingController();
  final _kecamatan = TextEditingController();
  final _kelurahan = TextEditingController();
  final _pendidkanTerakhir = TextEditingController();
  final _pekerjaan = TextEditingController();
  final _alamat = TextEditingController();
  final _nomorHp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? selectedPendidikan;
  int? selectedPekerjaan;
  int? selectedKecamatan;
  int? selectedKelurahan;
  int? selectedRadioTile;
  int? selectedRadioTileNikah;
  int? selectedRadioTilePekerjaan;
  String? selectedRadioTileAgama;
  final DateTime _selectedDate = DateTime(2000, 1, 1);
  final DateFormat _tanggal = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _edit();
    }
  }

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _edit() {
    var data = widget.data!;
    _nik.text = data.nomorKtp!;
    _nama.text = data.nama!;
    _tanggalLahir.text = data.tanggalLahir!;
    _kecamatan.text = data.kecamatan!.namaKecamatan!;
    _kelurahan.text = data.kelurahan!.namaKelurahan!;
    _pendidkanTerakhir.text = data.pendidikan!.namaPendidikan!;
    _pekerjaan.text = data.pekerjaan!.namaPekerjaan!;
    _alamat.text = data.alamat!;
    _nomorHp.text = data.nomorKontak!;
    setState(() {
      selectedPendidikan = data.pendidikan!.id;
      selectedPekerjaan = data.pekerjaan!.id;
      selectedKecamatan = data.kecamatan!.id;
      selectedKelurahan = data.kelurahan!.id;
      selectedRadioTile = data.jenisKelamin == 'Laki-laki' ? 1 : 2;
      selectedRadioTileNikah = data.intStatus;
      selectedRadioTilePekerjaan = data.pekerjaan!.id;
      selectedRadioTileAgama = data.agama;
    });
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _pemudaSaveBloc.nikSink.add(_nik.text);
      _pemudaSaveBloc.namaSink.add(_nama.text);
      _pemudaSaveBloc.tanggalLahirSink.add(_tanggalLahir.text);
      _pemudaSaveBloc.jenisKelaminSink.add(selectedRadioTile!);
      _pemudaSaveBloc.statusNikahSink.add(selectedRadioTileNikah!);
      _pemudaSaveBloc.pekerjaanSink.add(selectedPekerjaan!);
      _pemudaSaveBloc.agamaSink.add(selectedRadioTileAgama!);
      _pemudaSaveBloc.pendidikanTerakhirSink.add(selectedPendidikan!);
      _pemudaSaveBloc.alamatSink.add(_alamat.text);
      _pemudaSaveBloc.nomorHpSink.add(_nomorHp.text);
      _pemudaSaveBloc.kelurahanSink.add(selectedKelurahan!);
      _pemudaSaveBloc.kecamatanSink.add(selectedKecamatan!);
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
          var data = value as PemudaPage;
          Navigator.pop(context, data);
        }
      });
    }
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _pemudaSaveBloc.idSink.add(widget.data!.id!);
      _pemudaSaveBloc.nikSink.add(_nik.text);
      _pemudaSaveBloc.namaSink.add(_nama.text);
      _pemudaSaveBloc.tanggalLahirSink.add(_tanggalLahir.text);
      _pemudaSaveBloc.jenisKelaminSink.add(selectedRadioTile!);
      _pemudaSaveBloc.statusNikahSink.add(selectedRadioTileNikah!);
      _pemudaSaveBloc.pekerjaanSink.add(selectedPekerjaan!);
      _pemudaSaveBloc.agamaSink.add(selectedRadioTileAgama!);
      _pemudaSaveBloc.pendidikanTerakhirSink.add(selectedPendidikan!);
      _pemudaSaveBloc.alamatSink.add(_alamat.text);
      _pemudaSaveBloc.nomorHpSink.add(_nomorHp.text);
      _pemudaSaveBloc.kelurahanSink.add(selectedKelurahan!);
      _pemudaSaveBloc.kecamatanSink.add(selectedKecamatan!);
      _pemudaSaveBloc.updatePemuda();
      showAnimatedDialog(
        context: context,
        builder: (context) {
          return _streamSavePemuda();
        },
        animationType: DialogTransitionType.slideFromBottomFade,
        duration: const Duration(milliseconds: 300),
      ).then((value) {
        if (value != null) {
          var data = value as PemudaPage;
          Navigator.pop(context, data);
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
              primary: kPrimaryDarkColor,
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

  void _showPendidikan() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: SizeConfig.blockSizeVertical * 72,
            ),
            child: ListPendidikanWidget(
              selected: selectedPendidikan,
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as Pendidikan;
        setState(() {
          _pendidkanTerakhir.text = data.namaPendidikan!;
          selectedPendidikan = data.id;
        });
      }
    });
  }

  void _showPekerjaan() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: SizeConfig.blockSizeVertical * 72,
            ),
            child: ListPekerjaanWidget(
              selected: selectedPekerjaan,
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as Pekerjaan;
        setState(() {
          _pekerjaan.text = data.namaPekerjaan!;
          selectedPekerjaan = data.id;
        });
      }
    });
  }

  void _showKecamatan() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: double.infinity,
            constraints:
                BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 72),
            child: ListKecamatanWidget(selected: selectedKecamatan),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as Kecamatan;
        setState(() {
          selectedKecamatan = data.id;
          _kecamatan.text = data.namaKecamatan!;
        });
      }
    });
  }

  void _showKelurahan() {
    if (selectedKecamatan != null) {
      showBarModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: double.infinity,
              constraints:
                  BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 72),
              child: ListKelurahanWidget(
                  selected: selectedKelurahan, idKecamatan: selectedKecamatan!),
            ),
          );
        },
      ).then((value) {
        if (value != null) {
          var data = value as Kelurahan;
          setState(() {
            selectedKelurahan = data.id;
            _kelurahan.text = data.namaKelurahan!;
          });
        }
      });
    } else {
      Fluttertoast.showToast(
        msg: "Anda belum memilih kecamatan",
        toastLength: Toast.LENGTH_SHORT,
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
    SizeConfig().init(context);
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
            const Text('Tanggal Lahir'),
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
              height: 18.0,
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
                      groupValue: selectedRadioTileNikah,
                      title: const Text("Duda"),
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
                      value: 4,
                      groupValue: selectedRadioTileNikah,
                      title: const Text("Janda"),
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
                      value: "Islam",
                      groupValue: selectedRadioTileAgama,
                      title: const Text("Islam"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileAgama = val as String;
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
                      value: "Protestan",
                      groupValue: selectedRadioTileAgama,
                      title: const Text("Protestan"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileAgama = val as String;
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
                      value: "Katolik",
                      groupValue: selectedRadioTileAgama,
                      title: const Text("Katolik"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileAgama = val as String;
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
                      value: "Hindu",
                      groupValue: selectedRadioTileAgama,
                      title: const Text("Hindu"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileAgama = val as String;
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
                      value: "Budha",
                      groupValue: selectedRadioTileAgama,
                      title: const Text("Budha"),
                      onChanged: (val) {
                        setState(() {
                          selectedRadioTileAgama = val as String;
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
            const Text('Pendidikan Terakhir'),
            const SizedBox(
              height: 10.0,
            ),
            InputFormWidget(
              controller: _pendidkanTerakhir,
              readOnly: true,
              hint: 'Ketikkan Pendidikan Terakhir',
              textCapitalization: TextCapitalization.words,
              onTap: _showPendidikan,
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Pekerjaan'),
            const SizedBox(
              height: 10.0,
            ),
            InputFormWidget(
              controller: _pekerjaan,
              hint: 'Ketikkan Pekerjaan',
              readOnly: true,
              textCapitalization: TextCapitalization.words,
              onTap: _showPekerjaan,
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
                hintText: 'Ketikkan alamat lengkap sesuai identitas',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14.0),
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
              height: 22.0,
            ),
            const Text('Kecamatan'),
            const SizedBox(
              height: 10.0,
            ),
            InputFormWidget(
              controller: _kecamatan,
              readOnly: true,
              hint: 'Ketikkan Kecamatan',
              textCapitalization: TextCapitalization.words,
              onTap: _showKecamatan,
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Text('Kelurahan/Desa'),
            const SizedBox(
              height: 10.0,
            ),
            InputFormWidget(
              controller: _kelurahan,
              readOnly: true,
              hint: 'Ketikkan Kelurahan',
              textCapitalization: TextCapitalization.words,
              onTap: _showKelurahan,
            ),
            const SizedBox(
              height: 52.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: widget.data == null ? _simpan : _update,
                style: ElevatedButton.styleFrom(
                    primary: kPrimaryDarkColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                child: widget.data == null
                    ? const Text('SIMPAN')
                    : const Text('UPDATE'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamSavePemuda() {
    return StreamBuilder<ApiResponse<ResponseSavePemudaModel>>(
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
                    onPressed: () =>
                        Navigator.pop(context, snapshot.data!.data!.data),
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
