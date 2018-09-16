import 'package:flutter/material.dart';

import '../entities/product.dart';
import './product_manage_page.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> products;
  final Function updateProduct;

  ProductListPage(this.products, this.updateProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Column(children: <Widget>[
            ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 14.0),
                leading: CircleAvatar(
                    backgroundImage: AssetImage(products[index].imageUrl),
                    radius: 22.0),
                title: Text(products[index].title),
                subtitle: Text('\$${products[index].price}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ProductManagePage(
                          product: products[index],
                          updateProduct: updateProduct,
                          productIndex: index);
                    }));
                  },
                )),
            Divider()
          ]);
        },
        itemCount: products.length);
  }
}
