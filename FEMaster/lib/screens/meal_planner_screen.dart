import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/components/appbar.dart';
import 'package:food_app/components/barcode_scanner_screen.dart';
import 'package:food_app/components/bottom_widget.dart';
import 'package:food_app/components/expansion_tile_widget.dart' as custom;
import 'package:food_app/screens/health_profile_screen.dart';
import 'package:food_app/screens/nutrition_details_screen.dart';
import 'package:random_color/random_color.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'cast_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/utils/urls.dart';


class MealPlannerScreen extends StatefulWidget {
  static final id = "meal_planner_screen";

  @override
  _MealPlannerScreenState createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  RandomColor _randomColor = RandomColor();
  Map<String, double> dataMap = {
    "Fat": 5,
    "Protein": 3,
    "Carbohydrate": 2,
  };

  String dropdownValue = 'Weekly';
  List _selectedEvents;
  DateTime _selectedDay;
  String targetCalories = '0.0';
  String targetCarbs = '0.0';
  String targetFat = '0.0';
  String targetProtein = '0.0';
  bool showSpinner = false;

  Map<DateTime, List> _events = {
    DateTime(2021, 04, 23): [
      {
        'name': 'Breakfast',
        'isDone': true,
        'meals': [
          {'recipeId': 1, 'recipeName': 'Poha'},
          {'recipeId': 2, 'recipeName': 'Green Tea'},
          {'recipeId': 3, 'recipeName': 'Milk Shake'}
        ]
      },
      {
        'name': 'Lunch',
        'isDone': true,
        'meals': [
          {'recipeId': 4, 'recipeName': 'Chicken Biriyani'},
          {'recipeId': 5, 'recipeName': 'Mutton Curry'},
          {'recipeId': 6, 'recipeName': 'Gulaab Jamun'}
        ]
      },
      {
        'name': 'Dinner',
        'isDone': true,
        'meals': [
          {'recipeId': 7, 'recipeName': 'Hilsa Curry'},
          {'recipeId': 8, 'recipeName': 'Pulao'},
          {'recipeId': 9, 'recipeName': 'Buttermilk'}
        ]
      },
    ],
    DateTime(2021, 04, 24): [
      {
        'name': 'Breakfast',
        'isDone': true,
        'meals': [
          {'recipeId': 1, 'recipeName': 'Poha'},
          {'recipeId': 2, 'recipeName': 'Green Tea'},
          {'recipeId': 3, 'recipeName': 'Milk Shake'}
        ]
      },
      {
        'name': 'Lunch',
        'isDone': true,
        'meals': [
          {'recipeId': 4, 'recipeName': 'Chicken Biriyani'},
          {'recipeId': 5, 'recipeName': 'Mutton Curry'},
          {'recipeId': 6, 'recipeName': 'Gulaab Jamun'}
        ]
      },
      {
        'name': 'Dinner',
        'isDone': true,
        'meals': [
          {'recipeId': 7, 'recipeName': 'Hilsa Curry'},
          {'recipeId': 8, 'recipeName': 'Pulao'},
          {'recipeId': 9, 'recipeName': 'Buttermilk'}
        ]
      },
    ],
    DateTime(2021, 04, 25): [
      {
        'name': 'Breakfast',
        'isDone': true,
        'meals': [
          {'recipeId': 1, 'recipeName': 'Poha'},
          {'recipeId': 2, 'recipeName': 'Green Tea'},
          {'recipeId': 3, 'recipeName': 'Milk Shake'}
        ]
      },
      {
        'name': 'Lunch',
        'isDone': true,
        'meals': [
          {'recipeId': 4, 'recipeName': 'Chicken Biriyani'},
          {'recipeId': 5, 'recipeName': 'Mutton Curry'},
          {'recipeId': 6, 'recipeName': 'Gulaab Jamun'}
        ]
      },
      {
        'name': 'Dinner',
        'isDone': true,
        'meals': [
          {'recipeId': 7, 'recipeName': 'Hilsa Curry'},
          {'recipeId': 8, 'recipeName': 'Pulao'},
          {'recipeId': 9, 'recipeName': 'Buttermilk'}
        ]
      },
    ],
    DateTime(2021, 04, 26): [
      {
        'name': 'Breakfast',
        'isDone': true,
        'meals': [
          {'recipeId': 1, 'recipeName': 'Poha'},
          {'recipeId': 2, 'recipeName': 'Green Tea'},
          {'recipeId': 3, 'recipeName': 'Milk Shake'}
        ]
      },
      {
        'name': 'Lunch',
        'isDone': true,
        'meals': [
          {'recipeId': 4, 'recipeName': 'Chicken Biriyani'},
          {'recipeId': 5, 'recipeName': 'Mutton Curry'},
          {'recipeId': 6, 'recipeName': 'Gulaab Jamun'}
        ]
      },
    ],
    DateTime(2021, 04, 27): [
      {
        'name': 'Breakfast',
        'isDone': true,
        'meals': [
          {'recipeId': 1, 'recipeName': 'Poha'},
          {'recipeId': 2, 'recipeName': 'Green Tea'},
          {'recipeId': 3, 'recipeName': 'Milk Shake'}
        ]
      },
      {
        'name': 'Dinner',
        'isDone': true,
        'meals': [
          {'recipeId': 7, 'recipeName': 'Hilsa Curry'},
          {'recipeId': 8, 'recipeName': 'Pulao'},
          {'recipeId': 9, 'recipeName': 'Buttermilk'}
        ]
      },
    ],
    DateTime(2021, 04, 28): [
      {
        'name': 'Breakfast',
        'isDone': true,
        'meals': [
          {'recipeId': -1, 'recipeName': 'Please add brakfast'},
        ]
      },
      {
        'name': 'Lunch',
        'isDone': true,
        'meals': [
          {'recipeId': -1, 'recipeName': 'Please add lunch'},
        ]
      },
      {
        'name': 'Dinner',
        'isDone': true,
        'meals': [
          {'recipeId': -1, 'recipeName': 'Please add dinner'},
        ]
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    _selectedDay = DateTime(today.year, today.month, today.day);
    //print('selected day is '+_selectedDay.toIso8601String());
    _selectedEvents = _events[_selectedDay] ?? [];
    //print(_selectedEvents);
    getNutritionTarget();
  }

  void _handleNewDate(DateTime date) {
    setState(() {
      _selectedDay = DateTime(date.year, date.month, date.day);
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    //print("on change events value" + _selectedEvents.toString());
  }

  void getNutritionTarget() async {
    try{
      setState(() {
        showSpinner = true;
      });
      String url = nutrition_target_url;
      http.Response response = await http.get(url, headers: {"Authorization": "Token $token"});
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['results'].length != 0) {
          setState(() {
            showSpinner = false;
            targetCalories = responseData['results']['calories'].toString();
            targetCarbs = responseData['results']['carbs_max'].toString();
            targetFat = responseData['results']['fat_max'].toString();
            targetProtein = responseData['results']['protein_max'].toString();
          });
        }
        setState(() {
          showSpinner = false;
        });
      } else {
        setState(() {
          showSpinner = false;
        });
        AlertDialogWidget alertWidget = AlertDialogWidget(
            messages: [Text("Something went wrong. Please try again")], context: this.context);
        await alertWidget.showMyDialog();
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      AlertDialogWidget alertWidget = AlertDialogWidget(
          messages: [Text("Something went wrong. Please try again")], context: this.context);
      await alertWidget.showMyDialog();
    }
  }

  void createMealPlan(mean_plans) async {
    String url = meal_plan_url;
    var body = {
      "title": "weekly plan",
      "description": "Lose weight",
      "meals": mean_plans,
      "start": "2020-12-16",
      "end": "2020-12-20"
    };
    http.Response response = await http.post(
      url,
      body: body,
      headers: {'Authorization': 'Token $token'}
    );
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF58B76E),
          toolbarHeight: MediaQuery.of(context).size.height * .07,
          centerTitle: true,
          title: Text('Meal Planner'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                //_showPicker(context);
                setState(() {
                  //Navigator.pushNamed(context, CastScreen.id);
                  //Navigator.pushNamed(context, BarCodeScanner.id);
                });
              },
            )
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            height: MediaQuery.of(context).size.height * .93,
            //color: Colors.blue.shade100,
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
            child: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .075,
                  color: Colors.grey.shade300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25.0,
                              height: 25.0,
                              child: IconButton(
                                padding: new EdgeInsets.only(
                                    left: 12.0,
                                    bottom: 0.0,
                                    right: 0.0,
                                    top: 0.0),
                                icon: Icon(
                                  Icons.add,
                                  color: Color(0xFF58B76E),
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  //_showPicker(context);
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                              width: 14.0,
                            ),
                            Text(
                              "Search Food",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Color(0xFF58B76E)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Experiment",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Color(0xFF58B76E)),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.autorenew,
                                color: Color(0xFF58B76E),
                                size: 25.0,
                              ),
                              onPressed: () {
                                //_showPicker(context);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: custom.ExpansionTile(
                    headerBackgroundColor: Colors.grey.shade300,
                    title: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Current Profile",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF58B76E),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, HealthProfileScreen.id);
                            },
                            child: Text(
                              "Nutrition Target",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF58B76E)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height * .25,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                height: MediaQuery.of(context).size.height * .25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$targetCalories Calories',
                                      style: TextStyle(
                                          color: _randomColor.randomColor(
                                              colorBrightness:
                                                  ColorBrightness.dark)),
                                    ),
                                    Text(
                                      '$targetCarbs Carbs',
                                      style: TextStyle(
                                          color: _randomColor.randomColor(
                                              colorBrightness:
                                                  ColorBrightness.light)),
                                    ),
                                    Text(
                                      '$targetFat Fat',
                                      style: TextStyle(
                                          color: _randomColor.randomColor(
                                              colorBrightness:
                                                  ColorBrightness.dark)),
                                    ),
                                    Text(
                                      '$targetProtein Protein',
                                      style: TextStyle(
                                          color: _randomColor.randomColor(
                                              colorBrightness:
                                                  ColorBrightness.light)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('% Calories of each Macro'),
                                    PieChart(
                                      dataMap: dataMap,
                                      animationDuration:
                                          Duration(milliseconds: 800),
                                      chartLegendSpacing: 40,
                                      chartRadius:
                                          MediaQuery.of(context).size.width / 3.4,
                                      colorList: [
                                        Colors.red,
                                        Colors.blue,
                                        Colors.green
                                      ],
                                      initialAngleInDegree: 0,
                                      chartType: ChartType.disc,
                                      ringStrokeWidth: 40,
                                      centerText: "Target",
                                      legendOptions: LegendOptions(
                                        showLegendsInRow: false,
                                        legendPosition: LegendPosition.bottom,
                                        showLegends: false,
                                        //legendShape: _BoxShape.circle,
                                        legendTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      chartValuesOptions: ChartValuesOptions(
                                        showChartValueBackground: true,
                                        showChartValues: true,
                                        showChartValuesInPercentage: false,
                                        showChartValuesOutside: false,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: custom.ExpansionTile(
                    headerBackgroundColor: Colors.grey.shade300,
                    title: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Current Diet Stats",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF58B76E),
                            ),
                          ),
                          Text(
                            "1922 cal",
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF535252)),
                          ),
                          //SizedBox(width: 25.0,),
                        ],
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * .25,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              height: MediaQuery.of(context).size.height * .25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '1299 Calories',
                                    style: TextStyle(
                                        color: _randomColor.randomColor(
                                            colorBrightness:
                                                ColorBrightness.dark)),
                                  ),
                                  Text(
                                    '45.0 gm Carbs',
                                    style: TextStyle(
                                        color: _randomColor.randomColor(
                                            colorBrightness:
                                                ColorBrightness.light)),
                                  ),
                                  Text(
                                    '100.4 Fat',
                                    style: TextStyle(
                                        color: _randomColor.randomColor(
                                            colorBrightness:
                                                ColorBrightness.dark)),
                                  ),
                                  Text(
                                    '230.0 gm Protein',
                                    style: TextStyle(
                                        color: _randomColor.randomColor(
                                            colorBrightness:
                                                ColorBrightness.light)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          NutritionDetailsScreen.id);
                                    },
                                    child: Text(
                                      'Full Nutrition Details',
                                      style: TextStyle(
                                          color: Color(0xFF58B76E),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('% Calories of each Macro'),
                                  PieChart(
                                    dataMap: dataMap,
                                    animationDuration:
                                        Duration(milliseconds: 800),
                                    chartLegendSpacing: 40,
                                    chartRadius:
                                        MediaQuery.of(context).size.width / 3.4,
                                    colorList: [
                                      Colors.red,
                                      Colors.blue,
                                      Colors.green
                                    ],
                                    initialAngleInDegree: 0,
                                    chartType: ChartType.disc,
                                    ringStrokeWidth: 40,
                                    centerText: "Diet",
                                    legendOptions: LegendOptions(
                                      showLegendsInRow: false,
                                      legendPosition: LegendPosition.bottom,
                                      showLegends: false,
                                      //legendShape: _BoxShape.circle,
                                      legendTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    chartValuesOptions: ChartValuesOptions(
                                      showChartValueBackground: true,
                                      showChartValues: true,
                                      showChartValuesInPercentage: false,
                                      showChartValuesOutside: false,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    children: [
                      Calendar(
                        startOnMonday: true,
                        weekDays: [
                          "Mon",
                          "Tue",
                          "Wed",
                          "Thu",
                          "Fri",
                          "Sat",
                          "Sun"
                        ],
                        events: _events,
                        initialDate: new DateTime.now(),
                        onRangeSelected: (range) =>
                            print("Range is ${range.from}, ${range.to}"),
                        onDateSelected: (date) {
                          setState(() {
                            //print(date);
                            _handleNewDate(date);
                          });
                        },
                        /* dayBuilder: (context, day) {
                          print(day);
                        },*/
                        isExpandable: true,
                        eventDoneColor: Colors.green,
                        selectedColor: Colors.pink,
                        todayColor: Colors.blue,
                        eventColor: Colors.grey,
                        dayOfWeekStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 11),
                      ),
                      _selectedEvents.length > 0
                          ? Column(
                              children: getAllEvents(),
                            )
                          : Container(),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          print(mealPlans);
                          createMealPlan(mealPlans);
                          setState(() {
                            mealPlans = [];
                          });
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomWidget(activeIndex: 2),
      ),
    );
  }

  List<DailyMealPlan> getAllEvents() {
    List<DailyMealPlan> events = List<DailyMealPlan>();
    //print("Add called here");
    for (int index = 0; index < _selectedEvents.length; index++) {
      events.add(new DailyMealPlan(
        mealType: _selectedEvents[index]['name'],
        meals: _selectedEvents[index]['meals'],
      ));
    }
    return events;
  }
}

class DailyMealPlan extends StatefulWidget {
  final String mealType;
  final List<Map<String, dynamic>> meals;

  const DailyMealPlan({Key key, this.mealType, this.meals}) : super(key: key);
  @override
  _DailyMealPlanState createState() => _DailyMealPlanState();
}

class _DailyMealPlanState extends State<DailyMealPlan> {
  bool isClicked = false;
  List<DropdownMenuItem<dynamic>> recipeItems = [];

  @override
  void initState() {
    super.initState();
    getDropDownItemList();
  }

  void getDropDownItemList() async {
    try {
      List<Map<String, dynamic>> recipes = [];
      String url = recipe_url;
      final http.Response response = await http.get(url, headers: {
        "Authorization": "Token $token",
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      responseData['results'].forEach((i) {
        recipes.add(
          {
            'recipeId': i['id'],
            'recipeName': i['name_of_recipe'],
          }
        );
      });
      for (int i = 0; i < recipes.length; i++) {
        setState(() {
          recipeItems.add(DropdownMenuItem(
            child: Text(recipes[i]['recipeName']),
            value: '${recipes[i]['recipeId']}-${recipes[i]['recipeName']}',
          ));
        });
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isClicked
            ? AnimatedAlign(
                alignment: Alignment.center,
                duration: Duration(seconds: 5),
                child: Container(
                    //width: MediaQuery.of(context).size.width * .40,
                    height: 60,
                    //color: Colors.white,
                    child: SearchableDropdown.single(
                  items: recipeItems,
                  isExpanded: true,
                  hint: "Add Recipe to "+widget.mealType,
                  displayClearIcon: false,
                  searchHint: "Select one",
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                  iconSize: 40.0,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    print('value - $value');
                    setState(() {
                      isClicked = false;

                      if(value!=null){
                        List<dynamic> splittedArray =  value.toString().split('-');
                        int id = int.parse(splittedArray[0].toString());
                        String name = splittedArray[1].toString();

                        bool isExist = false;

                        for(int i=0;i<widget.meals.length;i++){
                          if(widget.meals[i]['recipeId'] == id){
                            isExist = true;

                            AlertDialogWidget alertWidget = AlertDialogWidget(
                                messages: [Text("You have already choose the recipe in your "+widget.mealType)], context: this.context);
                            alertWidget.showMyDialog();
                          }
                        }
                        if(!isExist){
                          Map<String,dynamic> valueMap = new Map<String,dynamic>();
                          Map<String,dynamic> mealMap = new Map<String,dynamic>();
                          valueMap.putIfAbsent('recipeId', () => id);
                          valueMap.putIfAbsent('recipeName', () => name);
                          print(widget.meals);
                          widget.meals.removeWhere((item) => item['recipeId'] == -1);
                          widget.meals.add(valueMap);
                          mealMap.putIfAbsent(widget.mealType, () => id);
                          mealPlans.add(mealMap);
                        }
                      }
                    });
                  },
                )),
              )
            : Container(),
        custom.ExpansionTile(
          headerBackgroundColor: Colors.black54,
          iconColor: Colors.white,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .25,
                  child: Text(
                    widget.mealType,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 25.0,
                  height: 25.0,
                  child: IconButton(
                    padding: new EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    onPressed: () {
                      //_showPicker(context);
                      setState(() {
                        isClicked = !isClicked;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          initiallyExpanded: true,
          children: <Widget>[
            for (int index = 0; index < widget.meals.length; index++)
              Container(
                  height: 35.0,
                  //alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.meals[index]['recipeName']),
                      IconButton(
                        padding: new EdgeInsets.all(0.0),
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.black54,
                          size: 25.0,
                        ),
                        onPressed: () {
                          //_showPicker(context);
                          setState(() {
                            int id = widget.meals[index]['recipeId'];
                            widget.meals.removeWhere((item) => item['recipeId'] == id);
                            if (widget.meals.length == 0) {
                              widget.meals.add({'recipeId': -1, 'recipeName': 'Please Select'});
                            }
                          });
                        },
                      )
                    ],
                  ))
          ],
        ),
      ],
    );
  }
}
