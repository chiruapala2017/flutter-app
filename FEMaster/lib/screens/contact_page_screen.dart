import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:food_app/screens/register_screen.dart';
import 'package:http/http.dart';
import 'package:food_app/utils/constants.dart';
import 'package:flutter_recaptcha_v2/flutter_recaptcha_v2.dart';
import 'package:webview_flutter/webview_flutter.dart';


class ContactPageScreen extends StatefulWidget {
  static final id = "contact_page_screen";
  @override
  _ContactPageScreenState createState() => _ContactPageScreenState();
}

class _ContactPageScreenState extends State<ContactPageScreen> {
  String verifyResult = '';

  RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();

  String name;
  String userEmail;
  String userPhone;
  String feedbackType;
  String description;
  String email;
  String phone;

  var _feedBackType = [
    "Select",
    "Comment",
    "Suggestion",
    "Bug Report",
    "Query"
  ];

  String _currentSelectedValue = 'Select';

  Future<void> get_contact() async {
    String url = 'http://3.131.96.223/contactpage/contact_details/';
    Response response = await get(url, headers: {
      "Authorization": "Token fa9e079a5b29b36841a2f0b334bd9fea96c0e47d",
    });
    var data = jsonDecode(response.body);
    print(data);
    setState(() {
      email = data['result']['results'][0]['email'];
      phone = data['result']['results'][0]['phone'];
    });
  }

  @override
  void initState() {
    super.initState();
    get_contact();
    recaptchaV2Controller.show();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Contact Us',
          ),
          backgroundColor: Color(0xFF58B76E),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            child: ListView(
              /*mainAxisAlignment: MainAxisAlignment.start,*/
              children: [
                SizedBox(height: 10.0),
                Text(
                  'Email - $email',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Phone - $phone',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 10.0),
                InputField(
                  hint_text: 'Enter your name',
                  label_name: 'Your Name',
                  obscureText: false,
                  textInputType: TextInputType.name,
                  onchange_function: (value) {
                    setState(() {
                      name = value.trim();
                    });
                  },
                ),
                InputField(
                  hint_text: 'Enter your email',
                  label_name: 'Your Email',
                  obscureText: false,
                  textInputType: TextInputType.emailAddress,
                  onchange_function: (value) {
                    setState(() {
                      userEmail = value.trim();
                    });
                  },
                ),
                InputField(
                  hint_text: 'Enter your phone',
                  label_name: 'Your Phone',
                  obscureText: false,
                  textInputType: TextInputType.phone,
                  onchange_function: (value) {
                    setState(() {
                      userPhone = value.trim();
                    });
                  },
                ),
                // InputField(
                //   hint_text: 'Enter your feedback type',
                //   label_name: 'Your feedback',
                //   obscureText: false,
                //   textInputType: TextInputType.text,
                //   onchange_function: (value) {
                //     setState(() {
                //       feedbackType = value.trim();
                //     });
                //   },
                // ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currentSelectedValue,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _currentSelectedValue = newValue;
                        // state.didChange(newValue);
                      });
                    },
                    items: _feedBackType.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                InputField(
                  hint_text: 'Enter your description',
                  label_name: 'Your Description',
                  obscureText: false,
                  textInputType: TextInputType.text,
                  onchange_function: (value) {
                    setState(() {
                      description = value.trim();
                    });
                  },
                ),
                Container(
                  height: 250.0,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              child: Text("SHOW ReCAPTCHA"),
                              onPressed: () {
                                recaptchaV2Controller.show();
                              },
                            ),
                            Text(verifyResult),
                          ],
                        ),
                      ),
                      RecaptchaV2(
                        apiKey: "6LeCwZYUAAAAAJo8IVvGX9dH65Rw89vxaxErCeou",
                        apiSecret: "6LeCwZYUAAAAAKGahIjwfOARevvRETgvwhPMKCs_",
                        controller: recaptchaV2Controller,
                        onVerifiedError: (err) {
                          print(err);
                        },
                        onVerifiedSuccessfully: (success) {
                          setState(() {
                            if (success) {
                              verifyResult =
                                  "You've been verified successfully.";
                            } else {
                              verifyResult = "Failed to verify.";
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                RoundedButton(
                  buttonColor: Color(0xFF58B76E),
                  buttonAction: () async {
                    Object body = {
                      'name': name,
                      'email': userEmail,
                      'phone': userPhone,
                      'feedback_type': feedbackType,
                      'description': description
                    };
                    String url =
                        'http://3.131.96.223/contactpage/feedback_details/';
                    try {
                      Response response = await post(url, body: body, headers: {
                        "Authorization":
                            "Token fa9e079a5b29b36841a2f0b334bd9fea96c0e47d",
                      });
                      print(response.body);
                    } catch (e) {
                      print(e);
                    }
                  },
                  buttonName: 'Submit',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label_name;
  final Function onchange_function;
  final String hint_text;
  final TextInputType textInputType;
  final bool obscureText;

  // ignore: non_constant_identifier_names
  const InputField(
      {Key key,
      this.label_name,
      this.onchange_function,
      this.hint_text,
      this.textInputType,
      this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            label_name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Color(0xFF535252)
            ),
          ),
        ),
        TextField(
          keyboardType: textInputType,
          textAlign: TextAlign.start,
          onChanged: onchange_function,
          obscureText: obscureText,
          decoration: kInputDecoration.copyWith(hintText: hint_text),
        ),
      ],
    );
  }
}
