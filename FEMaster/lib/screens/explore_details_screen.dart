//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/bottom_widget.dart';
import 'package:food_app/components/drawer_widget.dart';
import 'package:food_app/components/explore_item.dart';
import 'package:food_app/components/explore_widget.dart';
import 'package:food_app/screens/about_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:polygon_clipper/polygon_border.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

import 'landing_screen.dart';

class ExploreDetailsScreen extends StatefulWidget {
  static final id = "landing_screen";
  final String exploreSection;

  const ExploreDetailsScreen({Key key, this.exploreSection}) : super(key: key);

  @override
  _ExploreDetailsScreenState createState() => _ExploreDetailsScreenState();
}

class _ExploreDetailsScreenState extends State<ExploreDetailsScreen> {
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
      appBar: AppBar(
        backgroundColor: Color(0xFF58B76E),
        centerTitle: true,
        title: Text(
          ' Explore ' + widget.exploreSection,
          style: TextStyle(
            color: Colors.white,
          ),
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
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
          children: [
            ExploreItem(
              itemHeader: 'Food help you to stay calm',
              itemImage: 'images/masala_paneer.png',
              itemFooter: 'Cooking stories',
            ),
            ExploreItem(
              itemHeader: 'Boost your imune system',
              itemImage: 'images/masala_paneer.png',
              itemFooter: 'Boost support recipes for imunity booster',
            ),
            ExploreItem(
              itemHeader: 'Food help you to stay calm',
              itemImage: 'images/masala_paneer.png',
              itemFooter: 'Cooking stories',
            ),
            ExploreItem(
              itemHeader: 'creative use of leftover',
              itemImage: 'images/masala_paneer.png',
              itemFooter: 'Cooking stories',
            ),
            ExploreItem(
              itemHeader: 'Food help you to stay calm',
              itemImage: 'images/masala_paneer.png',
              itemFooter: 'Cooking stories',
            )

          ],
        ),
      ),
      drawer: SafeArea(
        child: DrawerWidget(),
      ),
      bottomNavigationBar: BottomWidget(activeIndex: 1),
    );
  }
}
