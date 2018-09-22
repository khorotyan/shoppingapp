import 'package:flutter/material.dart';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scoped_models/main_model.dart';
import '../widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);

  Widget _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Manchester, United Kingdom',
            style: TextStyle(fontFamily: 'Oswald', color: Colors.grey)),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('|', style: TextStyle(color: Colors.grey))),
        Text('\$$price',
            style: TextStyle(fontFamily: 'Oswald', color: Colors.grey))
      ],
    );
  }

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
    }, child: ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
      final Product product = model.allProducts[productIndex];

      return Scaffold(
          appBar: AppBar(title: Text(product.title)),
          body: Container(
              padding: EdgeInsets.all(6.0),
              child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Horizontal alignment
                  children: <Widget>[
                    Image.network(product.imageUrl),
                    SizedBox(height: 10.0),
                    TitleDefault(product.title),
                    SizedBox(height: 10.0),
                    _buildAddressPriceRow(product.price),
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(product.description,
                            textAlign: TextAlign.center))
                  ])));
    }));
  }
}
