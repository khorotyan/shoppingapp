import 'package:flutter/material.dart';

import './entities/product.dart';

class ProductControl extends StatelessWidget {
  final Function addProduct;

  ProductControl(this.addProduct);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      onPressed: () {
        addProduct(Product('Simple product', 'Some detail about the product', 'images/img512_512.png'));
      },
      child: Text('Add product', style: TextStyle(color: Colors.white)),
    );
  }
}
