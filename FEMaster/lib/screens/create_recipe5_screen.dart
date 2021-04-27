import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:food_app/utils/urls.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/screens/account_screen.dart';

class CreateRecipe5Screen extends StatefulWidget {
  static final id = "create_recipe5_screen";

  @override
  _CreateRecipe5ScreenState createState() => _CreateRecipe5ScreenState();
}

class _CreateRecipe5ScreenState extends State<CreateRecipe5Screen> {

  void createRecipe() async {
    try {
      var uri = Uri.parse(recipe_create_url);
      var request = http.MultipartRequest('POST', uri);
      Object body = {
        "name_of_recipe": recipeObject['name_of_recipe'],
        "image": recipeObject['image'],
        "servings": recipeObject['servings'],
        "recipe": recipeObject['steps'],
        "recipe_video": '',
        "coocking_time": '',
        "calories": '',
        "author": 2,
        "recipe_type": 1,
        "recipe_culture": 1,
        "recipe_geography": 1,
        "taste": 1,
        "ingredients": 1,
      };
      // http.Response response = await http.post(url, body: body, headers: {
      //   "Authorization": "Token $token",
      // });
      request.fields['name_of_recipe'] = recipeObject['name_of_recipe'];
      request.fields['recipe'] = recipeObject['steps'];
      request.fields['author'] = "1";
      request.fields['recipe_type'] = "1";
      request.fields['recipe_culture'] = "1";
      request.fields['recipe_geography'] = "1";
      request.fields['taste'] = "1";
      request.fields['ingredients'] = "1";
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', recipeObject['image'].path
        )
      );
      request.headers['Authorization'] = "Token $token";
      var response = await request.send();
      final responseData = await response.stream.bytesToString();
      // final Map<String, dynamic> responseData = json.decode(response.stream);
      print(response.statusCode);
      if (response.statusCode == 201) {
        setState(() {
          recipeObject = {};
        });
        AlertDialogWidget alertWidget = AlertDialogWidget(
            messages: [Text("Recipe created successfully")], context: this.context);
        await alertWidget.showMyDialog();
      }
    } catch (e) {
      AlertDialogWidget alertWidget = AlertDialogWidget(
          messages: [Text("Something went wrong")], context: this.context);
      await alertWidget.showMyDialog();
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * .3,
          backgroundColor: Color(0xFF58B76E),
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .3,
                  child: ClipRect(
                    child: recipeImage != null
                        ? ClipRRect(
                      /*borderRadius: BorderRadius.circular(55.0),*/
                      child: Image.file(
                        recipeImage,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                        : Image.asset(
                      'images/masala_paneer.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.clear,
                                  size: 30.0,
                                  color: Colors.white,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            /*Align(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.save,
                                  size: 30.0,
                                  color: Colors.white,
                                ),
                              ),
                              alignment: Alignment.centerRight,
                            ),*/
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 55.0,
                            backgroundColor: Colors.grey.shade300,
                            child: profileImageUrl != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(55.0),
                              child: Image.network(
                                profileImageUrl,
                                width: 100,
                                height: 100,
                                fit: profileImageOrientation ==
                                    'Horizontal'
                                    ? BoxFit.fitHeight
                                    : BoxFit.fitWidth,
                              ),
                            )
                                : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                  BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.person,
                                size: 75.0,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Align(
                              child: Text(
                                '${recipeObject['name_of_recipe']}',
                                style:
                                    TextStyle(fontSize: 18.0, color: Colors.white),
                              ),
                              alignment: Alignment.centerLeft,
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
        body: Container(
          height: MediaQuery.of(context).size.height*.7,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .585,
                //color: Colors.amber,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15.0),
                  child: ListView(
                    children: [
                      /*Container(
                        height: MediaQuery.of(context).size.height * .14,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 55.0,
                                  backgroundColor: Colors.grey.shade300,
                                  child: profileImage != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(55.0),
                                          child: Image.file(
                                            profileImage,
                                            width: 100,
                                            height: 100,
                                            fit: profileImageOrientation ==
                                                    'Horizontal'
                                                ? BoxFit.fitHeight
                                                : BoxFit.fitWidth,
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          width: 100,
                                          height: 100,
                                          child: Icon(
                                            Icons.person,
                                            size: 75.0,
                                            color: Colors.white70,
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  'Chiranjib Bakchi',
                                  style: TextStyle(
                                      fontSize: 18.0, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),*/
                      Container(
                        //height: MediaQuery.of(context).size.height * .49,
                        //color: Colors.greenAccent,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Image.asset(
                                  'images/border_line.png',
                                ),
                              ),*/
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  'Difficulty :  ${recipeObject['difficulty']}',
                                  style:
                                      TextStyle(color: Color(0xFF535252), fontSize: 20.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Image.asset(
                                  'images/border_line.png',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Material(
                                      elevation: 2.0,
                                      color: Colors.white,
                                      /*borderRadius: BorderRadius.circular(10.0),*/
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          side: BorderSide(color: Color(0xFF58B76E))),
                                      child: MaterialButton(
                                        onPressed: () {

                                        },
                                        minWidth: MediaQuery.of(context).size.width * .25,
                                        height: 42.0,
                                        child: Text(
                                          '${recipeObject['prep_time']}',
                                          style: TextStyle(
                                            color: Color(0xFF535252),
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      elevation: 2.0,
                                      color: Colors.white,
                                      /*borderRadius: BorderRadius.circular(10.0),*/
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          side: BorderSide(color: Color(0xFF58B76E))),
                                      child: MaterialButton(
                                        onPressed: () {

                                        },
                                        minWidth: MediaQuery.of(context).size.width * .25,
                                        height: 42.0,
                                        child: Text(
                                          '${recipeObject['baking_time']}',
                                          style: TextStyle(
                                            color: Color(0xFF535252),
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      elevation: 2.0,
                                      color: Colors.white,
                                      /*borderRadius: BorderRadius.circular(10.0),*/
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          side: BorderSide(color: Color(0xFF58B76E))),
                                      child: MaterialButton(
                                        onPressed: () {

                                        },
                                        minWidth: MediaQuery.of(context).size.width * .25,
                                        height: 42.0,
                                        child: Text(
                                          '${recipeObject['resting_time']}',
                                          style: TextStyle(
                                            color: Color(0xFF535252),
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text(
                                      'Prep',
                                      style: TextStyle(
                                          color: Color(0xFF535252), fontSize: 15.0),
                                    ),
                                  ),
                                  Text(
                                    'Baking',
                                    style: TextStyle(
                                        color: Color(0xFF535252), fontSize: 15.0),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Text(
                                      'Resting',
                                      style: TextStyle(
                                          color: Color(0xFF535252), fontSize: 15.0),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Image.asset(
                                  'images/border_line.png',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ingredients : ',
                                      style: TextStyle(
                                          color: Color(0xFF535252), fontSize: 20.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Material(
                                            elevation: 2.0,
                                            color: Colors.white,
                                            /*borderRadius: BorderRadius.circular(10.0),*/
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                side: BorderSide(color: Color(0xFF58B76E))),
                                            child: MaterialButton(
                                              onPressed: () {
                                                //Navigator.pushNamed(context, CreateRecipe2Screen.id);
                                              },
                                              minWidth: MediaQuery.of(context).size.width * .40,
                                              height: 42.0,
                                              child: Text(
                                                'Rice 750gm',
                                                style: TextStyle(
                                                  color: Color(0xFF535252),
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Material(
                                            elevation: 2.0,
                                            color: Colors.white,
                                            /*borderRadius: BorderRadius.circular(10.0),*/
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                side: BorderSide(color: Color(0xFF58B76E))),
                                            child: MaterialButton(
                                              onPressed: () {

                                              },
                                              minWidth: MediaQuery.of(context).size.width * .40,
                                              height: 42.0,
                                              child: Text(
                                                'Potato 150gm',
                                                style: TextStyle(
                                                  color: Color(0xFF535252),
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Steps : ',
                                      style: TextStyle(
                                          color: Color(0xFF535252), fontSize: 20.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                      child: Text(
                                        '${recipeObject['steps']}',
                                        style: TextStyle(
                                            color: Color(0xFF535252), fontSize: 15.0),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    /*Image.asset(
                      'images/border_line.png',
                    ),
                    SizedBox(
                      height: 20.0,
                    ),*/
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
                              createRecipe();
                              Navigator.pushNamed(context, AccountScreen.id);
                            },
                            minWidth: MediaQuery.of(context).size.width*.35,
                            height: 42.0,
                            child: Text(
                              'Submit Final Recipe',
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
        /*floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            //Navigator.pushNamed(context, CreateRecipeScreen.id);
          },
          label: Text('Submit Final Recipe'),
          backgroundColor: Color(0xFF58B76E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),*/
      ),
    );
  }
}
