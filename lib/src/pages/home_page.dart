import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pemuda_baik/src/blocs/auth_bloc.dart';
import 'package:pemuda_baik/src/blocs/user_bloc.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/user_model.dart';
import 'package:pemuda_baik/src/pages/kecamatan_chart.dart';
import 'package:pemuda_baik/src/pages/kelurahan_chart.dart';
import 'package:pemuda_baik/src/pages/pekerjaan_chart.dart';
import 'package:pemuda_baik/src/pages/pendidikan_chart.dart';
import 'package:pemuda_baik/src/pages/profile_page.dart';
import 'package:pemuda_baik/src/pages/widget/error_box.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_response.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
              return Center(
                child: Errorbox(
                    message: snapshot.data!.message,
                    button: true,
                    onTap: () {
                      _userBloc.getUser();
                      setState(() {});
                    }),
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
}
