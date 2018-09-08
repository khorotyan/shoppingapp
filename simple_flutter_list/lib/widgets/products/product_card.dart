import 'package:flutter/material.dart';

import '../../entities/product.dart';
import './price_tag.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  @override
    Widget build(BuildContext context) {
      return Card(
        child: Column(children: <Widget>[
      Image.asset(product.imageUrl),
      Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(product.title,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oswald')),
              SizedBox(width: 10.0),
              PriceTag(product.price.toString())
            ],
          )),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                color: Colors.grey, width: 1.0, style: BorderStyle.solid)),
        child: Text('Manchester, United Kingdom'),
      ),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              color: Theme.of(context).accentColor,
              onPressed: () => Navigator.pushNamed<bool>(
                  context, '/product/' + productIndex.toString())),
          IconButton(
              icon: Icon(Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () => {})
        ],
      )
    ]));
    }
}