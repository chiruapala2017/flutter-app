import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_app/components/drawer_widget.dart';
import 'package:food_app/components/expansion_tile_widget.dart' as custom;
import 'package:food_app/screens/order_grocery_screen.dart';

class ShoppingListScreen extends StatefulWidget {
  static final id = "shopping_list_screen";

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  bool isShoppingEnable = true;
  bool isPantryEnable = false;
  bool isSearchEnable = false;
  int selectedRadioTile;

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  //Change it according to service call.
  List<String> items = List<String>();
  //List<String> items = ["Bread"];

  //List<Widget> widgets = List<Widget>();
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

  Widget buildSearchField() {
    return new TextField(
      //controller: _searchQuery,
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
        setState(() {});
      },
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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

  Widget getCommonHeader() {
    return Container(
      height: MediaQuery.of(context).size.height*.13,
      //color: Colors.amber,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                GestureDetector(
                  child: Text(
                    'Shopping',
                    style: TextStyle(
                        color: isShoppingEnable
                            ? Color(0xFF58B76E)
                            : Color(0xFF535252),
                        fontSize: 18.0),
                  ),
                  onTap: () {
                    setState(() {
                      isShoppingEnable = true;
                      isPantryEnable = false;
                    });
                  },
                ),
                SizedBox(
                  width: 25.0,
                ),
                GestureDetector(
                  child: Text(
                    'Pantry',
                    style: TextStyle(
                        color: isPantryEnable
                            ? Color(0xFF58B76E)
                            : Color(0xFF535252),
                        fontSize: 18.0),
                  ),
                  onTap: () {
                    setState(() {
                      isShoppingEnable = false;
                      isPantryEnable = true;
                    });
                  },
                ),
              ],
            ),
          ),
          Image.asset('images/border_line.png'),
          Container(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle,
                          color: Color(0xFF58B76E),
                          size: 22.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Add Shopping List',
                          style: TextStyle(fontSize: 17.0),
                        )
                      ],
                    ),
                  ),
                  Text(
                    'Category',
                    style: TextStyle(fontSize: 17.0),
                  )
                ],
              ),
            ),
          ),
          Image.asset('images/border_line.png')
        ],
      ),
    );
  }

  Widget getBody() {
    return Container(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: ListView(
              children: [
                getCommonHeader(),
                Container(
                  //color: Colors.greenAccent,
                  height: MediaQuery.of(context).size.height*.74,
                  child: Container(
                    child: isShoppingEnable
                        ? items.length > 0 ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          custom.ExpansionTile(
                            headerBackgroundColor: Colors.white,
                            title: Container(
                              child: Text(
                                "Bakery (2)",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF535252)),
                              ),
                            ),
                            children: <Widget>[
                              ListTile(
                                title: RadioListTile(
                                  value: 1,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "1 Bread",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Pantry : Bread",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
                                  onChanged: (val) {
                                    print("Radio Tile pressed $val");
                                    setSelectedRadioTile(val);
                                  },
                                  activeColor: Color(0xFF58B76E),
                                  selected: false,
                                ),
                              ),
                              ListTile(
                                title: RadioListTile(
                                  value: 2,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "4 Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Pantry : Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
                                  onChanged: (val) {
                                    print("Radio Tile pressed $val");
                                    setSelectedRadioTile(val);
                                  },
                                  activeColor: Color(0xFF58B76E),
                                  selected: false,
                                ),
                              ),
                              ListTile(
                                title: RadioListTile(
                                  value: 3,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "4 Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Pantry : Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
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
                          custom.ExpansionTile(
                            headerBackgroundColor: Colors.white,
                            title: Container(
                              child: Text(
                                "Produce (2)",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF535252)),
                              ),
                            ),
                            children: <Widget>[
                              ListTile(
                                title: RadioListTile(
                                  value: 4,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "1 ltr Milk",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Diary : Milk",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
                                  onChanged: (val) {
                                    print("Radio Tile pressed $val");
                                    setSelectedRadioTile(val);
                                  },
                                  activeColor: Color(0xFF58B76E),
                                  selected: false,
                                ),
                              ),
                              ListTile(
                                title: RadioListTile(
                                  value: 5,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "4 Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Pantry : Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
                                  onChanged: (val) {
                                    print("Radio Tile pressed $val");
                                    setSelectedRadioTile(val);
                                  },
                                  activeColor: Color(0xFF58B76E),
                                  selected: false,
                                ),
                              ),
                              ListTile(
                                title: RadioListTile(
                                  value: 6,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "4 Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Pantry : Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
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
                    ) : Container()
                        : items.length == 0 ?  SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          custom.ExpansionTile(
                            headerBackgroundColor: Colors.white,
                            title: Container(
                              child: Text(
                                "Bakery (2)",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF535252)),
                              ),
                            ),
                            children: <Widget>[
                              ListTile(
                                title: RadioListTile(
                                  value: 1,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "1 Bread",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Pantry : Bread",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
                                  onChanged: (val) {
                                    print("Radio Tile pressed $val");
                                    setSelectedRadioTile(val);
                                  },
                                  activeColor: Color(0xFF58B76E),
                                  selected: false,
                                ),
                              ),
                              ListTile(
                                title: RadioListTile(
                                  value: 2,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "4 Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Pantry : Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
                                  onChanged: (val) {
                                    print("Radio Tile pressed $val");
                                    setSelectedRadioTile(val);
                                  },
                                  activeColor: Color(0xFF58B76E),
                                  selected: false,
                                ),
                              ),
                              ListTile(
                                title: RadioListTile(
                                  value: 3,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "4 Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Pantry : Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
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
                          custom.ExpansionTile(
                            headerBackgroundColor: Colors.white,
                            title: Container(
                              child: Text(
                                "Produce (2)",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF535252)),
                              ),
                            ),
                            children: <Widget>[
                              ListTile(
                                title: RadioListTile(
                                  value: 4,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "1 ltr Milk",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Diary : Milk",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
                                  onChanged: (val) {
                                    print("Radio Tile pressed $val");
                                    setSelectedRadioTile(val);
                                  },
                                  activeColor: Color(0xFF58B76E),
                                  selected: false,
                                ),
                              ),
                              ListTile(
                                title: RadioListTile(
                                  value: 5,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "4 Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Pantry : Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
                                  onChanged: (val) {
                                    print("Radio Tile pressed $val");
                                    setSelectedRadioTile(val);
                                  },
                                  activeColor: Color(0xFF58B76E),
                                  selected: false,
                                ),
                              ),
                              ListTile(
                                title: RadioListTile(
                                  value: 6,
                                  groupValue: selectedRadioTile,
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "4 Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                      Text(
                                        "In Pantry : Banana",
                                        style: TextStyle(
                                            color: Color(0xFF535252)),
                                      ),
                                    ],
                                  ),
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
                    ) : Container(),
                  ),
                )
              ],
            ),
          ),
          isSearchEnable
              ? Container(
            height: MediaQuery.of(context).size.height * .9,
            width: MediaQuery.of(context).size.width * 1,
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: ListView(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: getAllWidget(),
              ),
            ),
          )
              : Container(),
        ],
      ),
    );

   /* if (items == null || items.length == 0) {
      return Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: ListView(
                children: [
                  getCommonHeader(),
                  Container(
                    //color: Colors.greenAccent,
                    height: MediaQuery.of(context).size.height*.74,
                    child: Container(
                      child: isShoppingEnable
                          ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            custom.ExpansionTile(
                              headerBackgroundColor: Colors.white,
                              title: Container(
                                child: Text(
                                  "Bakery (2)",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF535252)),
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: RadioListTile(
                                    value: 1,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "1 Bread",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Pantry : Bread",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
                                    onChanged: (val) {
                                      print("Radio Tile pressed $val");
                                      setSelectedRadioTile(val);
                                    },
                                    activeColor: Color(0xFF58B76E),
                                    selected: false,
                                  ),
                                ),
                                ListTile(
                                  title: RadioListTile(
                                    value: 2,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "4 Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Pantry : Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
                                    onChanged: (val) {
                                      print("Radio Tile pressed $val");
                                      setSelectedRadioTile(val);
                                    },
                                    activeColor: Color(0xFF58B76E),
                                    selected: false,
                                  ),
                                ),
                                ListTile(
                                  title: RadioListTile(
                                    value: 3,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "4 Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Pantry : Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
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
                            custom.ExpansionTile(
                              headerBackgroundColor: Colors.white,
                              title: Container(
                                child: Text(
                                  "Produce (2)",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF535252)),
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: RadioListTile(
                                    value: 4,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "1 ltr Milk",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Diary : Milk",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
                                    onChanged: (val) {
                                      print("Radio Tile pressed $val");
                                      setSelectedRadioTile(val);
                                    },
                                    activeColor: Color(0xFF58B76E),
                                    selected: false,
                                  ),
                                ),
                                ListTile(
                                  title: RadioListTile(
                                    value: 5,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "4 Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Pantry : Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
                                    onChanged: (val) {
                                      print("Radio Tile pressed $val");
                                      setSelectedRadioTile(val);
                                    },
                                    activeColor: Color(0xFF58B76E),
                                    selected: false,
                                  ),
                                ),
                                ListTile(
                                  title: RadioListTile(
                                    value: 6,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "4 Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Pantry : Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
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
                      )
                          : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            custom.ExpansionTile(
                              headerBackgroundColor: Colors.white,
                              title: Container(
                                child: Text(
                                  "Bakery (2)",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF535252)),
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: RadioListTile(
                                    value: 1,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "1 Bread",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Pantry : Bread",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
                                    onChanged: (val) {
                                      print("Radio Tile pressed $val");
                                      setSelectedRadioTile(val);
                                    },
                                    activeColor: Color(0xFF58B76E),
                                    selected: false,
                                  ),
                                ),
                                ListTile(
                                  title: RadioListTile(
                                    value: 2,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "4 Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Pantry : Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
                                    onChanged: (val) {
                                      print("Radio Tile pressed $val");
                                      setSelectedRadioTile(val);
                                    },
                                    activeColor: Color(0xFF58B76E),
                                    selected: false,
                                  ),
                                ),
                                ListTile(
                                  title: RadioListTile(
                                    value: 3,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "4 Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Pantry : Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
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
                            custom.ExpansionTile(
                              headerBackgroundColor: Colors.white,
                              title: Container(
                                child: Text(
                                  "Produce (2)",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF535252)),
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: RadioListTile(
                                    value: 4,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "1 ltr Milk",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Diary : Milk",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
                                    onChanged: (val) {
                                      print("Radio Tile pressed $val");
                                      setSelectedRadioTile(val);
                                    },
                                    activeColor: Color(0xFF58B76E),
                                    selected: false,
                                  ),
                                ),
                                ListTile(
                                  title: RadioListTile(
                                    value: 5,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "4 Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Pantry : Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
                                    onChanged: (val) {
                                      print("Radio Tile pressed $val");
                                      setSelectedRadioTile(val);
                                    },
                                    activeColor: Color(0xFF58B76E),
                                    selected: false,
                                  ),
                                ),
                                ListTile(
                                  title: RadioListTile(
                                    value: 6,
                                    groupValue: selectedRadioTile,
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "4 Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                        Text(
                                          "In Pantry : Banana",
                                          style: TextStyle(
                                              color: Color(0xFF535252)),
                                        ),
                                      ],
                                    ),
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
                      ),
                    ),
                  )
                ],
              ),
            ),
            isSearchEnable
                ? Container(
                    height: MediaQuery.of(context).size.height * .9,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.0,
                      ),
                      child: ListView(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: getAllWidget(),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    } else {
      return Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: ListView(
                children: [
                  getCommonHeader(),
                  Center(
                    child: isShoppingEnable
                        ? Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 35.0,
                                  ),
                                  Icon(
                                    Icons.shopping_cart,
                                    size: 60.0,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Text(
                                    'Shopping cart is empty',
                                    style: TextStyle(
                                        color: Color(0xFF535252),
                                        fontSize: 17.0),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'Add something to your list',
                                    style: TextStyle(
                                        color: Color(0xFF535252),
                                        fontSize: 17.0),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'Adding them by selecting the add button',
                                    style: TextStyle(
                                        color: Color(0xFF535252),
                                        fontSize: 17.0),
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  Container(
                                    //padding: EdgeInsets.symmetric(horizontal: 25.0),
                                    width:
                                        MediaQuery.of(context).size.width * .6,
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              .6,
                                    ),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Color(0xFF58B76E),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(
                                          child: Text('Easily add from recipes',
                                              style: TextStyle(
                                                  color: Color(0xFF535252),
                                                  fontSize: 17.0),
                                              textAlign: TextAlign.left),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    //padding: EdgeInsets.symmetric(horizontal: 25.0),
                                    width:
                                        MediaQuery.of(context).size.width * .6,
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Color(0xFF58B76E),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(
                                          child: Text('Order Groceries Onlines',
                                              style: TextStyle(
                                                  color: Color(0xFF535252),
                                                  fontSize: 17.0),
                                              textAlign: TextAlign.left),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    //padding: EdgeInsets.symmetric(horizontal: 25.0),
                                    width:
                                        MediaQuery.of(context).size.width * .6,
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Color(0xFF58B76E),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                              'Make your own shopping list',
                                              style: TextStyle(
                                                color: Color(0xFF535252),
                                                fontSize: 17.0,
                                              ),
                                              textAlign: TextAlign.left),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        .23),
                                child: Image.asset('images/broken_arrow.png'),
                              )
                            ],
                          )
                        : Container(),
                  )
                ],
              ),
            ),
            isSearchEnable
                ? Container(
                    height: MediaQuery.of(context).size.height * .35,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.0,
                      ),
                      child: ListView(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: getAllWidget(),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xFF58B76E),
          centerTitle: true,
          title: isSearchEnable ? buildSearchField() : Text('Shopping List'),
          actions: [
            !isSearchEnable
                ? IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      //_showPicker(context);
                      setState(() {
                        isSearchEnable = !isSearchEnable;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      //_showPicker(context);
                      setState(() {
                        isSearchEnable = !isSearchEnable;
                      });
                    },
                  )
          ],
        ),
        drawer: SafeArea(
          child: DrawerWidget(),
        ),
        backgroundColor: isSearchEnable ? Colors.grey : Colors.white,
        body: getBody(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !isSearchEnable ? FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, OrderGroceryPage.id);
          },
          label: Text('Order Ingredients'),
          backgroundColor: Color(0xFF58B76E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ) : Container(),
      ),
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
