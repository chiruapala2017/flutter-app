import 'package:flutter/material.dart';

class AlertDialogWidget {
  final List<Text> messages;
  final Function action;
  final BuildContext context;

  const AlertDialogWidget(
      {Key key, @required this.messages, this.action, @required this.context});

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //backgroundColor: Color(0xFF58B76E),
          title: Container(
            child: Text('Alert'),
          ),
          content: SingleChildScrollView(
            child: Container(
              child: ListBody(
                children: messages,
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                color: Color(0xFF58B76E),
                child: Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            action != null
                ? FlatButton(
                    child: Text('Proceed'),
                    onPressed: action,
                  )
                : null,
          ],
        );
      },
    );
  }
}
