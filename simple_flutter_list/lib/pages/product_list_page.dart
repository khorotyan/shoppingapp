import 'package:flutter/material.dart';

import '../entities/product.dart';
import './product_manage_page.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> products;
  final Function updateProduct;
  final Function removeProduct;

  ProductListPage(this.products, this.updateProduct, this.removeProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  removeProduct(index);
                }
              },
              background: Container(
                padding: EdgeInsets.only(right: 16.0),
                  alignment: Alignment(1.0, 0.0),
                  child: Text('Delete',
                      style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  color: Colors.red),
              direction: DismissDirection.endToStart,
              key: Key(products[index].title),
              child: Column(children: <Widget>[
                ListTile(
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
              ]));
        },
        itemCount: products.length);
  }
}
