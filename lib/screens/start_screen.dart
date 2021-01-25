// This file declares the start screen which will handle
// first time settings and the next screen

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katiba/screens/init_load_screen.dart';
import 'package:katiba/utils/navigation.dart';
import 'package:katiba/utils/preferences.dart';

class StartScreen extends StatefulWidget {
  @override
  createState() => new SplashPageState();
}

class SplashPageState extends State<StartScreen> {
  final globalKey = new GlobalKey<ScaffoldState>();

@override
  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 3), _handleTapEvent);
    return MaterialApp(
      home: Scaffold(
      body: Center( 
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new AssetImage("assets/images/splash.jpg"),
              fit: BoxFit.cover
            )
          ),
          )
        )
      )
    ); 
  }

  void _handleTapEvent() async {
    bool katibadbLoaded = await Preferences.isAppdbLoaded();

      if (this.mounted) {
      setState(() {
        if (katibadbLoaded != null && katibadbLoaded)
        {
          pushHomeScreenScreen(context);
        }
        else {
          Navigator.pushReplacement( context, new MaterialPageRoute(builder: (context) => new InitLoadScreen()));
        }
      });
    }
  }

}