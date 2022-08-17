import 'package:flutter/material.dart';
import 'package:pemuda_baik/src/config/color_style.dart';
import 'package:pemuda_baik/src/models/dashboard_chart_model.dart';

class TabDetail extends StatefulWidget {
  const TabDetail({
    Key? key,
    required this.data,
    required this.tabBarView,
  }) : super(key: key);

  final List<JenisData> data;
  final List<Widget> tabBarView;

  @override
  State<TabDetail> createState() => _TabDetailState();
}

class _TabDetailState extends State<TabDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.data.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(
              4.0,
            ),
            color: kPrimaryColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8.0),
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          controller: _tabController,
          tabs: widget.data
              .map(
                (e) => Tab(
                  text: e.nama,
                ),
              )
              .toList(),
        ),
        Flexible(
          child: TabBarView(
              controller: _tabController, children: widget.tabBarView),
        ),
      ],
    );
  }
}
