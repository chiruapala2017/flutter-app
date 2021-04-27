import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:food_app/components/bottom_widget.dart';
import 'package:food_app/screens/account_screen.dart';
import 'package:food_app/components/appbar.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/utils/urls.dart';

class FitbitScreen extends StatefulWidget {
  static final id = "fitbit_screen";
  @override
  _FitbitScreenState createState() => _FitbitScreenState();
}

class _FitbitScreenState extends State<FitbitScreen> {
  bool showSpinner = false;
  String bodyWeight;
  String bmi;
  Object userData;

  @override
  void initState() {
    super.initState();
    getFitbitUserData();
  }

  void getFitbitUserData() async {
    String url = fitbit_user_data_url;
    try {
      setState(() {
        showSpinner = true;
      });
      http.Response response = await http.get(
          url, headers: {"Authorization": "Token $token"});
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData['fitbit_user_data']['body_weight']['weight']);
        setState(() {
          showSpinner = false;
          bodyWeight = responseData['fitbit_user_data']['body_weight']['weight'].toString();
          bmi = responseData['fitbit_user_data']['body_weight']['bmi'].toString();
          userData = responseData['fitbit_user_data'].toString();
        });
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: Appbar(),
        bottomNavigationBar: BottomWidget(activeIndex: 4),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, AccountScreen.id);
          },
          label: Text('Add Recipe'),
          icon: Icon(Icons.add),
          backgroundColor: Color(0xFF58B76E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Column(
              children: [
                Text('Body Weight - $bodyWeight'),
                Text('BMI - $bmi'),
                Text('$userData'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
