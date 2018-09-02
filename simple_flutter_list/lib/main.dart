import 'package:flutter/material.dart';

import './pages/auth_page.dart';
import './pages/products_admin_page.dart';
import './pages/products_page.dart';
import './pages/product_page.dart';
import './entities/product.dart';

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
  List<Product> _products = new List<Product>();

  void _addProduct(Product product) {
    setState(() {
      _products.add(product);
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepOrangeAccent),
        // home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/products': (BuildContext context) => ProductsPage(_products),
          '/admin': (BuildContext context) =>
              ProductsAdminPage(_addProduct, _removeProduct)
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
            final int index = int.parse(pathElements[2]);

            return MaterialPageRoute<bool>(
                builder: (BuildContext context) =>
                    ProductPage(_products[index]));
          }

          return null;
        },
        // Executed when 'onGenerateRoute' fails to generate a route
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              // When we want to go to a page that does not exist, then at least go to
              //  this page - the home page
              builder: (BuildContext context) =>
                  ProductsPage(_products));
        });
  }
}
