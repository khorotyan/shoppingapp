import 'package:flutter/material.dart';

import './pages/product_page.dart';
import './entities/product.dart';

// The class contains a product
class Products extends StatelessWidget {
  // final - value is unchangable
  final List<Product> products;

  // this.products automatically does: this.products = products
  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
        child: Column(children: <Widget>[
      Image.asset(products[index].imageUrl),
      Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(products[index].title,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oswald')),
              SizedBox(width: 10.0),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(6.0)),
                  child: Text('\$${products[index].price.toString()}',
                      style: TextStyle(color: Colors.white)))
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
          FlatButton(
              child: Text('Details'),
              onPressed: () => Navigator.pushNamed<bool>(
                  context, '/product/' + index.toString()))
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
