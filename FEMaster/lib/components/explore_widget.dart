import 'package:flutter/material.dart';
import 'package:food_app/screens/explore_details_screen.dart';

class ExploreWidget extends StatelessWidget {
  final String imagePath;
  final String imageText;

  const ExploreWidget(
      {Key key, @required this.imagePath, @required this.imageText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ExploreDetailsScreen(exploreSection: imageText),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        width: MediaQuery.of(context).size.width * .45,
        height: 150.0,
        child: Stack(
          children: [
            Align(
              child: Image.asset(
                imagePath,
                height: 200.0,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                imageText,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
