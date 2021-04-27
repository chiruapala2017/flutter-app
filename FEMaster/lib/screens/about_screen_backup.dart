import 'package:flutter/material.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AboutScreenBackup extends StatefulWidget {
  static final id = "about_screen";
  @override
  _AboutScreenBackupState createState() => _AboutScreenBackupState();
}

class _AboutScreenBackupState extends State<AboutScreenBackup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text(
              'Find the recipe and learn',
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
            ),
          ),
          Image.asset(
            'images/find_recipe.png',
          ),
          RoundedButton(
            buttonColor: Color(0xFF58B76E),
            buttonName: 'Sign Up with Facebook',
            buttonAction: () {},
          ),
          RoundedButton(
            buttonColor: Color(0xFF58B76E),
            buttonName: 'Sign Up with Email',
            buttonAction: () {},
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              child: Text(
                'By sign up I accept the terms of use and data privacy policy',
                style: TextStyle(fontSize: 12.0,color: Color(0xFF535252),),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5.0,),
              Text(
                'Log In Here',
                style: TextStyle(fontSize: 15.0, color: Color(0xFF58B76E),),
              ),
            ],
          )
        ],
      ),
    );
  }
}
