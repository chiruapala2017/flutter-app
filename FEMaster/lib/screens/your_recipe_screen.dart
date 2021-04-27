import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:food_app/utils/urls.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/components/cook_book.dart';

class YourRecipeScreen extends StatefulWidget {
  static final id = "your_recipe_screen";

  final String yourChannel;
  final String userId;

  const YourRecipeScreen({Key key, this.yourChannel, @required this.userId}) : super(key: key);

  @override
  _YourRecipeScreenState createState() => _YourRecipeScreenState();
}

class _YourRecipeScreenState extends State<YourRecipeScreen> {

  bool followFlag = false;

  void followUnfollowUser() async {
    try {
      Object body = {
        'user_id': widget.userId,
      };
      final http.Response response =
        await http.post(follow_unfollow_url, body: body, headers: {
        "Authorization": "Token $token",
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['activity'] == 'follow') {
          setState(() {
            followFlag = true;
          });
        } else {
          setState(() {
            followFlag = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.yourChannel,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('images/carbon_user-avatar-filled.png'),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${widget.yourChannel}',
                            style: TextStyle(
                                color: Color(0xFF535252), fontSize: 20.0),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              followUnfollowUser();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF58B76E),
                                  border: Border.all(
                                    color: Color(0xFF58B76E),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Text(
                                followFlag ? 'Following' : 'Follow',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(
                        '10 following 5 followers',
                        style: TextStyle(color: Color(0xFF535252)),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 15.0),
                child: Text(
                  'I love anything food, and always up for trying new recipes in my little kitchen. My food blog is all about choosing recipe to suit your mood, even when you are really might not want to cook!',
                  style: TextStyle(
                      color: Color(0xFF535252),
                      fontSize: 15.0,
                      wordSpacing: 2.0),
                ),
              ),
              Center(
                child: Text(
                  'CookBook',
                  style: TextStyle(
                      color: Color(0xFF58B76E),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Image.asset(
                'images/border_line.png',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: CookBook(
                    imagePath: 'images/cookBook1.png',
                    footerText: 'Aubergine Dhansak',
                  )),
                  Flexible(
                      child: CookBook(
                    imagePath: 'images/cookBook2.png',
                    footerText: 'Meatless meatballs with tomato sauce',
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
