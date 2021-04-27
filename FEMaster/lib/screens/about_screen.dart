import 'package:flutter/material.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_app/screens/carousal_widget.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:food_app/screens/register_screen.dart';
import 'package:food_app/screens/landing_screen.dart';
import 'package:food_app/screens/contact_page_screen.dart';
import 'package:food_app/utils/constants.dart';

class AboutScreen extends StatefulWidget {
  static final id = "about_screen";
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  List<CarousalWidget> carousalWidgets = List<CarousalWidget>();

  @override
  void initState() {
    CarousalWidget carousalWidget1 = new CarousalWidget(
      headerMessage: 'Find the recipe and learn',
      imagePath: 'images/find_recipe.png',
      footerMessage:
          'The food station helps you to find the recipe for any dish and you can learn from it to cook',
    );
    CarousalWidget carousalWidget2 = new CarousalWidget(
      headerMessage: 'Earn while making video',
      imagePath: 'images/earn_while_making_video.png',
      footerMessage: 'You can create your own recipe video and earn with it.',
    );

    CarousalWidget carousalWidget3 = new CarousalWidget(
      headerMessage: 'Shop while reading or watching recipes',
      imagePath: 'images/shop_recipe.png',
      footerMessage: 'Tern any recipe and make them into shopping list',
    );
    carousalWidgets.add(carousalWidget1);
    carousalWidgets.add(carousalWidget2);
    carousalWidgets.add(carousalWidget3);

    super.initState();
  }

  int _current = 0;

  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(url: "https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=22BZFZ&2Ffitbit_auth&code_challenge=SUkRwWrE0TNdeIjN37WcsFUXzguGFG_jqZ2JZVD9ZNI&code_challenge_method=S256&scope=activity%20nutrition%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight", androidToolbarColor: Colors.deepPurple);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              CarouselSlider(
                items: carousalWidgets,
                options: CarouselOptions(
                    height: 400.0,
                    autoPlay: true,
                    enlargeCenterPage: false,
                    viewportFraction: 1.5,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: carousalWidgets.map((url) {
                  int index = carousalWidgets.indexOf(url);
                  return Container(
                    width: 12.0,
                    height: 12.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 50.0,),
              RoundedButton(
                buttonColor: Color(0xFF58B76E),
                buttonName: 'Signup with Google',
                buttonAction: () => openBrowserTab(),
              ),
              SizedBox(height: 20.0,),
              RoundedButton(
                buttonColor: Color(0xFF58B76E),
                buttonName: 'Sign Up with Email',
                buttonAction: () {
                  Navigator.pushNamed(context, RegisterScreen.id);
                },
              ),
              SizedBox(height: 20.0,),
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                  child: Text(
                    'By sign up I accept the terms of use and data privacy policy',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF535252),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    child: Text(
                      'Log In Here',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xFF58B76E),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
