import 'package:flutter/material.dart';

import 'package:katiba/widgets/as_search.dart';
import 'package:katiba/views/main_view.dart';
import 'package:katiba/models/record.dart';
import 'package:katiba/helpers/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = new ScrollController();
  double offset = 0.0;

  SqliteHelper db = SqliteHelper();
  List<Record> itemList;

  void updateItemList() {
    final Future<Database> dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Record>> recordListFuture = db.getRecordList();
      recordListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
        });
      });
    });
  }

  Widget _header() => SliverAppBar(
    title: Container(child: AsSearch(scaffoldKey, itemList)),
    elevation: 0.0,
    automaticallyImplyLeading: false,
  );

  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = [];
      updateItemList();
    }

    return Scaffold(
      key: scaffoldKey,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _header(),
          ];
        },
        body: MainView(scrollController: _scrollController),
      ),
    );

  }
}
