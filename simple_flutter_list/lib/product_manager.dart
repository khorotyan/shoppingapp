import 'package:flutter/material.dart';

import './products.dart';
import './product_control.dart';
import './entities/product.dart';

// The file manages the products
class ProductManager extends StatelessWidget {
  final List<Product> products;
  final Function addProduct;
  final Function removeProduct;

  ProductManager(this.products, this.addProduct, this.removeProduct);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: Products(products, removeProduct)),
      Container(
          margin: EdgeInsets.all(10.0),
          child: ProductControl(
              addProduct)) // Expanded takes the remainder of space
    ]);
  }
}
