import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pemuda_baik/src/blocs/auth_bloc.dart';
import 'package:pemuda_baik/src/blocs/jumlah_pemuda_bloc.dart';
import 'package:pemuda_baik/src/blocs/user_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/jumlah_pemuda_model.dart';
import 'package:pemuda_baik/src/models/user_model.dart';
import 'package:pemuda_baik/src/pages/kecamatan_chart.dart';
import 'package:pemuda_baik/src/pages/kelurahan_chart.dart';
import 'package:pemuda_baik/src/pages/pekerjaan_chart.dart';
import 'package:pemuda_baik/src/pages/pendidikan_chart.dart';
import 'package:pemuda_baik/src/pages/profile_page.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/pages/widget/loading_box.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin {
  final UserBloc _userBloc = UserBloc();

  @override
  void initState() {
    super.initState();
    _userBloc.getUser();
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: kPrimaryDarkColor,
              padding: EdgeInsets.only(
                  left: 18.0,
                  right: 18.0,
                  top: MediaQuery.of(context).padding.top + 18,
                  bottom: 18.0),
              child: _streamUser(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: 22.0, horizontal: 15.0),
                children: const [
                  JumlahPemudaWidget(),
                  SizedBox(
                    height: 18.0,
                  ),
                  PendidikanChart(),
                  SizedBox(
                    height: 18.0,
                  ),
                  PekerjaanChart(),
                  SizedBox(
                    height: 18.0,
                  ),
                  KecamatanChart(),
                  SizedBox(
                    height: 18.0,
                  ),
                  KelurahanChart(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamUser() {
    return StreamBuilder<ApiResponse<UserModel>>(
      stream: _userBloc.userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.white,
                          child: Container(
                            width: 200,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                          ),
                        ),
                      ),
                      subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.white,
                          child: Container(
                            width: 100,
                            height: 12,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            case Status.error:
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    children: [
                      const Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Text(
                        snapshot.data!.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => authbloc.closedSession(),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Logout'),
                  )
                ],
              );
            case Status.completed:
              var user = snapshot.data!.data!.user;
              return Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('images/male.jpg'),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        '${user!.name}',
                        style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        user.role == 1 ? 'Administrator' : 'Petugas',
                        style: TextStyle(color: Colors.grey[100]),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => pushNewScreen(context,
                            screen: ProfilePage(
                              user: user,
                            ),
                            withNavBar: false)
                        .then((value) {
                      if (value != null) {
                        var data = value as String;
                        if (data == 'logout') {
                          authbloc.closedSession();
                        }
                      }
                    }),
                    icon: Icon(
                      Icons.settings_rounded,
                      color: Colors.grey[100],
                    ),
                  )
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class JumlahPemudaWidget extends StatefulWidget {
  const JumlahPemudaWidget({Key? key}) : super(key: key);

  @override
  State<JumlahPemudaWidget> createState() => _JumlahPemudaWidgetState();
}

class _JumlahPemudaWidgetState extends State<JumlahPemudaWidget> {
  final JumlahPemudaBloc _jumlahPemudaBloc = JumlahPemudaBloc();
  @override
  void initState() {
    super.initState();
    _jumlahPemudaBloc.getJumlahPemuda();
  }

  @override
  void dispose() {
    _jumlahPemudaBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12.0,
            offset: Offset(2.0, 2.0),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Data Pemuda',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
          const Divider(
            height: 18.0,
          ),
          _streamJumlahPemudaWidget(),
        ],
      ),
    );
  }

  Widget _streamJumlahPemudaWidget() {
    return StreamBuilder<ApiResponse<JumlahPemudaModel>>(
      stream: _jumlahPemudaBloc.jumlahPemudaStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Padding(
                padding: EdgeInsets.all(18.0),
                child: SizedBox(
                  height: 80,
                  child: Center(child: LoadingBox()),
                ),
              );
            case Status.error:
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  height: 80,
                  child: Text(
                    snapshot.data!.message,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            case Status.completed:
              return _jumlahPemudaWigdet(snapshot.data!.data!.data);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _jumlahPemudaWigdet(JumlahPemuda? data) {
    var total = int.parse(data!.totalLaki!) + int.parse(data.totalPerempuan!);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Icons.man_rounded,
                    size: 42,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '${data.totalLaki}',
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
              child: VerticalDivider(),
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Icons.woman_rounded,
                    size: 42,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '${data.totalPerempuan}',
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12.0,
        ),
        const Divider(
          height: 0,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
          title: const Text(
            'TOTAL',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: Text(
            '$total',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
          ),
        ),
      ],
    );
  }
}
