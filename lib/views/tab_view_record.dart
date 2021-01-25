import 'dart:async';
import 'package:flutter/material.dart';
import 'package:katiba/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:anisi_controls/anisi_controls.dart';

import 'package:katiba/utils/colors.dart';
import 'package:katiba/helpers/app_settings.dart';
import 'package:katiba/models/record.dart';
import 'package:katiba/helpers/sqlite_helper.dart';
import 'package:katiba/views/record_item.dart';

class TabViewRecord extends StatefulWidget {

  @override
  TabViewRecordState createState() => TabViewRecordState();
}

class TabViewRecordState extends State<TabViewRecord> {
  SqliteHelper db = SqliteHelper();
  AsLoader loader = AsLoader.setUp(ColorUtils.primaryColor);
  AsInformer notice = AsInformer.setUp(3, LangStrings.nothing, Colors.red, Colors.transparent, Colors.white, 10);
  
  Future<Database> dbFuture;
  List<Record> items = List<Record>();
  List<String> letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'R', 'S', 'T', 'U', 'V', 'W', 'Y', 'Z' ];
  String letterSearch;

  TabViewRecordState();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBuild(context));
  }

  /// Method to run anything that needs to be run immediately after Widget build
  void initBuild(BuildContext context) async {
    loadListView();
  }
  
  void loadListView() async {
    loader.showWidget();
    
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Record>> itemListFuture = db.getRecordList();
      itemListFuture.then((resultList) {
        setState(() {
          items = resultList;
          loader.hideWidget();
          if (items.length == 0) notice.showWidget();
          else notice.hideWidget();
        });
      });
    });
  }

  void setSearchingLetter(String _letter) async {
    loader.showWidget();
    letterSearch = _letter;
    items.clear();
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Record>> itemListFuture = db.getRecordSearch(_letter, true);
      itemListFuture.then((resultList) {
        setState(() {
          items = resultList;
          loader.hideWidget();
          if (items.length == 0) notice.showWidget();
          else notice.hideWidget();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Provider.of<AppSettings>(context).isDarkMode ? BoxDecoration()
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [ 0.1, 0.4, 0.6, 0.9 ],
                colors: [ Colors.black, ColorUtils.secondaryColor, ColorUtils.primaryColor, ColorUtils.lightColor ]),
            ),
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 130,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: 25),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return RecordItem('ItemIndex_' + items[index].id.toString(), items[index], context);
              }
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            //margin: EdgeInsets.only(top: 5),
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: letters.length,
                    itemBuilder: lettersView,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            child: notice,
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            height: 200,
            child: Center(
              child: loader,
            ),
          ),
        ],
      ),
    );
  }

  Widget lettersView(BuildContext context, int index) {
    return Container(
      width: 60,
      child: GestureDetector(
        onTap: () {
          setSearchingLetter(letters[index]);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
            side: BorderSide(color: Provider.of<AppSettings>(context).isDarkMode ? ColorUtils.white : ColorUtils.secondaryColor, width: 1.5),
          ),      
          elevation: 5,
          child: Hero(
            tag: letters[index],
            child: Container(
              padding: const EdgeInsets.all(2),
              child: Center(
                child: Text(
                  letters[index],
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class BookItem<T> {
  bool isSelected = false;
  T data;
  BookItem(this.data);
}
