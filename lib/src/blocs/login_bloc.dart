import 'dart:async';

import 'package:pemuda_baik/src/models/login_model.dart';
import 'package:pemuda_baik/src/repositories/login_repo.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final LoginRepo _repo = LoginRepo();
  StreamController<ApiResponse<ResponseLoginModel>>? _streamLogin;
  final BehaviorSubject<String> _email = BehaviorSubject();
  final BehaviorSubject<String> _password = BehaviorSubject();
  StreamSink<String> get emailSink => _email.sink;
  StreamSink<String> get passwordSink => _password.sink;
  StreamSink<ApiResponse<ResponseLoginModel>> get loginSink =>
      _streamLogin!.sink;
  Stream<ApiResponse<ResponseLoginModel>> get loginStream =>
      _streamLogin!.stream;

  Future<void> login() async {
    _streamLogin = StreamController();
    final email = _email.value;
    final password = _password.value;
    loginSink.add(ApiResponse.loading('Memuat...'));
    LoginModel loginModel = LoginModel(email: email, password: password);
    try {
      final res = await _repo.login(loginModel);
      if (_streamLogin!.isClosed) return;
      loginSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamLogin!.isClosed) return;
      loginSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamLogin?.close();
    _email.close();
    _password.close();
  }
}
