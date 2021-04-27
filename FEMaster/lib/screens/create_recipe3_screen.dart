import 'package:flutter/material.dart';
import 'package:food_app/utils/urls.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'package:food_app/screens/create_recipe4_screen.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:food_app/utils/constants.dart';

class CreateRecipe3Screen extends StatefulWidget {
  static final id = "create_recipe3_screen";
  @override
  _CreateRecipe3ScreenState createState() => _CreateRecipe3ScreenState();
}

class _CreateRecipe3ScreenState extends State<CreateRecipe3Screen> {
  List<AddIngredient> ingredients = List<AddIngredient>();
  List<AddStepWidget> steps = List<AddStepWidget>();

  int ingredientCounter = 0;
  int stepCounter = 0;

  @override
  void initState() {
    super.initState();
    recipeObject['ingredients'] = [];
    recipeObject['steps'] = "";
  }

  void addNewIngredientField() {
    setState(() {
      ingredients.add(new AddIngredient(
        widgetId: ingredientCounter,
      ));
      ingredientCounter++;
    });
  }

  void addNewStepField() {
    setState(() {
      steps.add(new AddStepWidget(
        stepId: stepCounter,
      ));
      stepCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: MediaQuery.of(context).size.height * .07,
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
          height: MediaQuery.of(context).size.height * .93,
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .8,
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            color: Color(0xFF535252),
                            child: new LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width,
                              animation: true,
                              lineHeight: 3.0,
                              animationDuration: 2000,
                              percent: 0.75,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  'A recipe would be nothing without the ingredients and steps! ',
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
                      height: MediaQuery.of(context).size.height * .06,
                      color: Colors.green.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Ingredients',
                            style: TextStyle(
                                color: Color(0xFF535252),
                                fontSize: 20.0,
                                wordSpacing: 2.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              addNewIngredientField();
                            },
                            child: Icon(
                              Icons.add_circle,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      //color: Colors.blue,
                      height: MediaQuery.of(context).size.height * .28,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: ingredients != null ? ingredients : [],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .06,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      color: Colors.green.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Steps',
                            style: TextStyle(
                                color: Color(0xFF535252),
                                fontSize: 20.0,
                                wordSpacing: 2.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              addNewStepField();
                            },
                            child: Icon(
                              Icons.add_circle,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .29,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: steps != null ? steps : [],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              side: BorderSide(color: Color(0xFF58B76E))),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              //Navigator.pushNamed(context, CreateRecipe2Screen.id);
                            },
                            minWidth: MediaQuery.of(context).size.width * .35,
                            height: 42.0,
                            child: Text(
                              'Previous',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        Material(
                          elevation: 2.0,
                          color: Color(0xFF58B76E),
                          /*borderRadius: BorderRadius.circular(10.0),*/
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFF58B76E))),
                          child: MaterialButton(
                            onPressed: () {
                              print(recipeObject);
                              Navigator.pushNamed(
                                  context, CreateRecipe4Screen.id);
                            },
                            minWidth: MediaQuery.of(context).size.width * .35,
                            height: 42.0,
                            child: Text(
                              'Next',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
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

class AddStepWidget extends StatefulWidget {
  final int stepId;

  const AddStepWidget({Key key, this.stepId}) : super(key: key);
  @override
  _AddStepWidgetState createState() => _AddStepWidgetState();
}

class _AddStepWidgetState extends State<AddStepWidget> {
  String stepText = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        keyboardType: TextInputType.name,
        textAlign: TextAlign.justify,
        onChanged: (value) {
          setState(() {
            stepText = stepText;
          });
        },
        onSubmitted: (value) {
          setState(() {
            recipeObject['steps'] =
                recipeObject['steps'] + stepText + '$value\n';
          });
        },
        obscureText: false,
        decoration: kInputFieldDecoration.copyWith(hintText: 'E.g. Step'),
      ),
    );
  }
}

class AddIngredient extends StatefulWidget {
  final int widgetId;
  const AddIngredient({Key key, this.widgetId}) : super(key: key);
  @override
  _AddIngredientState createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  static const units = [
    'Select Qty',
    'teaspoon',
    'tableSpoon',
    'gm',
    'kg',
    'ml',
    'ltr'
  ];
  String dropdownValue = 'Select Qty';
  String name;
  String selectedValue;
  String qty;
  List ingredientsObj = [
    {'id': 1, 'name': 'Onion'},
    {'id': 2, 'name': 'Salt'},
    {'id': 3, 'name': 'Vinegar'},
    {'id': 4, 'name': 'basil'},
    {'id': 5, 'name': 'parsley'},
    {'id': 6, 'name': 'garlic'},
    {'id': 7, 'name': 'Olive oil,'},
    {'id': 8, 'name': 'Coconut,'},
    {'id': 9, 'name': 'Baking Soda,'},
    {'id': 10, 'name': 'Chicken,'},
    {'id': 11, 'name': 'sugar,'}
  ];
  var ingredients = {};

  @override
  void initState() {
    super.initState();
    getIngredients();
  }

  void getIngredients() async {
    try {
      String url = ingredients_url;
      final http.Response response = await http.get(url, headers: {
        "Authorization": "Token $token",
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      responseData['results'].forEach((i) {
        setState(() {
          ingredientsObj.add(i);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  List<DropdownMenuItem> getDropDownItemList() {
    List<DropdownMenuItem> items = List<DropdownMenuItem>();

    for (int i = 0; i < ingredientsObj.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(ingredientsObj[i]['name']),
        value: '${ingredientsObj[i]['name']}-${ingredientsObj[i]['id']}',
      ));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * .40,
              //height: 50.0,
              child: SearchableDropdown.single(
                items: getDropDownItemList(),
                isExpanded: true,
                hint: "Select item",
                displayClearIcon: false,
                searchHint: "Select one",
                iconSize: 40.0,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value.toString();
                    ingredients['name'] = value;
                  });
                },
              )),
          Container(
            width: MediaQuery.of(context).size.width * .20,
            child: TextField(
              keyboardType: TextInputType.name,
              textAlign: TextAlign.justify,
              onChanged: (value) {
                setState(() {
                  qty = value;
                  ingredients['quantity'] = qty;
                });
              },
              obscureText: false,
              decoration: kInputFieldDecoration.copyWith(hintText: 'Qty'),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .3,
            padding: EdgeInsets.only(top: 10.0),
            child: DropdownButton(
              hint: Text('Select Qty'),
              value: dropdownValue,
              icon: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Icon(Icons.arrow_downward),
              ),
              style: TextStyle(color: Color(0xFF535252)),
              underline: Container(
                height: 1,
                color: Color(0xFF535252),
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  ingredients['unit'] = dropdownValue;
                  recipeObject['ingredients'].add(ingredients);
                  ingredients = {};
                });
              },
              items: units.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
