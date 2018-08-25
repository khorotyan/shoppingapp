import 'package:flutter/material.dart';

import './products_page.dart';
import './product_create_page.dart';
import './product_list_page.dart';

class ProductsAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Add tabs to the page
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            drawer: Drawer(
                child: Column(children: <Widget>[
              AppBar(automaticallyImplyLeading: false, title: Text('Choose')),
              ListTile(
                title: Text('All Products'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ProductsPage()));
                },
              )
            ])),
            appBar: AppBar(
              title: Text('Manage Products'),
              // Each widget is one tab
              bottom: TabBar(indicatorColor: Colors.white, tabs: <Widget>[
                Tab(icon: Icon(Icons.create), text: 'Create Product'),
                Tab(icon: Icon(Icons.list), text: 'My Products')
              ]),
            ),
            body: TabBarView(
                children: <Widget>[ProductCreatePage(), ProductListPage()])));
  }
}
