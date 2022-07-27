import 'package:flutter/material.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/pages/login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 32,
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
              'Temukan artikel tentang daerah dan bursa kerja diaplikasi pemuda baik',
              style: TextStyle(color: Colors.grey[800]),
            ),
            Container(
              height: 350,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/pemuda_2.png'),
                ),
              ),
            ),
            const SizedBox(
              height: 42.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    )),
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryDarkColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('MASUK'),
              ),
            ),
            const SizedBox(
              height: 18.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: kRedColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('BERGABUNG SEKARANG'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
