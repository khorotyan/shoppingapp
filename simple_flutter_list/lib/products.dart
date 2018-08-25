import 'package:flutter/material.dart';

import './pages/product.dart';

// The class contains a product
class Products extends StatelessWidget {
  // final - value is unchangable
  final List<String> products;

  // this.products automatically does: this.products = products
  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
        child: Column(children: <Widget>[
      Image.asset('images/img512_512.png'),
      Text(products[index]),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text('Details'),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProductPage())),
          )
        ],
      )
    ]));
  }

  // Show the products list or text stating that there are no products
  Widget _buildProductList() {
    Widget
        productCards = // = Container() // if we do not want to render anything
        Center(child: Text('Empty products list, please add some!'));

    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: _buildProductItem, // Indicates, what builing an item means
        itemCount: products.length, // How many items will be built
      );
    }

    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList();
  }
}
