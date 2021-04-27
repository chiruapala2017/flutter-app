import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/components/bottom_widget.dart';
import 'package:food_app/components/drawer_widget.dart';
import 'package:food_app/components/explore_widget.dart';
import 'package:food_app/components/recipe_template.dart';
import 'package:food_app/components/recipe_widget.dart';
import 'package:food_app/screens/about_screen.dart';
import 'package:food_app/screens/contact_page_screen.dart';
import 'package:food_app/screens/landing_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:polygon_clipper/polygon_border.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

import 'explore_screen.dart';

class RecipeScreen extends StatefulWidget {
  static final id = "recipe_screen";

  final String recipeType;

  const RecipeScreen({Key key, this.recipeType}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  //final _auth = FirebaseAuth.instance;
  //FirebaseUser user;
  String email;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void getCurrentUser() async {
    try {
      //user = await _auth.currentUser();
      //email = user.email;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF58B76E),
        centerTitle: true,
        title: Text(
          'Recipe',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      drawer: SafeArea(
        child: DrawerWidget(),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          children: [
            Container(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'images/tilesHeader.png',
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      child: Text(
                        widget.recipeType+' Recipes',
                        style: TextStyle(color: Colors.black, fontSize: 20.0),)
                  ),
                ],
              ),
            ),
            RecipeTemplate(
              recipeImage: 'images/masala_paneer.png',
              recipeName: 'Masal Paneer',
              recipeTime: '1',
              totalCalories: '150',
              totalServe: '4',
              author: 'Chiru\'s Kichen',
            ),
            RecipeTemplate(
              recipeImage: 'images/masala_paneer.png',
              recipeName: 'Khichri',
              recipeTime: '1',
              totalCalories: '150',
              totalServe: '4',
              author: 'Chiru\'s Kichen',
            ),
            RecipeTemplate(
              recipeImage: 'images/masala_paneer.png',
              recipeName: 'Pasta',
              recipeTime: '1',
              totalCalories: '150',
              totalServe: '4',
              author: 'Chiru\'s Kichen',
            ),
            RecipeTemplate(
              recipeImage: 'images/masala_paneer.png',
              recipeName: 'Masal Paneer',
              recipeTime: '1',
              totalCalories: '150',
              totalServe: '4',
              author: 'Chiru\'s Kichen',
            ),
            RecipeTemplate(
              recipeImage: 'images/masala_paneer.png',
              recipeName: 'Masal Paneer',
              recipeTime: '1',
              totalCalories: '150',
              totalServe: '4',
              author: 'Chiru\'s Kichen',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomWidget(activeIndex:1),
    );
  }
}
