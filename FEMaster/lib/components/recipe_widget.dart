import 'package:flutter/material.dart';
import 'package:food_app/screens/recipe_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Recipe extends StatelessWidget {
  final String type;
  final String recipeImage;
  final String recipeName;
  final String recipeTime;
  final String totalCalories;
  final String totalServe;
  final String author;
  final String recipeSlug;
  final String videoId;

  const Recipe({
    Key key,
    this.type,
    this.recipeImage,
    this.recipeName,
    this.recipeSlug,
    this.recipeTime,
    this.totalCalories,
    this.totalServe,
    this.author,
    this.videoId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsScreen(
                recipeSlug: recipeSlug,
                videoId: videoId,
              ),
            ));
      },
      child: Container(
          /*height: 100.0,*/
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    //alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    width: MediaQuery.of(context).size.width,
                    child: recipeImage!=''?Image.network(
                      recipeImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      //width: MediaQuery.of(context).size.width * 1,
                      loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null ?
                                  loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                        );
                      },
                      height: 200.0,
                    ): Container(
                      height: 200.0,
                      child: Image.asset('images/masala_paneer.png'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 120.0,
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: type == 'Non Vegetarian' ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0),
                        ),
                        child: MaterialButton(
                          onPressed: () {},
                          // color: Colors.black,
                          /*clipBehavior: Clip.hardEdge,*/
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              type,
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          height: 20.0,
                          minWidth: 50.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipeName,
                      style: TextStyle(fontSize: 25.0),
                    ),
                    Text(recipeTime +
                        ' HR, ' +
                        totalCalories +
                        ' Calories, ' +
                        totalServe +
                        ' Serves'),
                    Text(author),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
