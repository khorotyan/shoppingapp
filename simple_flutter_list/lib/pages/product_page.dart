import 'package:flutter/material.dart';

import '../entities/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(product.title)),
        body: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Horizontal alignment
            children: <Widget>[
              Image.asset(product.imageUrl),
              Container(
                  padding: EdgeInsets.all(10.0), child: Text(product.details)),
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
