import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/create_recipe_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'create_recipe3_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/components/alert_dialog_widget.dart';

class CreateRecipe2Screen extends StatefulWidget {
  static final id = "create_recipe2_screen";
  @override
  _CreateRecipe2ScreenState createState() => _CreateRecipe2ScreenState();
}

class _CreateRecipe2ScreenState extends State<CreateRecipe2Screen> {

  String servings;
  String prepTime;
  String bakingTime;
  String restingTime;
  final _portionTypeText = TextEditingController();
  final _prepTimeText = TextEditingController();
  final _bakingTimeText = TextEditingController();
  final _restingTimeText = TextEditingController();

  @override
  void dispose() {
    _portionTypeText.dispose();
    _prepTimeText.dispose();
    _bakingTimeText.dispose();
    _restingTimeText.dispose();
    super.dispose();
  }

  void updateRecipeObject() {
    setState(() {
      recipeObject['servings'] = servings;
      recipeObject['prep_time'] = prepTime;
      recipeObject['baking_time'] = bakingTime;
      recipeObject['resting_time'] = restingTime;
    });
  }

  bool validate() {
    if (_portionTypeText.text.isEmpty) {
      return false;
    } else if (_prepTimeText.text.isEmpty) {
      return false;
    } else if (_bakingTimeText.text.isEmpty) {
      return false;
    } else if (_restingTimeText.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset : false,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height*.07,
          centerTitle: true,
          title: Text('Create Recipe'),
          backgroundColor: Color(0xFF58B76E),
          actions: [
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                // do something
              },
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height*.93,
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*.8,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Color(0xFF535252),
                          child: new LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width,
                            animation: true,
                            lineHeight: 3.0,
                            animationDuration: 2000,
                            percent: 0.50,
                            progressColor: Color(0xFFF16906),
                            backgroundColor: Color(0xFF535252),
                          ),
                        ),
                        Container(
                          height: 70.0,
                          color: Color(0xFFFFCE6C),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Something’s cooking! Let’s add a few more details ...!',
                              style: TextStyle(
                                  color: Color(0xFF535252),
                                  fontSize: 15.0,
                                  wordSpacing: 2.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      //padding: EdgeInsets.symmetric(vertical: 10.0),
                      height: MediaQuery.of(context).size.height*.65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Portion Type', style: TextStyle(color: Color(0xFF535252), fontSize: 20.0, fontWeight: FontWeight.bold),),
                                        Text(' *', style: TextStyle(color: Color(0xFFC30202)),)
                                      ],
                                    ),
                                    Text('Choose beetween', style: TextStyle(color: Color(0xFF535252),),),
                                    Text('Serving of pieces', style: TextStyle(color: Color(0xFF535252),),),
                                  ],
                                ),
                                //Text('Choose beetween', style: TextStyle(color: Color(0xFF535252),),),
                                Container(
                                  width: MediaQuery.of(context).size.width*.5,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _portionTypeText,
                                    textAlign: TextAlign.justify,
                                    onChanged: (value) {
                                      setState(() {
                                        servings = value;
                                      });
                                    },
                                    obscureText: false,
                                    decoration: kInputFieldDecoration.copyWith(hintText: 'E.g. 2 serving/pieces'),

                                  ),
                                ),

                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Prep Time', style: TextStyle(color: Color(0xFF535252), fontSize: 20.0, fontWeight: FontWeight.bold),),
                                        Text(' *', style: TextStyle(color: Color(0xFFC30202)),)
                                      ],
                                    ),
                                    Text('How much time', style: TextStyle(color: Color(0xFF535252),),),
                                    Text('do you actively', style: TextStyle(color: Color(0xFF535252),),),
                                    Text('spend making', style: TextStyle(color: Color(0xFF535252),),),
                                    Text('the dish?', style: TextStyle(color: Color(0xFF535252),),),
                                  ],
                                ),
                                //Text('Choose beetween', style: TextStyle(color: Color(0xFF535252),),),
                                Container(
                                  width: MediaQuery.of(context).size.width*.5,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _prepTimeText,
                                    textAlign: TextAlign.justify,
                                    onChanged: (value) {
                                      setState(() {
                                        prepTime = value;
                                      });
                                    },
                                    obscureText: false,
                                    decoration: kInputFieldDecoration.copyWith(hintText: 'E.g. 00 min'),

                                  ),
                                ),

                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Baking Time', style: TextStyle(color: Color(0xFF535252), fontSize: 20.0, fontWeight: FontWeight.bold),),
                                        Text(' *', style: TextStyle(color: Color(0xFFC30202)),)
                                      ],
                                    ),
                                    Text('How long does', style: TextStyle(color: Color(0xFF535252),),),
                                    Text('the dish to', style: TextStyle(color: Color(0xFF535252),),),
                                    Text('bake for?', style: TextStyle(color: Color(0xFF535252),),),
                                  ],
                                ),
                                //Text('Choose beetween', style: TextStyle(color: Color(0xFF535252),),),
                                Container(
                                  width: MediaQuery.of(context).size.width*.5,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _bakingTimeText,
                                    textAlign: TextAlign.justify,
                                    onChanged: (value) {
                                      setState(() {
                                        bakingTime = value;
                                      });
                                    },
                                    obscureText: false,
                                    decoration: kInputFieldDecoration.copyWith(hintText: 'E.g. 00 min'),

                                  ),
                                ),

                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Resting Time', style: TextStyle(color: Color(0xFF535252), fontSize: 20.0, fontWeight: FontWeight.bold),),
                                        Text(' *', style: TextStyle(color: Color(0xFFC30202)),)
                                      ],
                                    ),
                                    Text('Does the dish', style: TextStyle(color: Color(0xFF535252),),),
                                    Text('to rest at any', style: TextStyle(color: Color(0xFF535252),),),
                                    Text('point? eg Rising', style: TextStyle(color: Color(0xFF535252),),),
                                    Text('time, marination', style: TextStyle(color: Color(0xFF535252),),),
                                  ],
                                ),
                                //Text('Choose beetween', style: TextStyle(color: Color(0xFF535252),),),
                                Container(
                                  width: MediaQuery.of(context).size.width*.5,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _restingTimeText,
                                    textAlign: TextAlign.justify,
                                    onChanged: (value) {
                                      setState(() {
                                        restingTime = value;
                                      });
                                    },
                                    obscureText: false,
                                    decoration: kInputFieldDecoration.copyWith(hintText: 'E.g. 2 serving/pieces'),

                                  ),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 15.0),
                child: Column(
                  children: [
                    Image.asset(
                      'images/border_line.png',
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(
                          elevation: 2.0,
                          color: Color(0xFF58B76E),
                          /*borderRadius: BorderRadius.circular(10.0),*/
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFF58B76E))
                          ),
                          child: MaterialButton(
                            onPressed: (){
                              Navigator.pop(context);
                              //Navigator.pushNamed(context, CreateRecipeScreen.id);
                            },
                            minWidth: MediaQuery.of(context).size.width*.35,
                            height: 42.0,
                            child: Text(
                              'Previous',
                              style: TextStyle(color: Colors.white , fontSize: 15.0,),
                            ),
                          ),
                        ),
                        Material(
                          elevation: 2.0,
                          color: Color(0xFF58B76E),
                          /*borderRadius: BorderRadius.circular(10.0),*/
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFF58B76E))
                          ),
                          child: MaterialButton(
                            onPressed: () async {
                              bool valid = validate();
                              if (!valid) {
                                AlertDialogWidget alertWidget = AlertDialogWidget(
                                    messages: [Text("Please provide all the information")], context: this.context);
                                await alertWidget.showMyDialog();
                              } else {
                                updateRecipeObject();
                                Navigator.pushNamed(context, CreateRecipe3Screen.id);
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width*.35,
                            height: 42.0,
                            child: Text(
                              'Next',
                              style: TextStyle(color: Colors.white , fontSize: 15.0),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
