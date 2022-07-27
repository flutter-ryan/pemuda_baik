import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pemuda_baik/src/blocs/auth_bloc.dart';
import 'package:pemuda_baik/src/blocs/login_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/login_model.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginBloc _loginBloc = LoginBloc();
  final _email = TextEditingController();
  final _pasword = TextEditingController();
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

  void _login() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _loginBloc.emailSink.add(_email.text);
      _loginBloc.passwordSink.add(_pasword.text);
      _loginBloc.login();
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _pasword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 12,
                ),
                const Text(
                  'Selamat Datang',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                ),
                const Text(
                  'Pemuda Baik',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  'Temukan artikel tentang daerah dan bursa kerja diaplikasi ini',
                  style: TextStyle(color: Colors.grey[800]),
                ),
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/pemuda_2.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                InputFormWidget(
                  controller: _email,
                  hint: 'Email address',
                  icon: const Icon(Icons.email_rounded),
                  keyType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                InputFormWidget(
                  controller: _pasword,
                  hint: 'Password',
                  icon: const Icon(Icons.lock),
                  keyType: TextInputType.emailAddress,
                  obscure: _obscure,
                  suffixicon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                      icon: !_obscure
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('MASUK'),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) _streamLogin()
        ],
      ),
    );
  }

  Widget _streamLogin() {
    return StreamBuilder<ApiResponse<ResponseLoginModel>>(
      stream: _loginBloc.loginStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case Status.error:
              return Container(
                color: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        size: 52,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        snapshot.data!.message,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(
                            () {
                              _isLoading = false;
                            },
                          );
                        },
                        child: const Text('Coba lagi'),
                      )
                    ],
                  ),
                ),
              );
            case Status.completed:
              var data = snapshot.data!.data!.user;
              authbloc.openSession(
                data!.id!,
                data.name!,
                data.token!,
                data.role!,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
