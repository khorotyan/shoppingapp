import 'package:flutter/material.dart';

// The class contains a product
class Products extends StatelessWidget {
  // final - value is unchangable
  final List<String> products;

  // this.products automatically does: this.products = products
  Products(this.products);

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: products
            .map((element) => Card(
                    child: Column(children: <Widget>[
                  Image.asset('images/img512_512.png'),
                  Text(element)
                ])))
            .toList());
  }
}
