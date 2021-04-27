import 'package:flutter/material.dart';
import 'package:food_app/components/bottom_widget.dart';
import 'package:food_app/components/drawer_widget.dart';
import 'package:food_app/components/recipe_widget.dart';
import 'package:food_app/screens/about_screen.dart';
import 'package:food_app/screens/explore_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:polygon_clipper/polygon_border.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:http/http.dart' as http;
import 'package:food_app/components/appbar.dart';
import 'package:food_app/utils/urls.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';

class LandingScreen extends StatefulWidget {
  static final id = "landing_screen";
     
  final String emailId;
  final String token;

  const LandingScreen({Key key, this.emailId, @required this.token})
      : super(key: key);
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String email;
  bool _isVisible = false;
  TextEditingController _searchQuery;
  String searchQuery;
  List<String> geographies = ['select'];
  List<String> geography_id = [null];
  String geographyValue = 'select';
  String recipe_geography;
  List<String> foodTypes = ["select"];
  List<String> foodTypes_id = [null];
  String foodTypeValue = "select";
  String food_type;
  List<String> racipeTaste = ["select"];
  List<String> racipeTasteId = [null];
  String recipeTasteValue = "select";
  String recipe_taste;
  List<String> recipeCulture = ["select"];
  List<String> recipeCultureId = [null];
  String recipeCultureValue = "select";
  String recipe_culture;


  bool showSpinner = false;
  List<Recipe> recipes = [];
  List<String> ingredients = [
    "Bread",
    "Banana",
    "Tomato",
    "Carot",
    "Onion",
    "Apple",
    "Coffee",
    "Avocado",
    "Mint",
    "Chicken",
    "Mutton",
    "Fish",
    "Cumin",
    "Mango"
  ];

  @override
  void initState() {
    super.initState();
    appUserId = widget.emailId;
    token = widget.token;
    getRecipes(searchQuery);
    // getGeographies();
  }

