import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/pages/input_bursa_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class BursaKerjaPage extends StatefulWidget {
  const BursaKerjaPage({Key? key}) : super(key: key);

  @override
  State<BursaKerjaPage> createState() => _BursaKerjaPageState();
}

class _BursaKerjaPageState extends State<BursaKerjaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bursa Kerja'),
        backgroundColor: kPrimaryDarkColor,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: _streamBursa(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'inputBursa',
        onPressed: () => pushNewScreen(context,
            screen: const InputBursaPage(), withNavBar: false),
        backgroundColor: kPrimaryDarkColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _streamBursa() {
    return Container();
  }
}
