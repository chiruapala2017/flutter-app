import 'package:flutter/material.dart';
import 'package:food_app/utils/constants.dart';

class IdenticalCartIemWidget extends StatefulWidget {
  final String itemImage;
  final String name;
  final int itemId;
  final String pkgUnit;

  const IdenticalCartIemWidget(
      {Key key, this.itemImage, this.name, this.itemId, this.pkgUnit})
      : super(key: key);

  @override
  _IdenticalCartIemWidgetState createState() => _IdenticalCartIemWidgetState();
}

class _IdenticalCartIemWidgetState extends State<IdenticalCartIemWidget> {
  bool isChoosed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      //color: Colors.white,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFC4C4C4),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name + '-' + widget.pkgUnit,
                  style: TextStyle(
                    color: Color(0xFF535252),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Image.asset(widget.itemImage),
            width: MediaQuery.of(context).size.width * .2,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .13,
            child: TextField(
              keyboardType: TextInputType.name,
              textAlign: TextAlign.justify,
              onChanged: (value) {
                setState(() {});
              },
              obscureText: false,
              decoration: kInputFieldDecoration.copyWith(hintText: '0'),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("\$3.90"),
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                child: Text(
                  "choose",
                  style: TextStyle(
                      color:
                          !isChoosed ? Color(0xFF58B76E) : Color(0xFFF16906)),
                ),
                onTap: () {
                  setState(() {
                    isChoosed = !isChoosed;
                  });
                },
              ),
              /*IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () {

                },
                color: Color(0xFF58B76E),
                alignment: Alignment.bottomCenter,
              ),*/
            ],
          )
        ],
      ),
    );
  }
}
