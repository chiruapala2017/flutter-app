import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color buttonColor;
  final Function buttonAction;
  final String buttonName;

  const RoundedButton(
      {Key key,
        @required this.buttonColor,
        @required this.buttonAction,
        @required this.buttonName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: buttonColor,
      borderRadius: BorderRadius.circular(10.0),
      child: MaterialButton(
        onPressed: buttonAction,
        minWidth: 200.0,
        height: 42.0,
        child: Text(
          buttonName,
          style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}