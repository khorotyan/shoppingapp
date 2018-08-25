import 'package:flutter/material.dart';

import './products.dart';
import './product_control.dart';
import './entities/product.dart';

// The file manages the products
class ProductManager extends StatefulWidget {
  final Product defaultProduct;

  ProductManager({this.defaultProduct});

  @override
  State<StatefulWidget> createState() {
    return _ProductManagerState();
  }
}

// _ in front of class names makes the class private
// final keyword limits number of equal signs to one
class _ProductManagerState extends State<ProductManager> {
  final List<Product> _products = [];

  // 'initState' runs before 'build' runs
  @override
  void initState() {
    // super refers to the base class
    super.initState();
    if (widget.defaultProduct != null) {
      _products.add(widget.defaultProduct);
    }
  }

  void _addProduct(Product product) {
    setState(() {
      _products.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          margin: EdgeInsets.all(10.0), child: ProductControl(_addProduct)),
      Expanded(
          child: Products(_products)) // Expanded takes the remainder of space
    ]);
  }
}
