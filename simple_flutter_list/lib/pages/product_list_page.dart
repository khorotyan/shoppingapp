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
          return Container(
              margin: EdgeInsets.all(4.0),
              child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  leading: Image.asset(products[index].imageUrl,
                      height: 60.0, width: 60.0),
                  title: Text(products[index].title),
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
                  )));
        },
        itemCount: products.length);
  }
}
