import 'package:flutter/material.dart';

import '../product_manager.dart';
import '../entities/product.dart';

class ProductsPage extends StatelessWidget {
  final List<Product> products;
  final Function addProduct;
  final Function removeProduct;

  ProductsPage(this.products, this.addProduct, this.removeProduct);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer is on the left, endDrawer on the right
        drawer: Drawer(
            child: Column(children: <Widget>[
              // automaticallyImplyLeading disables the drawer icon
          AppBar(automaticallyImplyLeading: false, title: Text('Choose')),
          ListTile(
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          )
        ])),
        appBar: AppBar(title: Text('Home page')),
        body: ProductManager(products, addProduct, removeProduct));
  }
}
