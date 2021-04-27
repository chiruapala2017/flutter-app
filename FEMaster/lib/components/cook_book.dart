import 'package:flutter/material.dart';

class CookBook extends StatelessWidget {
  final String imagePath;
  final String footerText;

  const CookBook({Key key, this.imagePath, this.footerText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        //padding: const EdgeInsets.symmetric(vertical: 20.0),
        width: MediaQuery.of(context).size.width*.44,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFC4C4C4))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                imagePath,
              ),
            ),
            Container(
              height: 35.0,
              child: Text(footerText, style: TextStyle(fontSize: 12.0)),
            )
          ],
        ),
      ),
    );
  }
}