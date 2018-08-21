import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Details')),
        body: Column(children: <Widget>[
          Image.asset('images/img512_512.png'),
          Text('This is the product details page'),
          RaisedButton(
              child: Text('Back'), onPressed: () => Navigator.pop(context))
        ]));
  }
}
