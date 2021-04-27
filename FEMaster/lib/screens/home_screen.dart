import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_app/screens/about_screen.dart';
import 'package:food_app/screens/landing_screen.dart';
import 'package:food_app/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  static final id = "home_screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = ColorTween(begin: Color(0xFF54B89E), end: Color(0xFF58B76E))
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null && prefs.getString('email') != null) {
      setState(() {
        token = prefs.getString('token');
        email = prefs.getString('email');
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LandingScreen(
                emailId: email,
                token: token,
              )
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /*backgroundColor: Colors.white,*/
        backgroundColor: animation.value,
        body: GestureDetector(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (prefs.getString('token') != null && prefs.getString('email') != null) {
              getData();
              Navigator.pushNamed(context, AboutScreen.id);
            } else {
              Navigator.pushNamed(context, AboutScreen.id);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset('images/food_station.png',height: 240.0,)
            ],
          ),
        ),
      ),
    );
  }
}


