import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Details')),
        body: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Horizontal alignment
            children: <Widget>[
              Image.asset('images/img512_512.png'),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text('This is the product details page')),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      child:
                          Text('Back', style: TextStyle(color: Colors.white)),
                      onPressed: () => Navigator.pop(context)))
            ]));
  }
}
