import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/pages/artikel_page.dart';
import 'package:pemuda_baik/src/pages/bursa_kerja_page.dart';
import 'package:pemuda_baik/src/pages/data_page.dart';
import 'package:pemuda_baik/src/pages/home_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class Rootpage extends StatefulWidget {
  const Rootpage({Key? key}) : super(key: key);

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const Homepage(),
      const Datapage(),
      const ArtikelPage(),
      const BursaKerjaPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navbarsItem() {
    return [
      PersistentBottomNavBarItem(
        icon: const FaIcon(
          FontAwesomeIcons.house,
        ),
        title: "Home",
        iconSize: 20,
        activeColorPrimary: kPrimaryDarkColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(
          FontAwesomeIcons.database,
        ),
        title: "Pemuda",
        iconSize: 20,
        activeColorPrimary: kPrimaryDarkColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(
          FontAwesomeIcons.solidNewspaper,
        ),
        title: "Artikel",
        iconSize: 20,
        activeColorPrimary: kPrimaryDarkColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(
          FontAwesomeIcons.solidCalendarPlus,
        ),
        title: "Bursa",
        iconSize: 20,
        activeColorPrimary: kPrimaryDarkColor,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navbarsItem(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      decoration:
          const NavBarDecoration(colorBehindNavBar: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(1.0, -2.0),
        )
      ]),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }
}
