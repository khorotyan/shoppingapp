import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './scoped_models/main_model.dart';
import './pages/auth_page.dart';
import './pages/products_admin_page.dart';
import './pages/products_page.dart';
import './pages/product_page.dart';

void main() {
  runApp(SimpleApp());
}

// StatelessWidget cannot change internal data

// Lifecycle
// Stateless -> Constructor Function -> build()
// Statefull -> Constructor Function -> initState() -> build()
//   -> setState -> didUpdateWidget() -> build()

class SimpleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SimpleAppState();
  }
}

class _SimpleAppState extends State<SimpleApp> {
  final MainModel _mainModel = MainModel();

  @override
  void initState() {
    _mainModel.autoLogin();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _mainModel,
        child: MaterialApp(
            theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.deepOrange,
                accentColor: Colors.deepOrangeAccent,
                buttonColor: Colors.deepOrangeAccent),
            routes: {
              '/': (BuildContext context) => ScopedModelDescendant(builder:
                      (BuildContext context, Widget child, MainModel model) {
                    return model.authenticatedUser == null
                        ? AuthPage()
                        : ProductsPage(_mainModel);
                  }),
              '/products': (BuildContext context) => ProductsPage(_mainModel),
              '/admin': (BuildContext context) => ProductsAdminPage(_mainModel)
            },

            // Executed when we navigate to a named route
            onGenerateRoute: (RouteSettings settings) {
              // We want something like this: '/product/:id',
              //  splitting will get us: '', 'product', and ':id' - index of the product
              final List<String> pathElements = settings.name.split('/');

              if (pathElements[0] != '') {
                return null; // Do not load the page
              }

              if (pathElements[1] == 'product') {
                final String productId = pathElements[2];
                _mainModel.selectProduct(productId);

                return MaterialPageRoute<bool>(
                    builder: (BuildContext context) => ProductPage());
              }

              return null;
            },
            // Executed when 'onGenerateRoute' fails to generate a route
            onUnknownRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                  // When we want to go to a page that does not exist, then at least go to
                  //  this page - the home page
                  builder: (BuildContext context) => ProductsPage(_mainModel));
            }));
  }
}
