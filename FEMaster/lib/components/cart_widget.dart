import 'package:flutter/material.dart';
import 'package:food_app/screens/grocery_type_Screen.dart';
import 'package:food_app/utils/constants.dart';

class CartItemWidget extends StatefulWidget {
  final String itemImage;
  final String name;
  final int itemId;
  final String brand;
  final String pkgQty;
  final String pkgUnit;

  const CartItemWidget(
      {Key key,
        this.itemImage,
        this.name,
        this.brand,
        this.pkgQty,
        this.pkgUnit,
        this.itemId})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.pkgQty + ' ' + widget.name,
                  style: TextStyle(
                    color: Color(0xFF535252),
                  ),
                ),
                Text(
                  widget.brand,
                  style: TextStyle(
                    color: Color(0xFF535252),
                  ),
                ),
                Text(
                  widget.name + " " + widget.pkgUnit,
                  style: TextStyle(
                    color: Color(0xFF535252),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: GestureDetector(
              child: widget.itemImage.contains('https') ? Image.network(widget.itemImage) : Image.asset(widget.itemImage),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GroceryTypeScreen(itemId: widget.itemId, itemName: widget.name,)));
              },
            ),
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
                  "swap",
                  style: TextStyle(color: Color(0xFF58B76E)),
                ),
                onTap: () {},
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