import 'package:flutter/material.dart';
import 'package:food_app/screens/account_screen.dart';
import 'package:food_app/screens/explore_screen.dart';
import 'package:food_app/screens/landing_screen.dart';
import 'package:food_app/screens/meal_planner_screen.dart';
import 'package:food_app/screens/shopping_list_screen.dart';
import 'package:food_app/utils/constants.dart';

class BottomWidget extends StatelessWidget {
  final int activeIndex;
  const BottomWidget({
    Key key, this.activeIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void navigateToOtherPage(int index) {
      //print(index);
      if(index == 0){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LandingScreen(emailId: appUserId, token: token,)));
      }else if(index == 1){
        Navigator.pushNamed(context, ExploreScreen.id);
      }else if(index == 2){
        Navigator.pushNamed(context, MealPlannerScreen.id);
      }else if(index == 3){
        Navigator.pushNamed(context, ShoppingListScreen.id);

      }else if(index == 4){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AccountScreen(index: 1,)));
      }
    }

    return BottomNavigationBar(
      currentIndex: activeIndex,
      selectedItemColor: Color(0xFF58B76E),
      unselectedItemColor: Colors.black,
      onTap: (index){
        navigateToOtherPage(index);
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          title: Text(
            'Home',
            style: TextStyle(
                color: Color(0xFF535252), fontWeight: FontWeight.bold),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.import_contacts),
          title: Text(
            'Recipes',
            style: TextStyle(
                color: Color(0xFF535252), fontWeight: FontWeight.bold),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text(
            'Planner',
            style: TextStyle(
                color: Color(0xFF535252), fontWeight: FontWeight.bold),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text(
            'Shopping',
            style: TextStyle(
                color: Color(0xFF535252), fontWeight: FontWeight.bold),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          title: Text(
            'Account',
            style: TextStyle(
                color: Color(0xFF535252), fontWeight: FontWeight.bold),
          ),
        ),
      ],
      backgroundColor: Color(0xFFEEEEEE),
      type: BottomNavigationBarType.fixed,
    );
  }


}
