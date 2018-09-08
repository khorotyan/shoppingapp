import 'package:flutter/material.dart';

import './product_card.dart';
import '../../entities/product.dart';

// The class contains a product
class Products extends StatelessWidget {
  // final - value is unchangable
  final List<Product> products;

  // this.products automatically does: this.products = products
  Products(this.products);

  // Show the products list or text stating that there are no products
  Widget _buildProductList() {
    Widget
        productCards = // = Container() // if we do not want to render anything
        Center(child: Text('Empty products list, please add some!'));

    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) => ProductCard(
            products[index], index), // Indicates, what builing an item means
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
