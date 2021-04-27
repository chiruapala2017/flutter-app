import 'package:flutter/material.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:food_app/screens/landing_screen.dart';
import 'package:food_app/screens/skill_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DietScreen extends StatefulWidget {
  static final id = "diet_screen";
  @override
  _DietScreenState createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50.0,
                        child: Image.asset('images/diet_to_fit1.png'),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 3.0),
                    child: new LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      animation: true,
                      lineHeight: 25.0,
                      animationDuration: 2000,
                      percent: 0.33,
                      /*center: Text("90.0%"),*/
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Color(0xFF58B76E),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        Text(
                          'Diet',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'openSan',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Text(
                        'Following any diet?',
                        style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'openSan',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .45,
                    padding: EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Image.asset('images/following_any_diet.png'),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(

                    child: RoundedButton(
                      buttonColor: Color(0xFF58B76E),
                      buttonName: 'Next',
                      buttonAction: () {
                        Navigator.pushNamed(context, SkillScreen.id);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0,5.0,0.0,10.0),
                    child: Center(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LandingScreen(emailId: appUserId, token: token)));
                          },
                          child: Text(
                            'skip',
                            style: TextStyle(color: Color(0xFF58B76E), fontSize: 20.0),
                          ),
                        )),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
