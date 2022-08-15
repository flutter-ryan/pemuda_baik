import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pemuda_baik/src/blocs/master_user_delete_bloc.dart';
import 'package:pemuda_baik/src/blocs/master_user_save_bloc.dart';
import 'package:pemuda_baik/src/blocs/master_users_bloc.dart';
import 'package:pemuda_baik/src/blocs/pemuda_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/config/size_config.dart';
import 'package:pemuda_baik/src/models/master_user_save_model.dart';
import 'package:pemuda_baik/src/models/master_users_model.dart';
import 'package:pemuda_baik/src/models/pemuda_model.dart';
import 'package:pemuda_baik/src/models/pemuda_page_model.dart';
import 'package:pemuda_baik/src/models/user_model.dart';
import 'package:pemuda_baik/src/pages/widget/confirm_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/error_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';
import 'package:pemuda_baik/src/pages/widget/loading_box.dart';
import 'package:pemuda_baik/src/pages/widget/loading_dialog.dart';
import 'package:pemuda_baik/src/pages/widget/search_input_widget.dart';
import 'package:pemuda_baik/src/pages/widget/success_box.dart';
import 'package:pemuda_baik/src/pages/widget/success_dialog.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';

class PenggunaPage extends StatefulWidget {
  const PenggunaPage({Key? key}) : super(key: key);

  @override
  State<PenggunaPage> createState() => _PenggunaPageState();
}

class _PenggunaPageState extends State<PenggunaPage> {
  final MasterUsersBloc _masterUsersBloc = MasterUsersBloc();
  final MasterUserDeleteBloc _masterUserDeleteBloc = MasterUserDeleteBloc();
  List<User> _data = [];

  @override
  void initState() {
    super.initState();
    _masterUsersBloc.getUsers();
  }

