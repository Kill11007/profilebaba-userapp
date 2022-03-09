import 'dart:async';

import 'package:flutter/material.dart';
import 'package:profilebab/Screens/Login.dart';
import 'package:profilebab/bottomnav/bottommain.dart';
import 'package:profilebab/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () => {checkFirstSeen()});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset('assets/images/logo.png')));
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(prefs.getBool("is_login"));
    print("valur");
    setState(() {});

    if (prefs.getBool("is_login") == true) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new BottomDas()));
    } else {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new LoginPage()));
    }
  }
}
