import 'dart:async';

import 'package:pemuda_baik/src/models/master_user_save_model.dart';
import 'package:pemuda_baik/src/repositories/master_user_save_repo.dart';
import 'package:pemuda_baik/src/repositories/master_user_update_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterUserSaveBloc {
  final MasterUserSaveRepo _repo = MasterUserSaveRepo();
  final MasterUserUpdateRepo _repoUpdate = MasterUserUpdateRepo();
  StreamController<ApiResponse<ResponseMasterUserSaveModel>>? _streamUserSave;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _nama = BehaviorSubject();
  final BehaviorSubject<String> _email = BehaviorSubject();
  final BehaviorSubject<String> _password = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _passwordConfirm = BehaviorSubject.seeded('');
  final BehaviorSubject<int> _role = BehaviorSubject();
  final BehaviorSubject<String> _pemuda = BehaviorSubject.seeded('');
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get namaSink => _nama.sink;
  StreamSink<String> get emailSink => _email.sink;
  StreamSink<String> get passwordSink => _password.sink;
  StreamSink<String> get passwordConfirmaSink => _passwordConfirm.sink;
  StreamSink<int> get roleSink => _role.sink;
  StreamSink<String> get pemudaSink => _pemuda.sink;
  StreamSink<ApiResponse<ResponseMasterUserSaveModel>> get userSaveSink =>
      _streamUserSave!.sink;
  Stream<ApiResponse<ResponseMasterUserSaveModel>> get userSaveStream =>
      _streamUserSave!.stream;

  Future<void> saveUser() async {
    _streamUserSave = StreamController();
    final nama = _nama.value;
    final email = _email.value;
    final password = _password.value;
    final passwordConfirm = _passwordConfirm.value;
    final role = _role.value;
    final pemuda = _pemuda.value;
    userSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterUserSaveModel masterUserSaveModel = MasterUserSaveModel(
      nama: nama,
      email: email,
      role: role,
      password: password,
      passwordConfirmation: passwordConfirm,
      pemuda: pemuda,
    );
    try {
      final res = await _repo.saveUser(masterUserSaveModel);
      if (_streamUserSave!.isClosed) return;
      userSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamUserSave!.isClosed) return;
      userSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateUser() async {
    _streamUserSave = StreamController();
    final id = _id.value;
    final nama = _nama.value;
    final email = _email.value;
    final password = _password.value;
    final passwordConfirm = _passwordConfirm.value;
    final role = _role.value;
    final pemuda = _pemuda.value;
    userSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterUserSaveModel masterUserSaveModel = MasterUserSaveModel(
      nama: nama,
      email: email,
      role: role,
      password: password,
      passwordConfirmation: passwordConfirm,
      pemuda: pemuda,
    );
    try {
      final res = await _repoUpdate.updateUser(masterUserSaveModel, id);
      if (_streamUserSave!.isClosed) return;
      userSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamUserSave!.isClosed) return;
      userSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamUserSave?.close();
    _nama.close();
    _email.close();
    _password.close();
    _passwordConfirm.close();
    _role.close();
  }
}
