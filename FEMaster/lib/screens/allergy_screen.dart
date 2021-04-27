import 'package:flutter/material.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:food_app/utils/constants.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'chat_screen.dart';
import 'landing_screen.dart';

class AllergyScreen extends StatefulWidget {
  static final id = "allergy_screen";
  @override
  _AllergyScreenState createState() => _AllergyScreenState();
}

class _AllergyScreenState extends State<AllergyScreen> {

  bool isDiaryClick = false;
  bool isGlutenClick = false;
  bool isEggClick = false;
  bool isSeafoodClick = false;
  bool isNutClick = false;


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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        child: Image.asset('images/diet_to_fit3.png',),
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
                      percent: 1.0,
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
                          'Allergies',
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
                    padding: EdgeInsets.fromLTRB(20.0,15.0,20.0,50.0),
                    child: Center(
                      child: Text(
                        'Suffering from any allergies?',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AllergyBox(
                              is_click: isDiaryClick,
                              boxText: 'No diary',
                              onChangeCall: (){
                                setState(() {
                                  isDiaryClick = !isDiaryClick;
                                });
                              },
                            ),
                            AllergyBox(
                              is_click: isGlutenClick,
                              boxText: 'No Gluten',
                              onChangeCall: (){
                                setState(() {
                                  isGlutenClick = !isGlutenClick;
                                });
                              },
                            ),

                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AllergyBox(
                              is_click: isEggClick,
                              boxText: 'No Egg',
                              onChangeCall: (){
                                setState(() {
                                  isEggClick = !isEggClick;
                                });
                              },
                            ),
                            AllergyBox(
                              is_click: isSeafoodClick,
                              boxText: 'No Seafood',
                              onChangeCall: (){
                                setState(() {
                                  isSeafoodClick = !isSeafoodClick;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AllergyBox(
                              is_click: isNutClick,
                              boxText: 'No nuts',
                              onChangeCall: (){
                                setState(() {
                                  isNutClick = !isNutClick;
                                });
                              },
                            ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LandingScreen(emailId: appUserId, token: token)));
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AllergyBox extends StatelessWidget {

  final bool is_click;
  final String boxText;
  final Function onChangeCall;

  const AllergyBox({Key key, this.boxText, this.onChangeCall, this.is_click}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 2.0,
        color: Color(0xFFF0EDED),
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          onPressed: onChangeCall,
          minWidth: MediaQuery.of(context).size.width*.35,
          height: 42.0,
          child: Text(
            boxText,
            style: TextStyle(color: is_click != true ? Colors.black : Color(0xFF58B76E), fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
