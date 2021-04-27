//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/SignInDemo.dart';
import 'package:food_app/screens/manage_streaming_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_app/components/barcode_scanner_screen.dart';
import 'package:food_app/screens/about_screen.dart';
import 'package:food_app/screens/contact_page_screen.dart';
import 'package:food_app/screens/health_profile_screen.dart';
import 'package:food_app/screens/live_streaming_page.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:food_app/screens/publish_story_screen.dart';
import 'package:food_app/screens/order_history_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/utils/urls.dart';
import 'package:http/http.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {}

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: [
            Container(
              height: (AppBar().preferredSize.height * 1.12),
              child: DrawerHeader(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Hi ' + appUserId,
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF58B76E),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Contact Us',
                style: TextStyle(fontSize: 20.0),
              ),
              focusColor: Colors.green,
              leading: Icon(
                Icons.contact_phone,
                color: Color(0xFF58B76E),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, ContactPageScreen.id);
              },
            ),
            ListTile(
              focusColor: Colors.green,
              leading: Icon(
                Icons.feedback,
                color: Color(0xFF58B76E),
              ),
              title: Text(
                'Feedback',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              focusColor: Colors.green,
              leading: Icon(
                Icons.local_hospital,
                color: Color(0xFF58B76E),
              ),
              title: Text(
                'Health Profile',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushNamed(context, HealthProfileScreen.id);
              },
            ),
            ListTile(
              focusColor: Colors.green,
              leading: Icon(
                Icons.add_shopping_cart,
                color: Color(0xFF58B76E),
              ),
              title: Text(
                'My Orders',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushNamed(context, OrderHistoryScreen.id);
              },
            ),
            ListTile(
              focusColor: Colors.green,
              leading: Icon(
                Icons.scanner,
                color: Color(0xFF58B76E),
              ),
              title: Text(
                'Scan Item',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushNamed(context, BarCodeScanner.id);
              },
            ),
            ListTile(
              focusColor: Colors.green,
              leading: Icon(
                Icons.comment,
                color: Color(0xFF58B76E),
              ),
              title: Text(
                'Publish Story',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushNamed(context, PublishStoryScreen.id);
              },
            ),
            ListTile(
              focusColor: Colors.green,
              leading: Icon(
                Icons.comment,
                color: Color(0xFF58B76E),
              ),
              title: Text(
                'Live Streaming',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushNamed(context, ManageStreamingPage.id);
                //Navigator.pushNamed(context, ManageStreamingPage.id);
              },
            ),
            ListTile(
              focusColor: Colors.green,
              leading: Icon(
                Icons.power_settings_new,
                color: Color(0xFF58B76E),
              ),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () async {
                try {
                  Response response = await post(logout_url, headers: {
                    "Authorization": "Token $token",
                  });
                  if (response.statusCode == 200) {
                    Navigator.pushNamed(context, LoginScreen.id);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('token', null);
                    prefs.setString('email', null);
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
            ListTile(
              focusColor: Colors.green,
              leading: Icon(
                Icons.power_settings_new,
                color: Color(0xFF58B76E),
              ),
              title: Text(
                'Google SignOn',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: ()  {
                Navigator.pushNamed(context, SignInDemo.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
