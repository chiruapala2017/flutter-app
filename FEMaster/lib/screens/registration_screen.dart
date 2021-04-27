import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/screens/chat_screen.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static final id = "registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  //final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  setState(() {
                    email = value.trim();
                  });
                },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter your email'),
                key:Key('email')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value.trim();
                  });
                },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter your password'),
                  key:Key('password')
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonColor: Colors.blueAccent,
                buttonAction: () async {
                  if (password.length >= 6) {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = "";/*await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);*/
                      if (user != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    List<Text> texts = List<Text>();
                    texts.add(Text('Password should be greater than 5 characters'));
                    AlertDialogWidget alertWidget = AlertDialogWidget(
                      messages: texts,
                      context: this.context
                    );
                    await alertWidget.showMyDialog();
                  }
                },
                buttonName: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
