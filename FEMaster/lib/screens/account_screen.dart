import 'package:flutter/material.dart';
import 'package:food_app/components/bottom_widget.dart';
import 'package:food_app/components/profile_header_widget.dart';
import 'package:food_app/components/recipe_template.dart';
import 'package:food_app/screens/create_recipe_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:food_app/utils/urls.dart';
import 'package:food_app/utils/constants.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:food_app/components/recipe_widget.dart';

class AccountScreen extends StatefulWidget {
  static final id = "account_screen";
  final int index;
  const AccountScreen({Key key,@required this.index}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool showSpinner = false;
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  void getRecipes() async {
    String url;
    setState(() {
      showSpinner = true;
    });
    try {
      url = user_profile_url;
      final Response response = await get(url, headers: {
        "Authorization": "Token $token",
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      // if (response.statusCode == 200) {
        responseData['results']['recipes'].forEach((i) {
          final Recipe recipe = Recipe(
            type: i['recipe_type'],
            recipeImage: i['image'],
            recipeName: i['name_of_recipe'],
            recipeTime: i['cooking_time'].toString(),
            totalCalories: i['calories'].toString(),
            totalServe: i['servings'].toString(),
            author: responseData['results']['user']['name'],
            recipeSlug: i['slug'],
            videoId: "i['recipe_video']",
          );
          setState(() {
            if (!recipes.contains(recipe)) {
              recipes.add(recipe);
            }
          });
        });
        setState(() {
          showSpinner = false;
        });
      // }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print(e);
    }
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
          /*toolbarHeight: MediaQuery.of(context).size.height * .27,*/
          toolbarHeight : 210.0,
          flexibleSpace: ProfileHeaderWidget(
            tabIndex: widget.index,
          ),
        ),
        bottomNavigationBar: BottomWidget(activeIndex: 4),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, CreateRecipeScreen.id);
          },
          label: Text('Add Recipe'),
          icon: Icon(Icons.add),
          backgroundColor: Color(0xFF58B76E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: ListView.builder(
              itemCount: this.recipes.length,
              itemBuilder: (context, index) {
                Recipe recipe = recipes[index];
                return recipe;
              },
            ),
          ),
        ),
      ),
    );
  }
}
