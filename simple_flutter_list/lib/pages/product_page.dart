import 'package:flutter/material.dart';
import 'dart:async';

import '../entities/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  _onDeleteButtonPress(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('This action cannot be undone!'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                    child: Text('Delete'),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      // Go back from the page and pass true as a parameter
                      Navigator.pop(context, true);
                    })
              ]);
        });
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
        },
        child: Scaffold(
            appBar: AppBar(title: Text(product.title)),
            body: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Horizontal alignment
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: Image.asset(product.imageUrl)),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(product.details)),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Text('Delete',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () => _onDeleteButtonPress(context)))
                ])));
  }
}