  void _tambah() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const FormEditUserWidget(),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as User;
        setState(() {
          _data.insert(0, data);
        });
      }
    });
  }

  void _editUser(User data) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FormEditUserWidget(
            data: data,
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as EditObject;
        if (data.type == 'update') {
          setState(() {
            _data[_data.indexWhere((e) => e.id == data.data.id)] = data.data;
          });
        } else {
          _masterUserDeleteBloc.idSink.add(data.data.id!);
          _masterUserDeleteBloc.deleteUser();
          _showStreamDelete();
        }
      }
    });
  }

  void _showStreamDelete() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDeleteUser();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        var data = value as User;
        setState(() {
          _data.removeWhere((e) => e.id == data.id);
        });
      }
    });
  }

  @override
  void dispose() {
    _masterUsersBloc.dispose();
    _masterUserDeleteBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: const Text('Daftar Pengguna'),
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
      body: _streamUsers(),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambah,
        backgroundColor: kPrimaryDarkColor,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _streamUsers() {
    return StreamBuilder<ApiResponse<MasterUsersModel>>(
      stream: _masterUsersBloc.masterUsersStream,
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
                    _masterUsersBloc.getUsers();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              _data = snapshot.data!.data!.data!;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                itemBuilder: (context, i) {
                  var data = _data[i];
                  return ListTile(
                    onTap: () => _editUser(data),
                    title: Text('${data.email}'),
                    subtitle: data.role == 1
                        ? const Text('Administrator')
                        : const Text('Pemuda'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          decoration: BoxDecoration(
                            color: data.role == 0 ? Colors.red : Colors.green,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: data.role == 0
                              ? const Text(
                                  'Inactive',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                )
                              : const Text(
                                  'Active',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, i) => const Divider(
                  height: 0,
                ),
                itemCount: _data.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamDeleteUser() {
    return StreamBuilder<ApiResponse<ResponseMasterUserSaveModel>>(
      stream: _masterUserDeleteBloc.userDeleteStream,
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
}

class FormEditUserWidget extends StatefulWidget {
  const FormEditUserWidget({
    Key? key,
    this.data,
  }) : super(key: key);

  final User? data;

  @override
  State<FormEditUserWidget> createState() => _FormEditUserWidgetState();
}

class _FormEditUserWidgetState extends State<FormEditUserWidget> {
  final PemudaBloc _pemudaBloc = PemudaBloc();
  final MasterUserSaveBloc _masterUserSaveBloc = MasterUserSaveBloc();
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _ulangiPassword = TextEditingController();
  final _profil = TextEditingController();
  int? selectedRole;
  String? selectedId;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscure = true;

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _masterUserSaveBloc.idSink.add(widget.data!.id!);
      _masterUserSaveBloc.namaSink.add(_nama.text);
      _masterUserSaveBloc.emailSink.add(_email.text);
      _masterUserSaveBloc.passwordSink.add(_password.text);
      _masterUserSaveBloc.passwordConfirmaSink.add(_ulangiPassword.text);
      _masterUserSaveBloc.roleSink.add(selectedRole!);
      _masterUserSaveBloc.pemudaSink.add(selectedId!);
      _masterUserSaveBloc.updateUser();
      setState(() {
        _isLoading = true;
      });
    }
  }

  void _simpan() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _masterUserSaveBloc.namaSink.add(_nama.text);
      _masterUserSaveBloc.emailSink.add(_email.text);
      _masterUserSaveBloc.passwordSink.add(_password.text);
      _masterUserSaveBloc.passwordConfirmaSink.add(_ulangiPassword.text);
      _masterUserSaveBloc.roleSink.add(selectedRole!);
      _masterUserSaveBloc.pemudaSink.add(selectedId!);
      _masterUserSaveBloc.saveUser();
      setState(() {
        _isLoading = true;
      });
    }
  }

  void _listPemuda() {
    _pemudaBloc.getPemuda();
    showBarModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(
              minHeight: 200,
              maxHeight: SizeConfig.blockSizeVertical * 85,
            ),
            child: _listProfilPemuda(),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        var data = value as Pemuda;
        setState(() {
          _profil.text = '${data.nama}';
          selectedId = data.id.toString();
        });
      }
    });
  }

  void _delete() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          message: "Anda yakin megnhapus data ini?",
          onConfirm: () => Navigator.pop(context, 'delete'),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 400),
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pop(
            context,
            EditObject(type: 'delete', data: widget.data!),
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _nama.text = widget.data!.name!;
      _email.text = widget.data!.email!;
      selectedRole = widget.data!.role;
      if (widget.data!.pemudaSave != null) {
        _profil.text = '${widget.data!.pemudaSave!.nama}';
        selectedId = widget.data!.pemudaSave!.id.toString();
      }
    }
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _password.dispose();
    _ulangiPassword.dispose();
    _masterUserSaveBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: SizeConfig.blockSizeVertical * 82,
        child: _streamSaveUser(),
      );
    }
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 82,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(22),
            child: Text(
              widget.data == null ? 'Tambah Pengguna' : 'Edit Pengguna',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 22.0,
                  right: 22,
                  bottom: 22.0,
                  top: 12.0,
                ),
                children: [
                  const Text('Nama'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  InputFormWidget(
                    controller: _nama,
                    hint: 'Nama pengguna',
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  const Text('Email'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  InputFormWidget(
                    controller: _email,
                    hint: 'Alamat email',
                    keyType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  const Text('Password'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  InputFormWidget(
                    controller: _password,
                    hint: 'Password',
                    obscure: _obscure,
                    validate: widget.data == null,
                    suffixicon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                      icon: _obscure
                          ? const Icon(Icons.visibility_rounded)
                          : const Icon(Icons.visibility_off_rounded),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  const Text('Ulangi Password'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  InputFormWidget(
                    controller: _ulangiPassword,
                    hint: 'Ulangi Password',
                    obscure: _obscure,
                    validate: widget.data == null,
                    suffixicon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                      icon: _obscure
                          ? const Icon(Icons.visibility_rounded)
                          : const Icon(Icons.visibility_off_rounded),
                    ),
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  const Text('Role'),
                  const SizedBox(
                    height: 8.0,
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
                            contentPadding: EdgeInsets.zero,
                            value: 1,
                            groupValue: selectedRole,
                            title: const Text("Admin"),
                            onChanged: (val) {
                              setState(() {
                                _profil.clear();
                                selectedId = '';
                                selectedRole = val as int;
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
                            contentPadding: EdgeInsets.zero,
                            value: 2,
                            groupValue: selectedRole,
                            title: const Text("Pemuda"),
                            onChanged: (val) {
                              setState(() {
                                selectedRole = val as int;
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.3, color: Colors.grey),
                    ),
                    child: RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      value: 0,
                      groupValue: selectedRole,
                      title: const Text("Nonaktif"),
                      onChanged: (val) {
                        setState(() {
                          _profil.clear();
                          selectedId = '';
                          selectedRole = val as int;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  if (selectedRole == 2) const Text('Pemuda'),
                  if (selectedRole == 2)
                    const SizedBox(
                      height: 8.0,
                    ),
                  if (selectedRole == 2)
                    InputFormWidget(
                      onTap: _listPemuda,
                      controller: _profil,
                      hint: 'Profil Pemuda',
                      readOnly: true,
                    ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  if (widget.data != null)
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _delete,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[200],
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _update,
                              style: ElevatedButton.styleFrom(
                                primary: kSecondaryColor,
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text('Update'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _simpan,
                        style: ElevatedButton.styleFrom(
                          primary: kPrimaryDarkColor,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text('Simpan'),
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

  Widget _streamSaveUser() {
    return StreamBuilder<ApiResponse<ResponseMasterUserSaveModel>>(
      stream: _masterUserSaveBloc.userSaveStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingBox(
                message: snapshot.data!.message,
              );
            case Status.error:
              return Errorbox(
                message: snapshot.data!.message,
                onTap: () {
                  setState(() {
                    _isLoading = false;
                  });
                },
              );
            case Status.completed:
              return SuccesBox(
                message: snapshot.data!.data!.message,
                onTap: () => Navigator.pop(
                  context,
                  EditObject(type: 'update', data: snapshot.data!.data!.data!),
                ),
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _listProfilPemuda() {
    return StreamBuilder<ApiResponse<PemudaPageModel>>(
      stream: _pemudaBloc.pemudaStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 300,
                child: LoadingBox(),
              );
            case Status.error:
              return SizedBox(
                height: 300,
                child: Errorbox(
                  message: snapshot.data!.message,
                  button: true,
                  onTap: () => Navigator.pop(context),
                ),
              );
            case Status.completed:
              return ListProfilPemuda(data: snapshot.data!.data!);
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListProfilPemuda extends StatefulWidget {
  const ListProfilPemuda({
    Key? key,
    required this.data,
  }) : super(key: key);

  final PemudaPageModel data;

  @override
  State<ListProfilPemuda> createState() => _ListProfilPemudaState();
}

class _ListProfilPemudaState extends State<ListProfilPemuda> {
  final _filter = TextEditingController();
  List<PemudaPage> _data = [];

  @override
  void initState() {
    super.initState();
    _data.addAll(widget.data.data!);
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      _data = widget.data.data!;
    } else {
      _data = widget.data.data!
          .where(
              (e) => e.nama!.toLowerCase().contains(_filter.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding:
              EdgeInsets.only(left: 18, right: 18, top: 32.0, bottom: 22.0),
          child: Text(
            'Pilih pemuda',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: SearchInputWidget(
            controller: _filter,
            hint: 'Pencarian nama pemuda',
            onClear: () {
              _filter.clear();
            },
          ),
        ),
        if (_data.isEmpty)
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 52,
                ),
                SizedBox(
                  height: 12,
                ),
                Text('Data tidak ditemukan')
              ],
            ),
          )
        else
          ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              var data = _data[i];
              return ListTile(
                onTap: () => Navigator.pop(context, data),
                title: Text('${data.nama}'),
              );
            },
            separatorBuilder: (context, i) => const Divider(
              height: 0,
            ),
            itemCount: _data.length,
          )
      ],
    );
  }
}

class EditObject {
  EditObject({
    required this.type,
    required this.data,
  });

  String? type;
  User data;
}
