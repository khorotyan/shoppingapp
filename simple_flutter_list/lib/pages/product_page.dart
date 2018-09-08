import 'package:flutter/material.dart';
import 'dart:async';

import '../entities/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // WillPopScope used for getting back from this page
        // onWillPop executed when clicking the back button
        onWillPop: () {
          // pass false as a parameter, meaning that we do not want to delete the product
          Navigator.pop(context, false);
          // Allows the user to leave the page, pass true if leaving without the pop method
          return Future.value(false);
          // Some other functionality can be executed here too
        },
        child: Scaffold(
            appBar: AppBar(title: Text(product.title)),
            body: Container(
                padding: EdgeInsets.all(6.0),
                child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Horizontal alignment
                    children: <Widget>[
                      Image.asset(product.imageUrl),
                      SizedBox(height: 10.0),
                      Text(product.title,
                          style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Manchester, United Kingdom',
                              style: TextStyle(
                                  fontFamily: 'Oswald', color: Colors.grey)),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('|',
                                  style: TextStyle(color: Colors.grey))),
                          Text('\$${product.price}',
                              style: TextStyle(
                                  fontFamily: 'Oswald', color: Colors.grey))
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(product.description, textAlign: TextAlign.center))
                    ]))));
  }
}
