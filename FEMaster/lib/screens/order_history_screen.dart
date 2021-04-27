import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/components/cart_widget.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/utils/urls.dart';


class OrderHistoryScreen extends StatefulWidget {
  static final id = "order_history_screen";

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {

  bool showSpinner = false;
  int _current = 0;
  CarouselController buttonCarouselController = CarouselController();
  List<CartItemWidget> myOrders = [];

  @override
  void initState() {
    super.initState();
    getPreviousOrders();
  }

  void getPreviousOrders() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final http.Response response = await http.get(my_order_url, headers: {
        "Authorization": "Token $token",
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          responseData['results'][0]['items'].forEach((i) {
            CartItemWidget order = CartItemWidget(
              itemImage: i['item']['image'],
              brand: 'brand',
              name: i['item']['name'],
              pkgQty: i['quantity'].toString(),
              pkgUnit: i['unit'],
              itemId: i['id'],
            );
            setState(() {
              myOrders.add(order);
            });
          });
          showSpinner = false;
        });
      }
      print(myOrders.length);
    } catch(e) {
      print(e);
      AlertDialogWidget alertWidget = AlertDialogWidget(
          messages: [Text("Something went wrong")], context: this.context);
      await alertWidget.showMyDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF58B76E),
            toolbarHeight: MediaQuery.of(context).size.height * .07,
            centerTitle: true,
            title: Text('My Orders'),
            actions: [
              Image.asset(
                'images/app_small_icon.png',
                color: Colors.white,
                scale: 1.5,
              )
            ],
          ),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .585,
                  //color: Colors.red.shade100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: myOrders,
                    ),
                  ),
                ),
                Image.asset('images/border_line.png'),
              ],
            ),
          ),
        ),
      );
  }
}

