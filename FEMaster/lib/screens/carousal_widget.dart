import 'package:flutter/material.dart';

class CarousalWidget extends StatefulWidget {
  final String headerMessage;
  final String imagePath;
  final String footerMessage;

  const CarousalWidget({Key key, this.headerMessage, this.imagePath, this.footerMessage}) : super(key: key);

  @override
  _CarousalWidgetState createState() => _CarousalWidgetState();
}

class _CarousalWidgetState extends State<CarousalWidget> {
  _CarousalWidgetState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              child: Text(
                widget.headerMessage,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Image.asset(
            widget.imagePath,
            height: 250.0,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              child: Text(
                widget.footerMessage,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

