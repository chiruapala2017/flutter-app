import 'package:flutter/material.dart';
import 'package:food_app/utils/constants.dart';

class InputField extends StatelessWidget {

  final String label_name;
  final Function onchange_function;
  final String hint_text;
  final TextInputType textInputType;
  final bool obscureText;

  // ignore: non_constant_identifier_names
  const InputField({Key key, this.label_name, this.onchange_function, this.hint_text, this.textInputType, this.obscureText}) : super(key: key);


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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0,),
          ),
        ),
        TextField(
          keyboardType: textInputType,
          textAlign: TextAlign.start,
          onChanged: onchange_function,
          obscureText: obscureText,
          decoration:
          kInputDecoration.copyWith(hintText: hint_text),
        ),
      ],
    );
  }
}