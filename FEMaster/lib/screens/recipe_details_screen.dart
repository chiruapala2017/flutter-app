import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/components/recipe_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';

import 'package:food_app/screens/your_recipe_screen.dart';
import 'package:food_app/utils/urls.dart';
import 'package:food_app/utils/constants.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String recipeSlug;
  final String videoId;
  static final id = "recipe_details_screen";

  const RecipeDetailsScreen({Key key, this.recipeSlug, this.videoId})
      : super(key: key);

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  YoutubePlayerController _controller;
  bool isFavorite = false;
  bool isLike = false;
  bool isSave = false;
  bool showSpinner = false;
  String cookingTime = "1";
  String calories = "200";
  String servings = "3";
  String method;
  String likes = "0";
  String recipeName="Chicken Biriany";
  String author = "ChiruKaKhana";
  String authorId = "1";
  String recipeImage;
  List ingredientsList;
  List<Ingredient> ingredients = [];
  String videoId;

  @override
  void initState() {
    print("video id is :"+widget.videoId);
    print("recipeSlug id is :"+widget.recipeSlug);

    if(widget.videoId!=null && !widget.videoId.isEmpty){
      videoId = widget.videoId;
    }
    else{
      videoId = "95BCU1n268w";
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(autoPlay: true, isLive: true),
    );
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getRecipeDetail();
  }

  void getRecipeDetail() async {
    String url;
    setState(() {
      showSpinner = true;
    });
    try {
      url = recipe_url + '${widget.recipeSlug}/';
      print('url $url');
      final http.Response response = await http.get(url, headers: {
        "Authorization": "Token $token",
      });

      if (response.statusCode == 200) {

        //print("Server call successfull" + response.body.toString());
        final Map<String, dynamic> responseData = json.decode(response.body);

        print(json.decode(responseData['ingredients'][0]));
        url = recipe_url + '${widget.recipeSlug}/like/';
        final http.Response likeResponse =
        await http.post(url, headers: {
          "Authorization": "Token $token",
        });

        final Map<String, dynamic> likeData = json.decode(likeResponse.body);
        setState(() {
          cookingTime = responseData['cooking_time']!=null ?  responseData['cooking_time'].toString() : "2";
          calories = responseData['calories'] !=null ? responseData['calories'].toString() : "200";
          servings = responseData['servings'].toString();
          method = responseData['recipe'];
          likes = responseData['likes_count'].toString();
          recipeName = responseData['name_of_recipe'];
          author = responseData['author'];
          authorId = responseData['author_id'].toString();
          showSpinner = false;
          isLike = likeData['user_has_liked'];
          recipeImage = responseData['image'];
          ingredientsList = json.decode(responseData['ingredients'][0]);
        });
        ingredientsList.forEach((i) {
          final Ingredient ingredient = Ingredient(ingredientName: "${i['name']} ${i['quantity']}${i['unit']}");
          setState(() {
            if (!ingredients.contains(ingredient)) {
              ingredients.add(ingredient);
            }
          });
        });
      }else{
        print("Server error occurs "+response.toString());
      }

    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print(e);
    }
  }

  @override
  @mustCallSuper
  dispose() {
    //_controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void share(BuildContext context, String recipeName, String recipeImage) {
    final RenderBox box = context.findRenderObject();

    Share.share(
      recipeName,
      subject: "Checkout my recipe",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  void addAlltoShopingList() async {
    try {
      String url = add_all_to_cart_url;
      http.Response response = await http.post(
        url,
        body: {'content': json.encoder.convert(ingredientsList.toString())},
        headers: {'Authorization': 'Token $token', 'ContentType': 'Application/Json'}
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * .35
                : MediaQuery.of(context).size.height * 1,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: YoutubePlayer(
                  controller: _controller,
                  liveUIColor: Colors.amber,
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      IconButton(
                        alignment: Alignment.topLeft,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        alignment: Alignment.topRight,
                        icon: Icon(
                          Icons.cast,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () {
                          //Navigator.pop(context);
                        },
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$recipeName',
                              style: TextStyle(color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.pause();
                                  }
                                });
                                print('user id - $authorId');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YourRecipeScreen(
                                              yourChannel: '$author',
                                              userId: '$authorId',
                                            )));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white)),
                                  child: Text(
                                    '$author',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Column(
                          children: [
                            Text(
                              '$likes',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                String url = recipe_url;
                                try {
                                  url = recipe_url + '${widget.recipeSlug}/like/';
                                  print('url $url');
                                  if (isLike == false) {
                                    final http.Response response =
                                    await http.post(url, headers: {
                                      "Authorization": "Token $token",
                                    });
                                    final Map<String, dynamic> responseData = json.decode(response.body);
                                    print(response.body);
                                    setState(() {
                                      isLike = responseData['user_has_liked'];
                                      likes = responseData['likes_count'].toString();
                                    });
                                  } else {
                                      final http.Response response =
                                      await http.delete(url, headers: {
                                        "Authorization": "Token $token",
                                      });
                                      final Map<String, dynamic> responseData = json.decode(response.body);
                                      print(response.body);
                                      setState(() {
                                        isLike = responseData['user_has_liked'];
                                        likes = responseData['likes_count'].toString();
                                      });
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Icon(
                                Icons.thumb_up,
                                size: 24.0,
                                color: isLike != true
                                    ? Colors.white
                                    : Color(0xFF58B76E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              /*Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  children: [
                    Text('Meatball with tomato sauce'),
                    Text('Mandy\'s Chef'),
                  ],
                ),
              )*/
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                },
                                child: Icon(
                                  Icons.favorite,
                                  size: 24.0,
                                  color: isFavorite != true
                                      ? Color(0xFFC4C4C4)
                                      : Color(0xFF58B76E),
                                ),
                              ),
                              Text(
                                '12354',
                                style: TextStyle(fontSize: 18.0),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0, vertical: 5.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSave = !isSave;
                                  });
                                },
                                child: Icon(
                                  Icons.save,
                                  size: 24.0,
                                  color: isSave != true
                                      ? Color(0xFFC4C4C4)
                                      : Color(0xFF58B76E),
                                ),
                              ),
                              Text(
                                '124',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              GestureDetector(
                                onTap: () => share(context, recipeName, recipeImage),
                                child: Icon(
                                  Icons.share,
                                  size: 24.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Image.asset(
                      'images/border_line.png',
                      height: 20.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$cookingTime Hours . $calories Calories . Serves $servings',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ingredients',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text(
                                'Serving',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Icon(
                                Icons.remove_circle,
                                size: 24.0,
                                color: Color(0xFF58B76E),
                              ),
                              Text(
                                '$servings',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Icon(
                                Icons.add_circle,
                                size: 24.0,
                                color: Color(0xFF58B76E),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                'Shopping',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Icon(
                                Icons.shopping_cart,
                                size: 24.0,
                                color: Color(0xFFC4C4C4),
                              ),
                              Text(
                                'Buy',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Icon(
                                Icons.shop,
                                size: 24.0,
                                color: Color(0xFFC4C4C4),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Align(
                      heightFactor: 2.0,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            size: 24.0,
                            color: Color(0xFFC4C4C4),
                          ),
                          GestureDetector(
                            onTap: () {
                              addAlltoShopingList();
                              print('Hi');
                            },
                            child: Text(
                              'Add all to shopping list',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ingredients != null ? ingredients : [],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Method',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Step 1:',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Preheat oven to 200F',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Step 2:',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Put oil into it and heat it for 2 minutes',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Put onion jeera, dhania and tomato and cook it for 5 minutes',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Step 3:',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Put chicken on it and fry with high flame',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Put salt and garam masala and cook it for another 15 minutes',
                              style: TextStyle(fontSize: 18.0),
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


class Ingredient extends StatefulWidget {
  Ingredient({this.ingredientName}):super();
  final String ingredientName;
  @override
  _IngredientState createState() => _IngredientState();
}

class _IngredientState extends State<Ingredient> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Align(
            heightFactor: 1.0,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  Icons.add_circle,
                  size: 24.0,
                  color: Color(0xFFC4C4C4),
                ),
                Text(
                  '${widget.ingredientName}',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
          Image.asset(
            'images/border_line.png',
          ),
        ],
      ),
    );
  }
}

