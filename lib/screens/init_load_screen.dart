// This file declares the database initialization screen

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:anisi_controls/anisi_controls.dart';

import 'package:katiba/models/record.dart';
import 'package:katiba/utils/constants.dart';
import 'package:katiba/utils/colors.dart';
import 'package:katiba/utils/preferences.dart';
import 'package:katiba/helpers/sqlite_assets.dart';
import 'package:katiba/helpers/sqlite_helper.dart';
import 'package:katiba/screens/start_screen.dart';

class InitLoadScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InitLoadState();
  }
}

class InitLoadState extends State<InitLoadScreen> {
  final globalKey = new GlobalKey<ScaffoldState>();
  
  AsLineProgress progress = AsLineProgress.setUp(0, Colors.black, Colors.black, ColorUtils.secondaryColor);
  AsInformer informer = AsInformer.setUp(1, LangStrings.gettingReady, ColorUtils.primaryColor, Colors.transparent, Colors.white, 10);
  
  SqliteHelper db = SqliteHelper();
  SqliteAssets adb = SqliteAssets();

  List<Record> records =List<Record>();

  Future<Database> dbAssets;
  Future<Database> dbFuture;

  double mHeight, mWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBuild(context));
  }

  /// Method to run anything that needs to be run immediately after Widget build
  void initBuild(BuildContext context) async {
    informer.showWidget();
    requestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: mainBody(),
    );
  }

  Widget informant()
  {
    return Container(
      decoration: new BoxDecoration( 
          color: Colors.white,
          border: Border.all(color: Colors.green),
          boxShadow: [BoxShadow(blurRadius: 5)],
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: _getCenterContent(),
        ),
    );
  }

  Widget _getCenterContent() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
                padding: const EdgeInsets.all(10),
                child:  _getCircularProgress(),
          ),              
          Container(
            width: MediaQuery.of(context).size.width - 150,
            child: Text(
              "Loading ...", style: TextStyle(color: Colors.green, fontSize: 18), softWrap: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _getCircularProgress() {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.green));
  }

  Widget mainBody() {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;
    
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash.jpg"),
          fit: BoxFit.cover)
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: mHeight / 1.5),
        child: Stack(
          children: <Widget>[
            Container(
              height: 150,
              child: Center(
                child: informer,
              ),
            ),
            Container(
              height: 37,
              margin: EdgeInsets.only(top: 110),
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                child: progress,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void requestData() async {
    dbAssets = adb.initializeDatabase();
    dbAssets.then((database) {
      Future<List<Record>> recordListAsset = adb.getRecordList();
      recordListAsset.then((recordList) {
        setState(() {
          records = recordList;
          _goToNextScreen();
        });
      });
    });
  }

  Future<void> saveRecordsData() async {
    for (int i = 0; i < records.length; i++) {
      int progressValue = (i / records.length * 100).toInt();
      progress.setProgress(progressValue);

      switch (progressValue) {
        case 1:
          informer.setText("Loading data ...");
          break;
        case 20:
          informer.setText("Be patient ...");
          break;
        case 40:
          informer.setText("Because patience pays ...");
          break;
        case 75:
          informer.setText("Thanks for your patience!");
          break;
        case 85:
          informer.setText("Finally!");
          break;
        case 95:
          informer.setText("Almost done");
          break;
      }

      Record item = records[i];

      Record record = new Record(item.type, item.refid, item.number, item.title, item.body);

      await db.insertRecord(record);
    }
  }

  Future<void> _goToNextScreen() async {
    await saveRecordsData();

    Preferences.setAppdbLoaded(true);
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new StartScreen()));
  }
  
}
