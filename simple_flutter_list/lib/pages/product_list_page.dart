import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/products_model.dart';
import './product_manage_page.dart';

class ProductListPage extends StatelessWidget {
  Widget _buildEditButton(
      BuildContext context, int index, ProductsModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(index);
        Navigator
            .of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ProductManagePage();
        }));
      },
    );
  }

  Widget _buildListItem(BuildContext context, int index, ProductsModel model) {
    return ListTile(
        leading: CircleAvatar(
            backgroundImage: AssetImage(model.products[index].imageUrl),
            radius: 22.0),
        title: Text(model.products[index].title),
        subtitle: Text('\$${model.products[index].price}'),
        trailing: _buildEditButton(context, index, model));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart) {
                    model.selectProduct(index);
                    model.removeProduct();
                  }
                },
                background: Container(
                    padding: EdgeInsets.only(right: 16.0),
                    alignment: Alignment(1.0, 0.0),
                    child: Text('Delete',
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                    color: Colors.red),
                direction: DismissDirection.endToStart,
                key: Key(model.products[index].title),
                child: Column(children: <Widget>[
                  _buildListItem(context, index, model),
                  Divider()
                ]));
          },
          itemCount: model.products.length);
    });
  }
}
