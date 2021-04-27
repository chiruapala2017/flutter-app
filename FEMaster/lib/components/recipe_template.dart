import 'package:flutter/material.dart';
import 'package:food_app/screens/recipe_details_screen.dart';
import 'package:food_app/screens/recipe_screen.dart';

class RecipeTemplate extends StatelessWidget {
  final String recipeImage;
  final String recipeName;
  final String recipeTime;
  final String totalCalories;
  final String totalServe;
  final String author;
  final String recipeSlug;

  const RecipeTemplate({
    Key key,
    this.recipeImage,
    this.recipeName,
    this.recipeTime,
    this.totalCalories,
    this.totalServe,
    this.author,
    this.recipeSlug
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsScreen(recipeSlug: recipeSlug),
          ),
        );
      },
      child: Container(
          /*height: 100.0,*/
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      recipeImage,
                      height: 200.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
