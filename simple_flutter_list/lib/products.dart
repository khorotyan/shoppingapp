import 'package:flutter/material.dart';

import './pages/product_page.dart';
import './entities/product.dart';

// The class contains a product
class Products extends StatelessWidget {
  // final - value is unchangable
  final List<Product> products;
  final Function deleteProduct;

  // this.products automatically does: this.products = products
  Products(this.products, this.deleteProduct);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
        child: Column(children: <Widget>[
      Image.asset(products[index].imageUrl),
      Container(
          padding: EdgeInsets.all(10.0), child: Text(products[index].title)),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text('Details'),
            onPressed: () => Navigator
                    .push<bool>(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProductPage(products[index])))
                    .then((bool delete) {
                  // Future will return a bool (when getting back to this page)
                  if (delete) {
                    deleteProduct(index);
                  }
                }),
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
