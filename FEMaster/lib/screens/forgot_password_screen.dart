import 'package:flutter/material.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart';

import 'contact_page_screen.dart';
import 'package:food_app/utils/urls.dart';
import 'package:food_app/components/alert_dialog_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static final id = "forgot_password_screen";
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool showSpinner = false;
  String email;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF58B76E),
            centerTitle: true,
            title: Text('Forgot Password' , style: TextStyle(color: Colors.white, fontSize: 25.0,),),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
            child: ListView(
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
                SizedBox(
                  height: 40.0,
                ),
                RoundedButton(
                  buttonColor: Color(0xFF58B76E),
                  buttonAction: () async {
                    // showSpinner make it true while calling service
                    try{
                      setState(() {
                        showSpinner = true;
                      });
                      Object body = {
                        'email': email,
                      };
                      Response response = await post(password_reset_url, body: body);
                      setState(() {
                        showSpinner = false;
                      });
                      if (response.statusCode == 200) {
                        AlertDialogWidget alertWidget = AlertDialogWidget(
                            messages: [Text("Link to reset password has been sent to your mail")], context: this.context);
                        await alertWidget.showMyDialog();
                      } else {
                        throw Exception();
                      }
                    } catch (e) {
                      print(e);
                      setState(() {
                        showSpinner = false;
                      });
                      AlertDialogWidget alertWidget = AlertDialogWidget(
                          messages: [Text("Something went wrong")], context: this.context);
                      await alertWidget.showMyDialog();
                    }

                    // set showSpinner to false after finishing service
                  },
                  buttonName: 'Forgot Password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
