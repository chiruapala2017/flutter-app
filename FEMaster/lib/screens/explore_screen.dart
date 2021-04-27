//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/bottom_widget.dart';
import 'package:food_app/components/drawer_widget.dart';
import 'package:food_app/components/explore_widget.dart';
import 'package:food_app/screens/about_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:polygon_clipper/polygon_border.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:food_app/components/appbar.dart';

import 'landing_screen.dart';

class ExploreScreen extends StatefulWidget {
  static final id = "explore_screen";
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  //final _auth = FirebaseAuth.instance;
  //FirebaseUser user;
  String email;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
      appBar: Appbar(),
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExploreWidget(
                  imagePath: 'images/Rectangle39.png',
                  imageText: 'Recipes',
                ),
                ExploreWidget(
                  imagePath: 'images/Rectangle40.png',
                  imageText: 'Popular',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExploreWidget(
                  imagePath: 'images/Rectangle44.png',
                  imageText: 'Article',
                ),
                ExploreWidget(
                  imagePath: 'images/Rectangle45.png',
                  imageText: 'Videos',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExploreWidget(
                  imagePath: 'images/Rectangle39.png',
                  imageText: 'video',
                ),
                ExploreWidget(
                  imagePath: 'images/Rectangle40.png',
                  imageText: 'Popular',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExploreWidget(
                  imagePath: 'images/Rectangle39.png',
                  imageText: 'video',
                ),
                ExploreWidget(
                  imagePath: 'images/Rectangle40.png',
                  imageText: 'Popular',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExploreWidget(
                  imagePath: 'images/Rectangle39.png',
                  imageText: 'video',
                ),
                ExploreWidget(
                  imagePath: 'images/Rectangle40.png',
                  imageText: 'Popular',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExploreWidget(
                  imagePath: 'images/Rectangle39.png',
                  imageText: 'video',
                ),
                ExploreWidget(
                  imagePath: 'images/Rectangle40.png',
                  imageText: 'Popular',
                ),
              ],
            )
          ],
        ),
      ),
      drawer: SafeArea(
        child: DrawerWidget(),
      ),
      bottomNavigationBar: BottomWidget(activeIndex:1),
    );
  }
}
