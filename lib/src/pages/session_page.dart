import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pemuda_baik/src/blocs/auth_bloc.dart';
import 'package:pemuda_baik/src/pages/login_page.dart';
import 'package:pemuda_baik/src/pages/root_page.dart';

class Sessionpage extends StatefulWidget {
  const Sessionpage({Key? key}) : super(key: key);

  @override
  State<Sessionpage> createState() => _SessionpageState();
}

class _SessionpageState extends State<Sessionpage> {
  DateTime? currentBackPressTime;

  @override
  initState() {
    super.initState();
    authbloc.restoreSession();
  }

  Future<bool> willPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 1)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Tap sekali lagi untuk keluar",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: authbloc.isSessionValid,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return WillPopScope(
            onWillPop: willPop,
            child: const Rootpage(),
          );
        }
        return const LoginPage();
      },
    );
  }
}
