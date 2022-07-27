import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/config/size_config.dart';
import 'package:pemuda_baik/src/pages/master/kecamatan_page.dart';
import 'package:pemuda_baik/src/pages/master/kelurahan_page.dart';
import 'package:pemuda_baik/src/pages/widget/input_form_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _edit() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const FormEditProfilWidget(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: const Text('Profil'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage('images/male.jpg'),
              ),
              const Expanded(
                child: ListTile(
                  title: Text(
                    'Nama Pengguna',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Administrator',
                  ),
                ),
              ),
              IconButton(
                onPressed: _edit,
                icon: Icon(
                  Icons.edit_rounded,
                  color: Colors.grey[600],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 52.0,
          ),
          const Text(
            'Master Data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 18.0,
          ),
          ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const KecamatanPage(),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
            title: const Text('Master Kecamatan'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          const Divider(
            height: 0.0,
          ),
          ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const KelurahanPage(),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
            title: const Text('Master Kelurahan'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          const Divider(
            height: 0.0,
          ),
          ListTile(
            onTap: () {},
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
            title: const Text('Master Pekerjaan'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          const Divider(
            height: 0.0,
          ),
          ListTile(
            onTap: () {},
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
            title: const Text('Master Pendidikan'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () => Navigator.pop(context, 'logout'),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
            title: const Text('Logout'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }
}

class FormEditProfilWidget extends StatefulWidget {
  const FormEditProfilWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FormEditProfilWidget> createState() => _FormEditProfilWidgetState();
}

class _FormEditProfilWidgetState extends State<FormEditProfilWidget> {
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _ulangiPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  void _update() {
    if (validateAndSave()) {
      //
    }
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _password.dispose();
    _ulangiPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(22),
            child: Text(
              'Edit Profil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: 22.0, horizontal: 22),
              children: [
                const Text('Nama'),
                const SizedBox(
                  height: 8.0,
                ),
                InputFormWidget(
                  controller: _nama,
                  hint: 'Nama pengguna',
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
                  obscure: true,
                  suffixicon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility_rounded)),
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
                  obscure: true,
                  suffixicon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility_rounded)),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: kSecondaryColor,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0))),
                    child: const Text('Update'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
