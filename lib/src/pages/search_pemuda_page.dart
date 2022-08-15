import 'package:flutter/material.dart';
import 'package:pemuda_baik/src/pages/widget/search_input_widget.dart';

class SearchPemudaPage extends StatefulWidget {
  const SearchPemudaPage({Key? key}) : super(key: key);

  @override
  State<SearchPemudaPage> createState() => _SearchPemudaPageState();
}

class _SearchPemudaPageState extends State<SearchPemudaPage> {
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      //
    } else {
      //
    }
    setState(() {});
  }

  @override
  void dispose() {
    _filter.removeListener(_filterListen);
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 18,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: SearchInputWidget(
                    controller: _filter,
                    hint: 'Pencarian nama',
                    onClear: () {
                      _filter.clear();
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
