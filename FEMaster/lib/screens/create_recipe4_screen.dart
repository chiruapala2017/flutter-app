import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:food_app/screens/create_recipe5_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/components/alert_dialog_widget.dart';

class CreateRecipe4Screen extends StatefulWidget {
  static final id = "create_recipe4_screen";

  @override
  _CreateRecipe4ScreenState createState() => _CreateRecipe4ScreenState();
}

class _CreateRecipe4ScreenState extends State<CreateRecipe4Screen> {

  final _dishTypeText = TextEditingController();
  final _cuisineText = TextEditingController();
  final _occasionText = TextEditingController();
  final _chefText = TextEditingController();

  @override
  void dispose() {
    _dishTypeText.dispose();
    _cuisineText.dispose();
    _occasionText.dispose();
    _chefText.dispose();
    super.dispose();
  }

  bool validate() {
    if (_dishTypeText.text.isEmpty) {
      return false;
    } else if (_cuisineText.text.isEmpty) {
      return false;
    } else if (_occasionText.text.isEmpty) {
      return false;
    } else if(_chefText.text.isEmpty) {
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
          centerTitle: true,
          toolbarHeight: MediaQuery.of(context).size.height*.07,
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
                    Container(
                      /*height: MediaQuery.of(context).size.height*.11,*/
                      child: Column(
                        children: [
                          Container(
                            color: Color(0xFF535252),
                            child: new LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width,
                              animation: true,
                              lineHeight: 3.0,
                              animationDuration: 2000,
                              percent: 1.00,
                              progressColor: Color(0xFFF16906),
                              backgroundColor: Color(0xFF535252),
                            ),
                          ),
                          Container(
                            height: 70.0,
                            color: Color(0xFFFFCE6C),
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(
                                  'Almost done! Lets add some category and story behind making it. ',
                                  style: TextStyle(
                                      color: Color(0xFF535252),
                                      fontSize: 15.0,
                                      wordSpacing: 2.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      height: MediaQuery.of(context).size.height*.67,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Dish Type',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Color(0xFF535252)),
                                    ),
                                    Text(
                                      ' *',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                TextField(
                                  keyboardType: TextInputType.name,
                                  textAlign: TextAlign.start,
                                  controller: _dishTypeText,
                                  onChanged: (value) {
                                    setState(() {
                                      recipeObject['recipeType'] = value;
                                    });
                                  },
                                  obscureText: false,
                                  decoration: kInputFieldDecoration.copyWith(
                                      hintText: 'E.g. dessert'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Cuisine',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Color(0xFF535252)),
                                    ),
                                    Text(
                                      ' *',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                TextField(
                                  keyboardType: TextInputType.name,
                                  textAlign: TextAlign.start,
                                  controller: _cuisineText,
                                  onChanged: (value) {
                                    setState(() {
                                      recipeObject['cuisine'] = value;
                                    });
                                  },
                                  obscureText: false,
                                  decoration: kInputFieldDecoration.copyWith(
                                      hintText: 'E.g. asian'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Occasion',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Color(0xFF535252)),
                                    ),
                                    Text(
                                      ' *',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                TextField(
                                  keyboardType: TextInputType.name,
                                  textAlign: TextAlign.start,
                                  controller: _occasionText,
                                  onChanged: (value) {
                                    setState(() {
                                      recipeObject['occasion'] = value;
                                    });
                                  },
                                  obscureText: false,
                                  decoration: kInputFieldDecoration.copyWith(
                                      hintText: 'E.g. kids friendly'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Chef Note',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Color(0xFF535252)),
                                    ),
                                    Text(
                                      ' *',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                TextField(
                                  keyboardType: TextInputType.multiline,
                                  textAlign: TextAlign.start,
                                  controller: _chefText,
                                  onChanged: (value) {
                                    setState(() {
                                      recipeObject['chefNote'] = value;
                                    });
                                  },
                                  obscureText: false,
                                  decoration: kInputFieldDecoration.copyWith(
                                      hintText: 'E.g. dessert'),
                                ),
                              ],
                            ),
                          ),
                          /*SizedBox(height: 20.0,)*/
                        ],
                      ),

                    ),
                  ],
                ),
              ),
              Container(
                //height: MediaQuery.of(context).size.height*.13,
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
                            onPressed: () async {
                              bool valid = validate();
                              if (!valid) {
                                AlertDialogWidget alertWidget = AlertDialogWidget(
                                    messages: [Text("Please provide all the information")], context: this.context);
                                await alertWidget.showMyDialog();
                              } else {
                                print(recipeObject);
                                Navigator.pushNamed(context, CreateRecipe5Screen.id);
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width*.35,
                            height: 42.0,
                            child: Text(
                              'Preview before submitting',
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
