import 'package:flutter/material.dart';
import 'package:food_app/screens/landing_screen.dart';
import 'package:food_app/screens/explore_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/animations/search_bar_animation.dart';
import 'package:food_app/components/search_bar.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  _AppbarState createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> with SingleTickerProviderStateMixin {
  double rippleStartX, rippleStartY;
  AnimationController _controller;
  Animation _animation;
  bool isInSearchMode = false;

  @override
  void initState() {
    // TODO: implement initState
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener(animationStatusListener);
  }

  animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      setState(() {
       isInSearchMode = true; 
      });
    }
  }

  void onSearchTapUp(TapUpDetails details) {
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });
    print("pointer location $rippleStartX, $rippleStartY");
    _controller.forward();
  }

  cancelSearch() {
    setState(() {
      isInSearchMode = false;
  });

  onSearchQueryChange('');
    _controller.reverse();
  }

  onSearchQueryChange(String query) {
    print('search $query');
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        AppBar(
          backgroundColor: Color(0xFF58B76E),
          centerTitle: true,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LandingScreen(emailId: appUserId, token: token)));
                },
                child: Text(
                  'Just For You |',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ExploreScreen.id);
                  // print(token);
                },
                child: Text(
                  ' Explore',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              onTapUp: onSearchTapUp,
            )
          ],
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: MyPainter(
                containerHeight: widget.preferredSize.height,
                center: Offset(rippleStartX ?? 0, rippleStartY ?? 0),
                radius: _animation.value * screenWidth,
                context: context,
              ),
            );
          },
        ),
        isInSearchMode ? (
        SearchBar(
          onCancelSearch: cancelSearch,
          onSearchQueryChanged: onSearchQueryChange,
        )
        ) : (
        Container()
        )
      ],
    );
  }
}
