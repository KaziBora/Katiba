import 'package:anisi_controls/anisi_controls.dart';
import 'package:flutter/material.dart';
import 'package:katiba/helpers/sqlite_helper.dart';
import 'package:katiba/models/record.dart';

import 'package:katiba/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:katiba/helpers/app_settings.dart';
import 'package:katiba/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  SqliteHelper db = SqliteHelper();
  AsLoader loader = AsLoader.setUp(ColorUtils.primaryColor);
  AsInformer notice = AsInformer.setUp(3, LangStrings.nothing, Colors.red, Colors.transparent, Colors.white, 10);
  
  Future<Database> dbFuture;
  List<Record> items = List<Record>();
  double mHeight, mWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBuild(context));
  }

  /// Method to run anything that needs to be run immediately after Widget build
  void initBuild(BuildContext context) async {
    //informer.showWidget();
    //requestData();
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(LangStrings.appName),
      ),
      body: mainBody(),
    );
    
  }

  Widget mainBody()
  {
    return Container(
      height: mHeight,
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash.jpg"),
            fit: BoxFit.cover)
        ),
        child: homeListView(),
      );
  }

  Widget homeListView()
  {
    return ListView(
      key: const ValueKey('HomeListView'),
      children: [
        /*Container(
          height: mWidth / 1.5,
          child: Row(
            children: [
              Container(
                width: mWidth / 2,
                child: carouselCard(),
              ),
              Container(
                width: mWidth / 2,
                child: carouselCard(),
              ),
            ]
          ),
        ),*/
        Container(
          height: mWidth / 2,
          child: carouselCard(),
        ),
        Container(
          height: mWidth / 2,
          child: carouselCard(),
        ),
        Container(
          height: mWidth / 2,
          child: carouselCard(),
        ),
      ]
    );
  }

  Widget carouselCard()
  {
    return Container(
      // Makes integration tests possible.
      //key: ValueKey(demo.describe),
      margin: EdgeInsets.all(8.0),
      child: Material(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            //Navigator.of(context).restorablePushNamed(studyRoute);
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Card Title',
                      //style: textTheme.caption.apply(color: textColor),
                      maxLines: 3,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      'Card Subtitle',
                      //style: textTheme.overline.apply(color: textColor),
                      maxLines: 5,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
