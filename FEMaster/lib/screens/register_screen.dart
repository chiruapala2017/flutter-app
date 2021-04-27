import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/components/input_field.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:food_app/screens/diet_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/screens/chat_screen.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart';
import 'package:food_app/utils/urls.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  static final id = "register_screen";
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showSpinner = false;
  //final _auth = FirebaseAuth.instance;
  String name;
  String email;
  String password;
  String confirm_password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 160.0,
                        child: Image.asset('images/food_station_black.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: Text(
                            'Welcome to Food Station',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InputField(
                        hint_text: 'Enter your name',
                        label_name: 'Your Name',
                        obscureText: false,
                        textInputType: TextInputType.name,
                        onchange_function: (value) {
                          setState(() {
                            name = value.trim();
                          });
                        }, key:Key('fullname')
                      ),
                      InputField(
                        hint_text: 'Enter your email',
                        label_name: 'Email',
                        obscureText: false,
                        textInputType: TextInputType.emailAddress,
                        onchange_function: (value) {
                          setState(() {
                            email = value.trim();
                          });
                        }, key:Key('emailId')
                      ),
                      InputField(
                        hint_text: 'Enter your password',
                        label_name: 'Password',
                        obscureText: true,
                        onchange_function: (value) {
                          setState(() {
                            password = value.trim();
                          });
                        },key:Key('password')
                      ),
                      InputField(
                        hint_text: 'Enter your confirm password',
                        label_name: 'Confirm Password',
                        obscureText: true,
                        onchange_function: (value) {
                          setState(() {
                            confirm_password = value.trim();
                          });
                        },key:Key('confirmpassword')
                      ),
                    ],
                  ),
                ),
                RoundedButton(
                  buttonColor: Color(0xFF58B76E),
                  buttonAction: () async {
                    if (password.length >= 6 &&
                        confirm_password.length >= 6 &&
                        (password == confirm_password)) {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        Object body = {
                          'email': email,
                          'password1': password,
                          'password2': confirm_password,
                        };
                        // final user = await _auth.createUserWithEmailAndPassword(
                        //     email: email, password: password);
                        Response response = await post(register_url, body: body);
                        print(response.body);
                        print(response.statusCode);
                        if (response.statusCode == 201) {
                          appUserId = email;
                          final Map<String, dynamic> responseData = json.decode(response.body);
                          token = responseData["key"].toString();
                          Navigator.pushNamed(context, DietScreen.id);
                        }

                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                        List<Text> texts = List<Text>();
                        texts.add(Text('Please verify email'));
                        AlertDialogWidget alertWidget = AlertDialogWidget(
                            messages: texts, context: this.context);
                        await alertWidget.showMyDialog();
                      }
                    } else if (password != confirm_password) {
                      List<Text> texts = List<Text>();
                      texts.add(Text('Password not matching'));
                      AlertDialogWidget alertWidget = AlertDialogWidget(
                          messages: texts, context: this.context);
                      await alertWidget.showMyDialog();
                    } else {
                      List<Text> texts = List<Text>();
                      texts.add(
                          Text('Password should be greater than 5 characters'));
                      AlertDialogWidget alertWidget = AlertDialogWidget(
                          messages: texts, context: this.context);
                      await alertWidget.showMyDialog();
                    }
                  },
                  buttonName: 'Register',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
