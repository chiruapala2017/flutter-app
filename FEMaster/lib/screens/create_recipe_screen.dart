import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:food_app/screens/create_recipe2_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import 'contact_page_screen.dart';
import 'package:food_app/utils/urls.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/components/alert_dialog_widget.dart';

class CreateRecipeScreen extends StatefulWidget {
  static final id = "create_recipe_screen";

  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  String recipeName;
  int counter = 0;
  bool is_easy = false;
  bool is_medium = false;
  bool is_hard = false;
  final _text = TextEditingController();

  File file;
  final picker = ImagePicker();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  _imgFromCamera() async {
    PickedFile image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      file = File(image.path);
      recipeImage = file;
    });
  }

  _imgFromGallery() async {
    PickedFile image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      file = File(image.path);
      recipeImage = file;
    });
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
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void createRecipe(recipeName, file) async {
    print(file.path);
    var image = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType('image', 'jpg')
    );
    print(recipeName);
    print(image);
    setState(() {
      recipeObject['name_of_recipe'] = recipeName;
      recipeObject['image'] = image;
    });
  }

  bool validate() {
    if (_text.text.isEmpty) {
      return false;
    } else if (file == null) {
      return false;
    } else if (!(is_easy | is_medium | is_hard)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height*.07,
          centerTitle: true,
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
          //padding: const EdgeInsets.only(bottom: 15.0),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*.8,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Color(0xFF535252),
                          child: new LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width,
                            animation: true,
                            lineHeight: 3.0,
                            animationDuration: 2000,
                            percent: 0.25,
                            progressColor: Color(0xFFF16906),
                            backgroundColor: Color(0xFF535252),
                          ),
                        ),
                        Container(
                          height: 70.0,
                          color: Color(0xFFFFCE6C),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'We’re excited to see your recipe!',
                              style: TextStyle(
                                  color: Color(0xFF535252),
                                  fontSize: 15.0,
                                  wordSpacing: 2.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Name your recipe',
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
                            controller: _text,
                            onChanged: (value) {
                              setState(() {
                                counter = value.length;
                                recipeName = value;
                              });
                            },
                            obscureText: false,
                            decoration: kInputFieldDecoration.copyWith(
                                hintText: 'E.g. Apple Pie'),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${counter}/55',
                              style: TextStyle(color: Color(0xFF535252)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  'Add recipe photo',
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
                          ),
                          GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: file != null ? Colors.white : Color(0xFFFFDF95),
                                  border: Border.all(color: Color(0xFFF16906))),
                              width: double.infinity,
                              height: 200,
                              child: file != null
                                  ? ClipRRect(
                                /*borderRadius: BorderRadius.circular(55.0),*/
                                child: Image.file(
                                  file,
                                  fit: BoxFit.fitWidth,
                                ),
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 30.0,
                                    color: Color(0xFFF16906),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text(
                                      'Upload a photo of your dish',
                                      style: TextStyle(color: Color(0xFFF16906)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  'Difficulty',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                      color: Color(0xFF535252)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Material(
                                    elevation: 2.0,
                                    color: is_easy ? Color(0xFFFFDF95) : Colors.white,
                                    /*borderRadius: BorderRadius.circular(10.0),*/
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide(color: Color(0xFFFFDF95))
                                    ),
                                    child: MaterialButton(
                                      onPressed: (){
                                        setState(() {
                                          is_easy = !is_easy;
                                          is_medium = false;
                                          is_hard = false;
                                          recipeObject['difficulty'] = is_easy ? 'Easy' : '';
                                        });
                                      },
                                      minWidth: MediaQuery.of(context).size.width*.25,
                                      height: 42.0,
                                      child: Text(
                                        'Easy',
                                        style: TextStyle(color: is_easy ? Color(0xFF535252) : Color(0xFFF16906), fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    elevation: 2.0,
                                    color: is_medium ? Color(0xFFFFDF95) : Colors.white,
                                    /*borderRadius: BorderRadius.circular(10.0),*/
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide(color: Color(0xFFFFDF95))
                                    ),
                                    child: MaterialButton(
                                      onPressed: (){
                                        setState(() {
                                          is_medium = !is_medium;
                                          is_hard = false;
                                          is_easy = false;
                                          recipeObject['difficulty'] = is_medium ? 'Medium': '';
                                        });
                                      },
                                      minWidth: MediaQuery.of(context).size.width*.25,
                                      height: 42.0,
                                      child: Text(
                                        'Medium',
                                        style: TextStyle(color: is_medium ? Color(0xFF535252) : Color(0xFFF16906), fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    elevation: 2.0,
                                    color: is_hard ? Color(0xFFFFDF95) : Colors.white,
                                    /*borderRadius: BorderRadius.circular(10.0),*/
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide(color: Color(0xFFFFDF95))
                                    ),
                                    child: MaterialButton(
                                      onPressed: (){
                                        setState(() {
                                          is_hard = !is_hard;
                                          is_easy = false;
                                          is_medium = false;
                                          recipeObject['difficulty'] = is_hard ? 'Hard' : '';
                                        });
                                      },
                                      minWidth: MediaQuery.of(context).size.width*.25,
                                      height: 42.0,
                                      child: Text(
                                        'Hard',
                                        style: TextStyle(color: is_hard ? Color(0xFF535252) : Color(0xFFF16906), fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ]
                        )
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
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
                                setState(() {
                                  recipeObject['name_of_recipe'] = recipeName;
                                  recipeObject['image'] = recipeImage;
                                });
                                Navigator.pushNamed(context, CreateRecipe2Screen.id);
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width*.35,
                            height: 42.0,
                            child: Text(
                              'Next',
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
