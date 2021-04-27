import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_app/components/bottom_widget.dart';
import 'package:food_app/components/explore_widget.dart';
import 'package:food_app/components/profile_header_widget.dart';

class AccountCookbookScreen extends StatefulWidget {
  static final id = "account_preference_screen";
  final int index;

  const AccountCookbookScreen({Key key, this.index}) : super(key: key);
  @override
  _AccountCookbookScreenState createState() => _AccountCookbookScreenState();
}

class _AccountCookbookScreenState extends State<AccountCookbookScreen> with SingleTickerProviderStateMixin{

  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController = new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;

  @override
  void initState() {
    super.initState();
    myScroll();
  }

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }


  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        print('reverse');
        setState(() {
          if (!isScrollingDown) {
            isScrollingDown = true;
            _showAppbar = false;
          }
        });

      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        print('forward');
        setState(() {
          if (isScrollingDown) {
            isScrollingDown = false;
            _showAppbar = true;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _showAppbar ? AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          //toolbarHeight: MediaQuery.of(context).size.height * .27,
          toolbarHeight : 210.0,
          flexibleSpace: ProfileHeaderWidget(
            tabIndex: widget.index,
          ),
        ) : PreferredSize(
          child: Container(),
          preferredSize: Size(0.0, 0.0),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListView(
              controller: _scrollBottomBarController,
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
        ),
        bottomNavigationBar: BottomWidget(activeIndex: 4),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Text('Add Cookbook'),
          icon: Icon(Icons.add),
          backgroundColor: Color(0xFF58B76E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),
      ),
    );;
  }
}