  void getRecipes(searchQuery) async {
    String url = recipe_url;
    setState(() {
      showSpinner = true;
    });
    try {
      if (searchQuery != null) {
        url = recipe_search_url + '?search=' + '$searchQuery';
      } if (recipe_geography != null) {
        url = url + '&recipe_geography=$recipe_geography';
      } if (food_type != null) {
        url = url + '&recipe_type=$food_type';
      } if (recipe_taste != null) {
        url = url + '&taste=$recipe_taste';
      } if (recipe_culture != null) {
        url = url + '&recipe_culture=$recipe_culture';
      }

      final http.Response response = await http.get(url, headers: {
        "Authorization": "Token $token",
      });
      print(url+" response code :"+response.statusCode.toString());

      if(response.statusCode == 200){
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData['results']);
        responseData['results'].forEach((i) {
          var _type = 'test';
          if (i['recipe_type'] != null){
            List<dynamic> recipeType = i['recipe_type'];
            if(!recipeType.isEmpty){
              _type = i['recipe_type'][0].toString();
            }
            else{
              _type = "Unknown";
            }

          }
          final Recipe recipe = Recipe(
            type: _type,
            //type: i['author'],
            recipeImage: i['image'] != null ? i['image'] : '',
            recipeName: i['name_of_recipe'],
            recipeTime: i['cooking_time'].toString(),
            totalCalories: i['calories'].toString(),
            totalServe: i['servings'].toString(),
            author: i['author'],
            recipeSlug: i['slug'],
            videoId: i['recipe_video'] != null ? i['recipe_video'] : '',
          );
          setState(() {
            if (!recipes.contains(recipe)) {
              recipes.add(recipe);
            }
          });
        });
      }
      else{
        print('Server error occured');
      }


      // print(responseData['results'][0]['slug']);
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print(e);
    }
  }

  List<Widget> getAllWidget() {
    List<Widget> widgets = List<Widget>();
    List<Widget> rowList = List<Widget>();

    for (var i = 0; i < ingredients.length; i++) {
      if (i != 0 && i % 3 == 0) {
        widgets.add(Row(
          children: rowList,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ));
        rowList = List<Widget>();
      }
      rowList.add(new MaterialWidget(name: ingredients[i]));
    }
    if (rowList.length > 0) {
      widgets.add(Row(
        children: rowList,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ));
    }

    return widgets;
  }

  void updateSearchQuery(String newQuery) async {
    setState(() {
      searchQuery = newQuery;
      recipes = [];
    });
    // print("search query " + newQuery);
    getRecipes(newQuery);
  }

  Widget buildSearchField() {
    return Stack(
      children: [
        new TextField(
          controller: _searchQuery,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.white)),
            filled: true,
            contentPadding: EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
            hintStyle: const TextStyle(color: Colors.white30),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 20.0),
          // onChanged: updateSearchQuery,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            setState(() {
              recipes = [];
            });
            getRecipes(value);
          },
        ),
      ],
    );
  }

  void getGeographies() async {
    try {
      String url = geography_url;
      http.Response response = await http.get(url, headers: {"Authorization": "Token $token"});
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      responseData['results'].forEach((i) {
        setState(() {
          geographies.add(i['name']);
          geography_id.add(i['id'].toString());
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void getRecipeTypes() async {
    try {
      String url = recipe_type_url;
      http.Response response = await http.get(url, headers: {"Authorization": "Token $token"});
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      responseData['results'].forEach((i) {
        setState(() {
          foodTypes.add(i['name']);
          foodTypes_id.add(i['id'].toString());
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void getRecipeTaste() async {
    try {
      String url = recipe_taste_url;
      http.Response response = await http.get(url, headers: {"Authorization": "Token $token"});
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      responseData['results'].forEach((i) {
        setState(() {
          racipeTaste.add(i['name']);
          racipeTasteId.add(i['id'].toString());
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void getRecipeCulture() async {
    try {
      String url = recipe_culture_url;
      http.Response response = await http.get(url, headers: {"Authorization": "Token $token"});
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      responseData['results'].forEach((i) {
        setState(() {
          recipeCulture.add(i['name']);
          recipeCultureId.add(i['id'].toString());
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Widget getHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LandingScreen(emailId: widget.emailId, token: token)));
          },
          child: Text(
            'Just For You |',
            style: TextStyle(color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ExploreScreen.id);
          },
          child: Text(
            ' Explore',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF58B76E),
        centerTitle: true,
        title: !_isVisible ? getHeader() : buildSearchField(),
        actions: [
          !_isVisible
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                    getGeographies();
                    getRecipeTypes();
                    getRecipeTaste();
                    getRecipeCulture();
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                )
        ],
      ),
      drawer: SafeArea(
        child: DrawerWidget(),
      ),
      body: Container(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: ListView(
              children: [
                _isVisible ? Container(
                  height: MediaQuery.of(context).size.height*.20,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Geography', style: TextStyle(fontSize: 14.0),),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            //padding: EdgeInsets.only(top: 10.0),
                              child: DropdownButton(
                                isExpanded: true,
                                value: geographyValue,
                                icon: Icon(Icons.arrow_downward),
                                style: TextStyle(color: Color(0xFF535252)),
                                underline: Container(
                                  height: 1,
                                  color: Color(0xFF535252),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    print(newValue);
                                    geographyValue = newValue;
                                    recipe_geography = geography_id[geographies.indexOf(newValue)];
                                  });
                                },
                                items: geographies.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Culture', style: TextStyle(fontSize: 14.0),),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            //padding: EdgeInsets.only(top: 10.0),
                              child: DropdownButton(
                                isExpanded: true,
                                value: recipeCultureValue,
                                icon: Icon(Icons.arrow_downward),
                                style: TextStyle(color: Color(0xFF535252)),
                                underline: Container(
                                  height: 1,
                                  color: Color(0xFF535252),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    print(newValue);
                                    recipeCultureValue = newValue;
                                    recipe_culture = recipeCultureId[recipeCulture.indexOf(newValue)];
                                  });
                                },
                                items: recipeCulture.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Type', style: TextStyle(fontSize: 14.0),),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            //padding: EdgeInsets.only(top: 10.0),
                              child: DropdownButton(
                                isExpanded: true,
                                value: foodTypeValue,
                                icon: Icon(Icons.arrow_downward),
                                style: TextStyle(color: Color(0xFF535252)),
                                underline: Container(
                                  height: 1,
                                  color: Color(0xFF535252),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    print(newValue);
                                    foodTypeValue = newValue;
                                    food_type = foodTypes_id[foodTypes.indexOf(newValue)];
                                  });
                                },
                                items: foodTypes.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )/*DropdownButton(
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
                                          print(dropdownValue);
                                        });
                                      },

                                      items: units.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),*/
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Taste', style: TextStyle(fontSize: 14.0),),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            //padding: EdgeInsets.only(top: 10.0),
                              child: DropdownButton(
                                isExpanded: true,
                                value: recipeTasteValue,
                                icon: Icon(Icons.arrow_downward),
                                style: TextStyle(color: Color(0xFF535252)),
                                underline: Container(
                                  height: 1,
                                  color: Color(0xFF535252),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    print(newValue);
                                    recipeTasteValue = newValue;
                                    recipe_taste = racipeTasteId[racipeTaste.indexOf(newValue)];
                                  });
                                },
                                items: racipeTaste.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Type', style: TextStyle(fontSize: 16.0),),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            //padding: EdgeInsets.only(top: 10.0),
                              child: DropdownButton(
                                isExpanded: true,
                                value: foodTypeValue,
                                icon: Icon(Icons.arrow_downward),
                                style: TextStyle(color: Color(0xFF535252)),
                                underline: Container(
                                  height: 1,
                                  color: Color(0xFF535252),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    print(newValue);
                                    foodTypeValue = newValue;
                                    food_type = foodTypes_id[foodTypes.indexOf(newValue)];
                                  });
                                },
                                items: foodTypes.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )/*DropdownButton(
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
                                    print(dropdownValue);
                                  });
                                },

                                items: units.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),*/
                          ),
                        ],
                      ),
                    ],
                  ),
                ) : Container(

                ),
                Container(
                  height: _isVisible ? MediaQuery.of(context).size.height*.62 : MediaQuery.of(context).size.height*.82,
                  child: SingleChildScrollView(
                    child: Column(
                      children: this.recipes,
                    ),
                  ),
                ),
              ],
            )/*ListView.builder(
              itemCount: this.recipes.length,
              itemBuilder: (context, index) {
                Recipe recipe = recipes[index];
                return recipe;
              },
            ),*/
          ),
        ),
      ),
      bottomNavigationBar: BottomWidget(activeIndex: 0),
    );
  }
}

class MaterialWidget extends StatefulWidget {
  final String name;

  const MaterialWidget({Key key, this.name}) : super(key: key);
  @override
  _MaterialWidgetState createState() => _MaterialWidgetState();
}

class _MaterialWidgetState extends State<MaterialWidget> {
  bool is_clicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      //width: MediaQuery.of(context).size.width*.25,
      child: Material(
        elevation: 2.0,
        color: is_clicked ? Color(0xFF58B76E) : Colors.white,
        /*borderRadius: BorderRadius.circular(10.0),*/
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Color(0xFF58B76E))),
        child: MaterialButton(
          onPressed: () {
            setState(() {
              is_clicked = !is_clicked;
            });
          },
          minWidth: MediaQuery.of(context).size.width * .27,
          height: 42.0,
          child: Text(
            widget.name,
            style: TextStyle(
                color: !is_clicked ? Color(0xFF535252) : Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
