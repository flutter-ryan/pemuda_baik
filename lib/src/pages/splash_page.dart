import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/pages/session_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _version = '1.0.0';
  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  void _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const Sessionpage(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('images/pemuda_logo.png'),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(2.0, 2.0),
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Pemuda Baik',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    'Kabupaten Bantaeng',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '2022 \u00a9 Pemuda Baik',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                  ),
                  Text(
                    'v.$_version',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
