import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/components/input_field.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:food_app/screens/diet_screen.dart';
import 'package:food_app/screens/forgot_password_screen.dart';
import 'package:food_app/screens/landing_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/screens/chat_screen.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:food_app/utils/urls.dart';

class LoginScreen extends StatefulWidget {
  static final id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  //final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('token') != null) {
        token = prefs.getString('token');
      }
    });
  }

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
                  height: MediaQuery.of(context).size.height * .50,
                  child: Center(
                    child: FractionallySizedBox(
                      //height: MediaQuery.of(context).size.height*.5,
                      widthFactor: 1,
                      heightFactor: 1,
                      child: Image.asset('images/food_station_black.png'),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InputField(
                        hint_text: 'Enter Email',
                        label_name: 'Email',
                        obscureText: false,
                        textInputType: TextInputType.emailAddress,
                        onchange_function: (value) {
                          setState(() {
                            email = value.trim();
                          });
                        },
                      ),
                      InputField(
                        hint_text: 'Enter your password',
                        label_name: 'Password',
                        obscureText: true,
                        onchange_function: (value) {
                          setState(() {
                            password = value.trim();
                          });
                        },
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ForgotPasswordScreen.id);
                          },
                          child: Text(
                            'Forgot Password ?',
                            style: TextStyle(
                                color: Color(0xFF283038), fontSize: 17.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                RoundedButton(
                  buttonColor: Color(0xFF58B76E),
                  buttonAction: () async {
                    if (password.length >= 6) {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        Object body = {
                          'email': email,
                          'password': password,
                        };
                        Response response = await post(login_url, body: body);
                        print(response.statusCode);
                        print(jsonDecode(response.body));
                        if (response.statusCode == 200) {
                          String data = response.body;
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('token', jsonDecode(data)['key']);
                          prefs.setString('email', email);
                          print(jsonDecode(data));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LandingScreen(
                                        emailId: email,
                                        token: jsonDecode(data)['key'],
                                      )));
                        } else {
                          print("exception occurs");
                          throw Exception();
                        }

                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print("exception message :"+e.toString());
                        setState(() {
                          showSpinner = false;
                        });
                        AlertDialogWidget alertWidget = AlertDialogWidget(
                          messages: [Text("Invalid credentials provided")], context: this.context);
                        await alertWidget.showMyDialog();
                      }
                    } else {
                      List<Text> texts = List<Text>();
                      texts.add(
                          Text('Password should be greater than 5 characters'));
                      AlertDialogWidget alertWidget = AlertDialogWidget(
                          messages: texts, context: this.context);
                      await alertWidget.showMyDialog();
                    }
                  },
                  buttonName: 'Login',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    /*return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 130.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value.trim();
                },
                decoration: kInputDecoration.copyWith(hintText: 'Enter your Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value.trim();
                },
                decoration: kInputDecoration.copyWith(hintText: 'Enter your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonColor: Colors.lightBlueAccent,
                buttonAction: () async{
                  if(password.length >= 6){
                    setState(() {
                      showSpinner = true;
                    });
                    try{
                      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                      if(user!=null){
                        Navigator.pushNamed(context, ChatScreen.id);
                      }

                      setState(() {
                        showSpinner = false;
                      });
                    }catch(e){
                      print(e);
                    }
                  }else{
                    List<Text> texts = List<Text>();
                    texts.add(Text('Password should be greater than 5 characters'));
                    AlertDialogWidget alertWidget = AlertDialogWidget(
                        messages: texts,
                        context: this.context
                    );
                    await  alertWidget.showMyDialog();
                  }

                },
                buttonName: 'Log In',
              ),

            ],
          ),
        ),
      ),
    );*/
  }
}
