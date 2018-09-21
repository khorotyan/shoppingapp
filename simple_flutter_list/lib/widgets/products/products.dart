import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../../models/product.dart';
import '../../scoped_models/products_model.dart';
import './product_card.dart';

// The class contains a product
class Products extends StatelessWidget {
  // Show the products list or text stating that there are no products
  Widget _buildProductList(List<Product> products) {
    Widget productCards =
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
    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return _buildProductList(model.displayedProducts);
    });
  }
}
