import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';
import './product_manage_page.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
    State<StatefulWidget> createState() {
      return _ProductListPageState();
    }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(index);
        Navigator
            .of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ProductManagePage();
        })).then((_) {
          model.selectProduct(null);
        });
      },
    );
  }

  Widget _buildListItem(BuildContext context, int index, MainModel model) {
    return ListTile(
        leading: CircleAvatar(
            backgroundImage: NetworkImage(model.allProducts[index].imageUrl),
            radius: 22.0),
        title: Text(model.allProducts[index].title),
        subtitle: Text('\$${model.allProducts[index].price}'),
        trailing: _buildEditButton(context, index, model));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
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
                key: Key(model.allProducts[index].title),
                child: Column(children: <Widget>[
                  _buildListItem(context, index, model),
                  Divider()
                ]));
          },
          itemCount: model.allProducts.length);
    });
  }
}
