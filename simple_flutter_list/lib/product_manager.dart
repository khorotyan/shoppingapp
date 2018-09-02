import 'package:flutter/material.dart';

import './products.dart';
import './entities/product.dart';

// The file manages the products
class ProductManager extends StatelessWidget {
  final List<Product> products;

  ProductManager(this.products);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: Products(products))
    ]);
  }
}
