import 'package:flutter/material.dart';
import 'package:food_app/components/bottom_widget.dart';
import 'package:food_app/components/profile_header_widget.dart';

class AccountPreferenceScreen extends StatefulWidget {
  static final id = "account_preference_screen";
  final int index;

  const AccountPreferenceScreen({Key key, this.index}) : super(key: key);
  @override
  _AccountPreferenceScreenState createState() =>
      _AccountPreferenceScreenState();
}

class _AccountPreferenceScreenState extends State<AccountPreferenceScreen> {
  int selectedRadioTile;
  int alergyRadioTile;
  int cuisinesRadioTile;

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  setAlergyRadioTile(int val) {
    setState(() {
      alergyRadioTile = val;
    });
  }

  setCuisinesRadioTile(int val) {
    setState(() {
      cuisinesRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          toolbarHeight : 210.0,
          //toolbarHeight: MediaQuery.of(context).size.height * .27,
          flexibleSpace: ProfileHeaderWidget(
            tabIndex: widget.index,
          ),
        ),
        bottomNavigationBar: BottomWidget(activeIndex: 4),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: ListView(
            children: [
              Container(
                height: 40.0,
                color: Color(0xFFE5E5E5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text('Disliked Ingredients', style: TextStyle(color: Color(0xFF535252), fontSize: 15.0),),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Color(0xFF58B76E),),
                    Text('Add')
                  ],
                ),
              ),
              Container(
                height: 40.0,
                color: Color(0xFFE5E5E5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text('Diets', style: TextStyle(color: Color(0xFF535252), fontSize: 15.0),),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 1,
                            groupValue: selectedRadioTile,
                            title: Text("Vegan"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setSelectedRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 2,
                            groupValue: selectedRadioTile,
                            title: Text("Vegetarian"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setSelectedRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 3,
                            groupValue: selectedRadioTile,
                            title: Text("Low Carb"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setSelectedRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 4,
                            groupValue: selectedRadioTile,
                            title: Text("Paleo"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setSelectedRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 5,
                            groupValue: selectedRadioTile,
                            title: Text("Keto"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setSelectedRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 6,
                            groupValue: selectedRadioTile,
                            title: Text("Raw"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setSelectedRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: RadioListTile(
                          value: 7,
                          groupValue: selectedRadioTile,
                          title: Text("Non Veg"),
                          onChanged: (val) {
                            print("Radio Tile pressed $val");
                            setSelectedRadioTile(val);
                          },
                          activeColor: Color(0xFF58B76E),
                          selected: false,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: RadioListTile(
                          value: 8,
                          groupValue: selectedRadioTile,
                          title: Text("Mediterranean"),
                          onChanged: (val) {
                            print("Radio Tile pressed $val");
                            setSelectedRadioTile(val);
                          },
                          activeColor: Color(0xFF58B76E),
                          selected: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 40.0,
                color: Color(0xFFE5E5E5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text('Allergies', style: TextStyle(color: Color(0xFF535252), fontSize: 15.0),),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 1,
                            groupValue: alergyRadioTile,
                            title: Text("Dairy Free"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setAlergyRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 2,
                            groupValue: alergyRadioTile,
                            title: Text("Egg Free"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setAlergyRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 3,
                            groupValue: alergyRadioTile,
                            title: Text("Gluten Free"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setAlergyRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 4,
                            groupValue: alergyRadioTile,
                            title: Text("Nut Free"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setAlergyRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: RadioListTile(
                          value: 5,
                          groupValue: alergyRadioTile,
                          title: Text("Seafood Free"),
                          onChanged: (val) {
                            print("Radio Tile pressed $val");
                            setAlergyRadioTile(val);
                          },
                          activeColor: Color(0xFF58B76E),
                          selected: false,
                        ),
                      ),

                    ],
                  ),

                ],
              ),
              Container(
                height: 40.0,
                color: Color(0xFFE5E5E5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text('Cuisines', style: TextStyle(color: Color(0xFF535252), fontSize: 15.0),),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 1,
                            groupValue: cuisinesRadioTile,
                            title: Text("American"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 2,
                            groupValue: cuisinesRadioTile,
                            title: Text("Irish"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 3,
                            groupValue: cuisinesRadioTile,
                            title: Text("Asian"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 4,
                            groupValue: cuisinesRadioTile,
                            title: Text("Japanese"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 5,
                            groupValue: cuisinesRadioTile,
                            title: Text("Barbeque"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 6,
                            groupValue: cuisinesRadioTile,
                            title: Text("Kids-friendly"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 7,
                            groupValue: cuisinesRadioTile,
                            title: Text("Chinese"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 8,
                            groupValue: cuisinesRadioTile,
                            title: Text("Mexican"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 9,
                            groupValue: cuisinesRadioTile,
                            title: Text("Cajun"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 10,
                            groupValue: cuisinesRadioTile,
                            title: Text("Thai"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 11,
                            groupValue: cuisinesRadioTile,
                            title: Text("English"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 12,
                            groupValue: cuisinesRadioTile,
                            title: Text("Swedish"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 13,
                            groupValue: cuisinesRadioTile,
                            title: Text("Genman"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 14,
                            groupValue: cuisinesRadioTile,
                            title: Text("Spanish"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 15,
                            groupValue: cuisinesRadioTile,
                            title: Text("French"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 25.0,
                          child: RadioListTile(
                            value: 16,
                            groupValue: cuisinesRadioTile,
                            title: Text("Moroccan"),
                            onChanged: (val) {
                              print("Radio Tile pressed $val");
                              setCuisinesRadioTile(val);
                            },
                            activeColor: Color(0xFF58B76E),
                            selected: false,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: RadioListTile(
                          value: 17,
                          groupValue: cuisinesRadioTile,
                          title: Text("Indian"),
                          onChanged: (val) {
                            print("Radio Tile pressed $val");
                            setCuisinesRadioTile(val);
                          },
                          activeColor: Color(0xFF58B76E),
                          selected: false,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: RadioListTile(
                          value: 18,
                          groupValue: cuisinesRadioTile,
                          title: Text("Italian"),
                          onChanged: (val) {
                            print("Radio Tile pressed $val");
                            setCuisinesRadioTile(val);
                          },
                          activeColor: Color(0xFF58B76E),
                          selected: false,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }
}
