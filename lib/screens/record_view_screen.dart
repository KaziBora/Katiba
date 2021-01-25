// This file declares the content view screen

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';

import 'package:katiba/utils/constants.dart';
import 'package:katiba/helpers/app_settings.dart';
import 'package:katiba/helpers/sqlite_helper.dart';
import 'package:katiba/models/record.dart';

class RecordViewScreen extends StatefulWidget {
  final Record record;

  RecordViewScreen(this.record);

  @override
  State<StatefulWidget> createState() {
    return EeRecordViewScreenState(this.record);
  }
}

class EeRecordViewScreenState extends State<RecordViewScreen> {
  EeRecordViewScreenState(this.record);
  final globalKey = new GlobalKey<ScaffoldState>();
  SqliteHelper db = SqliteHelper();

  var appBar = AppBar(), recordVerses;
  Record record;
  int curRecord = 0;
  String recordContent;
  List<String> meanings, synonyms;
  List<Record> records;

  @override
  Widget build(BuildContext context) {
    curRecord = record.id;
    recordContent = record.title + " ni record la Kiswahili lenye meaning:";
    bool isFavourited(int favorite) => favorite == 1 ?? false;

    if (meanings == null) {
      meanings = List<String>();
      synonyms = List<String>();
      processData();
    }

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(LangStrings.appName),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                isFavourited(record.isfav) ? Icons.star : Icons.star_border,
              ),
              onPressed: () => favoriteThis(),
            )
          ],
        ),
        body: mainBody(),
        floatingActionButton: AnimatedFloatingActionButton(
          fabButtons: floatingButtons(),
          animatedIconData: AnimatedIcons.menu_close,
        ),
      ),
    );
  }

  Widget mainBody() {
    return Container(
      decoration: Provider.of<AppSettings>(context).isDarkMode
          ? BoxDecoration()
          : BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.cyan, Colors.indigo]),
            ),
      child: new Stack(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Html(
              data: "<h3>" + record.title + "</h3>",
              style: {
                "h3": Style(
                    fontSize: FontSize(30.0),
                    color: Provider.of<AppSettings>(context).isDarkMode
                        ? Colors.white
                        : Colors.black),
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 100,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: 60),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: meanings.length,
              itemBuilder: listView,
            ),
          ),
        ],
      ),
    );
  }

  Widget listView(BuildContext context, int index) {
    var strContents = meanings[index].split(":");
    String strContent = meanings[index];

    recordContent = recordContent + "\n - " + meanings[index];

    return Card(
      elevation: 2,
      child: GestureDetector(
        child: Html(
          data: "<ul><li>" + strContent + "</li></ul>",
          style: {
            "li": Style(
              fontSize: FontSize(25.0),
            ),
            "p": Style(
              fontSize: FontSize(22.0),
            ),
          },
        ),
      ),
    );
  }

  List<Widget> floatingButtons() {
    return <Widget>[
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.content_copy),
        tooltip: LangStrings.copyThis,
        onPressed: copyItem,
      ),
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.share),
        tooltip: LangStrings.shareThis,
        onPressed: shareItem,
      ),
    ];
  }

  void copyItem() {
    Clipboard.setData(ClipboardData(text: recordContent + LangStrings.campaign));
    globalKey.currentState.showSnackBar(new SnackBar(
      content: new Text(LangStrings.recordCopied),
    ));
  }

  void shareItem() {
    Share.share(
      recordContent + LangStrings.campaign,
      subject: "Shiriki record: " + record.title,
    );
  }

  void favoriteThis() {
    if (record.isfav == 1)
      db.favouriteRecord(record, false);
    else
      db.favouriteRecord(record, true);
    globalKey.currentState.showSnackBar(new SnackBar(
      content: new Text(record.title + " " + LangStrings.recordLiked),
    ));
    //notifyListeners();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void processData() async {
    recordContent = record.title;
    meanings = [];
    synonyms = [];

    try {
      String strMeaning = record.body;
      strMeaning = strMeaning.replaceAll("\\", "");
      strMeaning = strMeaning.replaceAll('"', '');

      var strMeanings = strMeaning.split("|");

      if (strMeanings.length > 1) {
        for (int i = 0; i < strMeanings.length; i++) {
          meanings.add(strMeanings[i]);
        }
      } else {
        meanings.add(strMeanings[0]);
      }
    } catch (Exception) {}

  }
}
