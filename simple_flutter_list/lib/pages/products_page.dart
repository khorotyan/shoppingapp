import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/products.dart';
import '../scoped_models/main_model.dart';
import '../widgets/custom/http_error_dialog.dart';

class ProductsPage extends StatefulWidget {
  final MainModel mainModel;

  ProductsPage(this.mainModel);

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  initState() {
    initializeState();

    super.initState();
  }

  void initializeState() async {
    bool isSuccessful = await widget.mainModel.fetchProducts();

    if (!isSuccessful) {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              HttpErrorDialog('Something went wrong', 'Please try again!'));
    }
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
        child: Column(children: <Widget>[
      // automaticallyImplyLeading disables the drawer icon
      AppBar(automaticallyImplyLeading: false, title: Text('Choose')),
      ListTile(
        leading: Icon(Icons.edit),
        title: Text('Manage Products'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/admin');
        },
      )
    ]));
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No products'));

      if (model.displayedProducts.length > 0 && !model.isLoading) {
        content = Products();
      } else if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
          child: content,
          onRefresh: () async {
            bool isSuccessful =
                await model.fetchProducts(showSpinner: false);

            if (!isSuccessful) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => HttpErrorDialog(
                      'Something went wrong', 'Please try again!'));
            }
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer is on the left, endDrawer on the right
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Home page'),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
              IconData icon =
                  model.showFavorites ? Icons.favorite : Icons.favorite_border;

              return IconButton(
                icon: Icon(icon),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            })
          ],
        ),
        body: _buildProductsList());
  }
}
