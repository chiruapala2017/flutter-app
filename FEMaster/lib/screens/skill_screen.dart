import 'package:flutter/material.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:food_app/screens/allergy_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'landing_screen.dart';

class SkillScreen extends StatefulWidget {
  static final id = "skill_screen";
  @override
  _SkillScreenState createState() => _SkillScreenState();
}

class _SkillScreenState extends State<SkillScreen> {
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50.0,
                        child: Image.asset('images/diet_to_fit1.png'),
                      ),
                      Container(
                        height: 50.0,
                        child: Image.asset('images/diet_to_fit2.png'),
                      ),
                      Container(
                        height: 50.0,
                        child: Image.asset('images/diet_to_fit2.png', color: Colors.white,),
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
                      percent: 0.60,
                      /*center: Text("90.0%"),*/
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Color(0xFF58B76E),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diet',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'openSan',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Skill',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'openSan',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Skill',
                          style: TextStyle(
                              color: Colors.white,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0,0.0,20.0,50.0),
                    child: Center(
                      child: Text(
                        'Perfect in any cooking skills?',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'openSan',
                          fontWeight: FontWeight.bold, ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,25.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('images/cooking_skill1.png'),
                            Image.asset('images/cooking_skill2.png'),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('images/cooking_skill3.png'),
                            Image.asset('images/cooking_skill4.png'),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: RoundedButton(
                      buttonColor: Color(0xFF58B76E),
                      buttonName: 'Next',
                      buttonAction: () {
                        Navigator.pushNamed(context, AllergyScreen.id);
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
