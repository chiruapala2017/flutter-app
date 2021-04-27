import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_app/components/cart_widget.dart';
import 'package:food_app/screens/grocery_type_Screen.dart';
import 'package:food_app/screens/stripe_payment_screen.dart';
import 'package:food_app/utils/constants.dart';

class OrderGroceryPage extends StatefulWidget {
  static final id = "order_grocery_screen";

  @override
  _OrderGroceryPageState createState() => _OrderGroceryPageState();
}

class _OrderGroceryPageState extends State<OrderGroceryPage>
    with SingleTickerProviderStateMixin {
  bool isAvailable = false;
  bool is_clicked = false;
  int _current = 0;
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF58B76E),
        toolbarHeight: MediaQuery.of(context).size.height * .07,
        centerTitle: true,
        title: Text('Order Groceries'),
        actions: [
          Image.asset(
            'images/app_small_icon.png',
            color: Colors.white,
            scale: 1.5,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
        height: MediaQuery.of(context).size.height * .93,
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .1,
              //padding: EdgeInsets.symmetric(horizontal: 10.0),
              //color: Colors.amber.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .35,
                    child: TextField(
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.justify,
                      onChanged: (value) {
                        setState(() {});
                      },
                      obscureText: false,
                      decoration:
                          kInputFieldDecoration.copyWith(hintText: 'pin code'),
                    ),
                  ),
                  Material(
                    elevation: 2.0,
                    color: Colors.white,
                    /*borderRadius: BorderRadius.circular(10.0),*/
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Color(0xFF58B76E))),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          isAvailable = !isAvailable;
                        });
                      },
                      minWidth: MediaQuery.of(context).size.width * .35,
                      height: 42.0,
                      child: Text(
                        'update',
                        style: TextStyle(
                            color: Color(0xFF535252),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset('images/border_line.png'),
            !isAvailable
                ? Container(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            'Try another location',
                            style: TextStyle(
                              color: Color(0xFF535252),
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        Image.asset('images/botton_line_green.png'),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          width: MediaQuery.of(context).size.width * .75,
                          child: Text(
                            'We can’t find these products at your local retailers. Try updating your postal code to search other area.',
                            style: TextStyle(
                                color: Color(0xFF535252),
                                fontSize: 17.0,
                                wordSpacing: 2.0),
                          ),
                        ),
                        Image.asset('images/border_line.png'),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Powered by food station ',
                                    style: TextStyle(
                                        color: Color(0xFF535252),
                                        fontSize: 17.0,
                                        wordSpacing: 2.0),
                                  ),
                                  Image.asset(
                                    'images/app_small_icon.png',
                                    color: Color(0xFF58B76E),
                                    scale: 1.5,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Privacy Policy    ',
                                    style: TextStyle(
                                      color: Color(0xFF535252),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Text(
                                    'Terms Of Use',
                                    style: TextStyle(
                                      color: Color(0xFF535252),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    //padding: EdgeInsets.only(top: 15.0),
                    //color: Colors.blue.shade100,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .1,
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: CarouselSlider(
                            items: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.green,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        /*buttonCarouselController.previousPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);*/
                                      },
                                    ),
                                    Container(
                                      child:
                                          Image.asset('images/woolworths.png'),
                                      width: MediaQuery.of(context).size.width *
                                          .35,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.green,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        buttonCarouselController.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.green,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        buttonCarouselController.previousPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                      },
                                    ),
                                    Container(
                                      child: Image.asset(
                                        'images/IGA_logo.png',
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          .35,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.green,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        buttonCarouselController.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.green,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        buttonCarouselController.previousPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                      },
                                    ),
                                    Container(
                                      child:
                                          Image.asset('images/woolworths.png'),
                                      width: MediaQuery.of(context).size.width *
                                          .35,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.green,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        buttonCarouselController.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            carouselController: buttonCarouselController,
                            options: CarouselOptions(
                              height: 50.0,
                              initialPage: _current,
                              autoPlay: false,
                              enlargeCenterPage: false,
                              viewportFraction: 1.5,
                              enableInfiniteScroll: false,
                              aspectRatio: 2.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                  print(_current);
                                });
                              },
                            ),
                          ),
                        ),
                        Image.asset('images/border_line.png'),
                        Container(
                          height: MediaQuery.of(context).size.height * .585,
                          //color: Colors.red.shade100,
                          child: ListView(
                            children: [
                              CartItemWidget(
                                itemImage: 'images/bread.png',
                                brand: "Hegla Holemeal",
                                name: "Bread",
                                pkgQty: "2",
                                pkgUnit: "100gm",
                                itemId: 1,
                              ),
                              CartItemWidget(
                                itemImage: 'images/itemImage.png',
                                brand: "Bigbasket",
                                name: "Banana",
                                pkgQty: "12",
                                pkgUnit: "pcs",
                                itemId: 2,
                              ),
                              CartItemWidget(
                                itemImage: 'images/bread.png',
                                brand: "Hegla Holemeal",
                                name: "Bread",
                                pkgQty: "2",
                                pkgUnit: "100gm",
                                itemId: 3,
                              ),
                              CartItemWidget(
                                itemImage: 'images/itemImage.png',
                                brand: "Bigbasket",
                                name: "Banana",
                                pkgQty: "12",
                                pkgUnit: "pcs",
                                itemId: 4,
                              ),
                              CartItemWidget(
                                itemImage: 'images/bread.png',
                                brand: "Hegla Holemeal",
                                name: "Bread",
                                pkgQty: "2",
                                pkgUnit: "100gm",
                                itemId: 5,
                              ),
                              CartItemWidget(
                                itemImage: 'images/itemImage.png',
                                brand: "Bigbasket",
                                name: "Banana",
                                pkgQty: "12",
                                pkgUnit: "pcs",
                                itemId: 6,
                              ),
                              CartItemWidget(
                                itemImage: 'images/bread.png',
                                brand: "Hegla Holemeal",
                                name: "Bread",
                                pkgQty: "2",
                                pkgUnit: "100gm",
                                itemId: 7,
                              ),
                            ],
                          ),
                        ),
                        Image.asset('images/border_line.png'),
                        Container(
                          height: MediaQuery.of(context).size.height * .095,
                          //padding: EdgeInsets.symmetric(horizontal: 10.0),
                          //color: Color(0xFFEEEEEE),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total: \$4.50"),
                              Material(
                                elevation: 0.0,
                                color: Color(0xFF58B76E),
                                /*borderRadius: BorderRadius.circular(10.0),*/
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Color(0xFF58B76E))),
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pushNamed(context, StripePaymentScreen.id);
                                    });
                                  },
                                  minWidth:
                                      MediaQuery.of(context).size.width * .2,
                                  height: 35.0,
                                  child: Text(
                                    'Add to cart',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    ));
  }
}