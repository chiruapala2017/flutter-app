import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/utils/urls.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:food_app/utils/constants.dart';
import 'package:food_app/utils/urls.dart';
import 'package:food_app/components/alert_dialog_widget.dart';

class HealthProfileScreen extends StatefulWidget {
  static final id = "health_profile_screen";

  @override
  _HealthProfileScreenState createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  RangeValues _currentRangeCarbsValues = const RangeValues(40, 80);
  RangeValues _currentRangeFatValues = const RangeValues(40, 80);
  RangeValues _currentRangeProteinValues = const RangeValues(40, 80);

  String title;
  String description;
  String calories;
  String carbs_min;
  String carbs_max;
  String fat_min;
  String fat_max;
  String protein_min;
  String protein_max;
  bool showSpinner = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _caloriesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getNutritionTarget();
  }

  void saveNutritionTarget() async {
    try {
      setState(() {
        showSpinner = true;
      });
      String url = nutrition_target_url;
      var body = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'calories': _caloriesController.text.toString(),
        'carbs_min': _currentRangeCarbsValues.start.toString(),
        'carbs_max': _currentRangeCarbsValues.end.toString(),
        'fat_min': _currentRangeFatValues.start.toString(),
        'fat_max': _currentRangeFatValues.end.toString(),
        'protein_min': _currentRangeProteinValues.start.toString(),
        'protein_max': _currentRangeProteinValues.end.toString()
      };
      http.Response response = await http.post(url, body: body, headers: {"Authorization": 'Token $token'});
      setState(() {
        showSpinner = false;
      });
      if (response.statusCode == 200) {
        AlertDialogWidget alertWidget = AlertDialogWidget(
            messages: [Text("Nutrition target saved")], context: this.context);
        await alertWidget.showMyDialog();
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      AlertDialogWidget alertWidget = AlertDialogWidget(
          messages: [Text("Something went wrong. Please try again")], context: this.context);
      await alertWidget.showMyDialog();
      print(e);
    }
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
            _titleController.text = responseData['results']['title'];
            _descriptionController.text = responseData['results']['description'];
            _caloriesController.text = responseData['results']['calories'].toString();
            _currentRangeCarbsValues = RangeValues(responseData['results']['carbs_min'], responseData['results']['carbs_max']);
            _currentRangeFatValues = RangeValues(responseData['results']['fat_min'], responseData['results']['fat_max']);
            _currentRangeProteinValues = RangeValues(responseData['results']['protein_min'], responseData['results']['protein_max']);
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

  bool validate() {
    if (_titleController.text != null) {
      if (_descriptionController.text != null) {
        if (_caloriesController.text != null) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Health Profile'),
          backgroundColor: Color(0xFF58B76E),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () async {
                bool valid = validate();
                if (valid) {
                  saveNutritionTarget();
                } else {
                  AlertDialogWidget alertWidget = AlertDialogWidget(
                      messages: [Text("Please enter all the details")], context: this.context);
                  await alertWidget.showMyDialog();
                }
              },
            )
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(
              children: [
                Container(
                  //color: Colors.greenAccent,
                  height: MediaQuery.of(context).size.height * .25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Title',
                            style: TextStyle(
                                color: Color(0xFF535252), fontSize: 20.0),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            child: TextField(
                              keyboardType: TextInputType.name,
                              autofocus: false,
                              textAlign: TextAlign.justify,
                              controller: _titleController,
                              onChanged: (value) {
                                setState(() {
                                  title = value;
                                });
                              },
                              obscureText: false,
                              decoration: kInputFieldDecoration.copyWith(
                                  hintText: ' E.g. My nutrition target'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                                color: Color(0xFF535252), fontSize: 20.0),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            child: TextField(
                              keyboardType: TextInputType.name,
                              autofocus: false,
                              textAlign: TextAlign.justify,
                              controller: _descriptionController,
                              onChanged: (value) {
                                setState(() {
                                  description = value;
                                });
                              },
                              obscureText: false,
                              decoration: kInputFieldDecoration.copyWith(
                                  hintText: 'E.g. My nutrition desc'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Calories',
                            style: TextStyle(
                              color: Color(0xFF535252),
                              fontSize: 20.0,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            child: TextField(
                              keyboardType: TextInputType.name,
                              autofocus: false,
                              textAlign: TextAlign.justify,
                              controller: _caloriesController,
                              onChanged: (value) {
                                setState(() {
                                  calories = value;
                                });
                              },
                              obscureText: false,
                              decoration: kInputFieldDecoration.copyWith(
                                  hintText: 'E.g. 1200'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  //color: Colors.lightBlueAccent,
                  height: MediaQuery.of(context).size.height * .645,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 5.0,
                      ),
                      Image.asset('images/border_line.png'),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          'Nutrient Target',
                          style: TextStyle(
                            color: Color(0xFF535252),
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Material(
                              elevation: 2.0,
                              color: Color(0xFF58B76E),
                              borderRadius: BorderRadius.circular(10.0),
                              child: MaterialButton(
                                onPressed: () {},
                                minWidth: MediaQuery.of(context).size.width * .35,
                                height: 42.0,
                                child: Text('Within a Range',
                                    style: TextStyle(color: Colors.white)
                                    //style: TextStyle(color: is_click != true ? Colors.black : Color(0xFF58B76E), fontSize: 20.0, fontWeight: FontWeight.bold),
                                    ),
                              ),
                            ),
                            Material(
                              elevation: 2.0,
                              color: Color(0xFF58B76E),
                              borderRadius: BorderRadius.circular(10.0),
                              child: MaterialButton(
                                onPressed: () {},
                                minWidth: MediaQuery.of(context).size.width * .35,
                                height: 42.0,
                                child: Text('% Of Calories',
                                    style: TextStyle(color: Colors.white)
                                    //style: TextStyle(color: is_click != true ? Colors.black : Color(0xFF58B76E), fontSize: 20.0, fontWeight: FontWeight.bold),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Text(
                                    'Carbs (g)',
                                    style: TextStyle(
                                      color: Color(0xFF535252),
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .4,
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  .15,
                                          height: 25.0,
                                          color: Colors.grey.shade300,
                                          child: Center(
                                              child: Text(_currentRangeCarbsValues
                                                  .start
                                                  .round()
                                                  .toString()))),
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  .15,
                                          height: 25.0,
                                          color: Colors.grey.shade300,
                                          child: Center(
                                              child: Text(_currentRangeCarbsValues.end
                                                  .round()
                                                  .toString()))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Min',
                                  style: TextStyle(
                                    color: Color(0xFF535252),
                                    fontSize: 15.0,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .75,
                                  child: RangeSlider(
                                    values: _currentRangeCarbsValues,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    labels: RangeLabels(
                                      _currentRangeCarbsValues.start
                                          .round()
                                          .toString(),
                                      _currentRangeCarbsValues.end.round().toString(),
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _currentRangeCarbsValues = values;
                                        carbs_min = values.start.toString();
                                        carbs_max = values.end.toString();
                                      });
                                    },
                                  ),
                                ),
                                Text(
                                  'Max',
                                  style: TextStyle(
                                    color: Color(0xFF535252),
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Image.asset('images/border_line.png'),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Text(
                                    'Fat (g)',
                                    style: TextStyle(
                                      color: Color(0xFF535252),
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .4,
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              .15,
                                          height: 25.0,
                                          color: Colors.grey.shade300,
                                          child: Center(
                                              child: Text(_currentRangeFatValues
                                                  .start
                                                  .round()
                                                  .toString()))),
                                      Container(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              .15,
                                          height: 25.0,
                                          color: Colors.grey.shade300,
                                          child: Center(
                                              child: Text(_currentRangeFatValues.end
                                                  .round()
                                                  .toString()))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Min',
                                  style: TextStyle(
                                    color: Color(0xFF535252),
                                    fontSize: 15.0,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .75,
                                  child: RangeSlider(
                                    values: _currentRangeFatValues,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    labels: RangeLabels(
                                      _currentRangeFatValues.start
                                          .round()
                                          .toString(),
                                      _currentRangeFatValues.end.round().toString(),
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _currentRangeFatValues = values;
                                        fat_min = values.start.toString();
                                        fat_max = values.end.toString();
                                      });
                                    },
                                  ),
                                ),
                                Text(
                                  'Max',
                                  style: TextStyle(
                                    color: Color(0xFF535252),
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Image.asset('images/border_line.png'),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Text(
                                    'Protein (g)',
                                    style: TextStyle(
                                      color: Color(0xFF535252),
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .4,
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              .15,
                                          height: 25.0,
                                          color: Colors.grey.shade300,
                                          child: Center(
                                              child: Text(_currentRangeProteinValues
                                                  .start
                                                  .round()
                                                  .toString()))),
                                      Container(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              .15,
                                          height: 25.0,
                                          color: Colors.grey.shade300,
                                          child: Center(
                                              child: Text(_currentRangeProteinValues.end
                                                  .round()
                                                  .toString()))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Min',
                                  style: TextStyle(
                                    color: Color(0xFF535252),
                                    fontSize: 15.0,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .75,
                                  child: RangeSlider(
                                    values: _currentRangeProteinValues,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    labels: RangeLabels(
                                      _currentRangeProteinValues.start
                                          .round()
                                          .toString(),
                                      _currentRangeProteinValues.end.round().toString(),
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _currentRangeProteinValues = values;
                                        protein_min = values.start.toString();
                                        protein_max = values.end.toString();
                                      });
                                    },
                                  ),
                                ),
                                Text(
                                  'Max',
                                  style: TextStyle(
                                    color: Color(0xFF535252),
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Image.asset('images/border_line.png'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
