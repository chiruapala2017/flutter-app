import 'dart:convert';
import 'package:food_app/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:io';

class StripePaymentScreen extends StatefulWidget {
  static final id = "stripe_payment_screen";

  @override
  _StripePaymentScreenState createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;
  final String _currentSecret = null; //set this yourself, e.g using curl
  PaymentIntentResult _paymentIntent;
  Source _source;

  ScrollController _controller = ScrollController();

  final CreditCard testCard = CreditCard(
    number: '4242424242424242',
    expMonth: 05,
    expYear: 23,
    cvc: "980"
  );

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  initState() {
    super.initState();

    StripePayment.setOptions(
        StripeOptions(publishableKey: "pk_test_51IIpzfG0USkrwpj2XU4kmZr7nD9mHkH56fJdHoozFjuRc0REJfaf9De0TSADVnJ6XetZYLgBeYWEpuYHXiPUpJRj00BeOSmklQ",
            merchantId: "Test",
            androidPayMode: 'test'));
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _source = null;
                  _paymentIntent = null;
                  _paymentMethod = null;
                  _paymentToken = null;
                });
              },
            )
          ],
        ),
        body: ListView(
          controller: _controller,
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            RaisedButton(
              child: Text("Create Source"),
              onPressed: () {
                StripePayment.createSourceWithParams(SourceParams(
                  type: 'ideal',
                  amount: 1099,
                  currency: 'eur',
                  returnURL: 'example://stripe-redirect',
                )).then((source) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${source.sourceId}')));
                  setState(() {
                    _source = source;
                  });
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Create Token with Card Form"),
              onPressed: () {
                StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
                  setState(() {
                    _paymentMethod = paymentMethod;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Create Token with Card"),
              onPressed: () async {
                StripePayment.createTokenWithCard(
                  testCard,
                ).then((token) {
                  // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
                  setState(() {
                    _paymentToken = token;
                  });
                }).catchError(setError);
                String url = 'http://3.131.96.223/api/checkout/';
                print('token - ${_paymentToken.tokenId}');
                Object body = {
                  'token': _paymentToken.tokenId,
                };
                http.Response response = await http.post(url, body: body, headers: {'Authorization': 'Token $token'});
                if (response.statusCode == 200) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Order placed successfully!!!')));
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Something went wrong')));
                }
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Create Payment Method with Card"),
              onPressed: () {
                StripePayment.createPaymentMethod(
                  PaymentMethodRequest(
                    card: testCard,
                  ),
                ).then((paymentMethod) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
                  setState(() {
                    _paymentMethod = paymentMethod;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Create Payment Method with existing token"),
              onPressed: _paymentToken == null
                  ? null
                  : () {
                StripePayment.createPaymentMethod(
                  PaymentMethodRequest(
                    card: CreditCard(
                      token: _paymentToken.tokenId,
                    ),
                  ),
                ).then((paymentMethod) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
                  setState(() {
                    _paymentMethod = paymentMethod;
                  });
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Confirm Payment Intent"),
              onPressed: _paymentMethod == null || _currentSecret == null
                  ? null
                  : () {
                StripePayment.confirmPaymentIntent(
                  PaymentIntent(
                    clientSecret: _currentSecret,
                    paymentMethodId: _paymentMethod.id,
                  ),
                ).then((paymentIntent) {
                  _scaffoldKey.currentState
                      .showSnackBar(SnackBar(content: Text('Received ${paymentIntent.paymentIntentId}')));
                  setState(() {
                    _paymentIntent = paymentIntent;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Authenticate Payment Intent"),
              onPressed: _currentSecret == null
                  ? null
                  : () {
                StripePayment.authenticatePaymentIntent(clientSecret: _currentSecret).then((paymentIntent) {
                  _scaffoldKey.currentState
                      .showSnackBar(SnackBar(content: Text('Received ${paymentIntent.paymentIntentId}')));
                  setState(() {
                    _paymentIntent = paymentIntent;
                  });
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Native payment"),
              onPressed: () {
                if (Platform.isIOS) {
                  _controller.jumpTo(450);
                }
                StripePayment.paymentRequestWithNativePay(
                  androidPayOptions: AndroidPayPaymentRequest(
                    totalPrice: "1.20",
                    currencyCode: "EUR",
                  ),
                  applePayOptions: ApplePayPaymentOptions(
                    countryCode: 'DE',
                    currencyCode: 'EUR',
                    items: [
                      ApplePayItem(
                        label: 'Test',
                        amount: '13',
                      )
                    ],
                  ),
                ).then((token) {
                  setState(() {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
                    _paymentToken = token;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Complete Native Payment"),
              onPressed: () {
                StripePayment.completeNativePayRequest().then((_) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Completed successfully')));
                }).catchError(setError);
              },
            ),
            Divider(),
            Text('Current source:'),
            Text(
              JsonEncoder.withIndent('  ').convert(_source?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current token:'),
            Text(
              JsonEncoder.withIndent('  ').convert(_paymentToken?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current payment method:'),
            Text(
              JsonEncoder.withIndent('  ').convert(_paymentMethod?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current payment intent:'),
            Text(
              JsonEncoder.withIndent('  ').convert(_paymentIntent?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current error: $_error'),
          ],
        ),
      ),
    );
  }
}
