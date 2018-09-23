import 'package:flutter/material.dart';

import './product_manage_page.dart';
import './product_list_page.dart';
import '../scoped_models/main_model.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;

  ProductsAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
        child: Column(children: <Widget>[
      AppBar(automaticallyImplyLeading: false, title: Text('Choose')),
      ListTile(
        leading: Icon(Icons.shop),
        title: Text('All Products'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/products');
        },
      )
    ]));
  }

  @override
  Widget build(BuildContext context) {
    // Add tabs to the page
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            drawer: _buildSideDrawer(context),
            appBar: AppBar(
              title: Text('Manage Products'),
              // Each widget is one tab
              bottom: TabBar(indicatorColor: Colors.white, tabs: <Widget>[
                Tab(icon: Icon(Icons.create), text: 'Create Product'),
                Tab(icon: Icon(Icons.list), text: 'My Products')
              ]),
            ),
            body: TabBarView(
                children: <Widget>[ProductManagePage(), ProductListPage(model)])));
  }
}
