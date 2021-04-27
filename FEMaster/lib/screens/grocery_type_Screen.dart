import 'package:flutter/material.dart';
import 'package:food_app/components/cart_widget.dart';
import 'package:food_app/components/identical_cart_item_widget.dart';

class GroceryTypeScreen extends StatefulWidget {
  static final id = "grocery_type_screen";
  final int itemId;
  final String itemName;
  const GroceryTypeScreen({Key key, this.itemId, this.itemName}) : super(key: key);
  @override
  _GroceryTypeScreenState createState() => _GroceryTypeScreenState();
}

class _GroceryTypeScreenState extends State<GroceryTypeScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF58B76E),
          toolbarHeight: MediaQuery.of(context).size.height * .07,
          centerTitle: true,
          title: Text('choose : '+widget.itemName),
          actions: [
            Image.asset(
              'images/app_small_icon.png',
              color: Colors.white,
              scale: 1.5,
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height * .93,
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          color: Colors.white,
          child: ListView(
            children: [
              IdenticalCartIemWidget(
                itemImage: 'images/banana_type1.png',
                name: "Red Banana",
                pkgUnit: "2lb",
                itemId: 1,
              ),
              IdenticalCartIemWidget(
                itemImage: 'images/banana_type2.png',
                name: "Organic banana",
                pkgUnit: "2lb",
                itemId: 1,
              ),
              IdenticalCartIemWidget(
                itemImage: 'images/itemImage.png',
                name: "Banana",
                pkgUnit: "each",
                itemId: 1,
              ),
              IdenticalCartIemWidget(
                itemImage: 'images/banana_type1.png',
                name: "Red Banana",
                pkgUnit: "2lb",
                itemId: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
