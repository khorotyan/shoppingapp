import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';

import './scoped_models/main_model.dart';
import './pages/auth_page.dart';
import './pages/products_admin_page.dart';
import './pages/products_page.dart';
import './pages/product_page.dart';
import './helpers/custom_route.dart';
import './shared/global_config.dart' as config;

void main() {
  MapView.setApiKey(config.firebaseApiKey);
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
  final _platformChannel = MethodChannel('flutter-shopping.com/battery');
  bool _isAuthenticated = false;

  Future _getBatteryLevel() async {
    String batteryLevel;

    try {
      int result = await _platformChannel.invokeMethod('getBatteryLvel');
      batteryLevel = 'Battery level: $result%';
    } catch (error) {
      batteryLevel = 'Problem retrieving battery level';
      print(error);
    }

    print(batteryLevel);
  }

  @override
  void initState() {
    _getBatteryLevel();
    _mainModel.autoLogin();
    _mainModel.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _mainModel,
        child: MaterialApp(
            title: 'Easy Shopping',
            theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.deepOrange,
                accentColor: Colors.deepOrangeAccent,
                buttonColor: Colors.deepOrangeAccent),
            routes: {
              '/': (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductsPage(_mainModel),
              '/admin': (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductsAdminPage(_mainModel)
            },

            // Executed when we navigate to a named route
            onGenerateRoute: (RouteSettings settings) {
              if (!_isAuthenticated) {
                return MaterialPageRoute<bool>(
                    builder: (BuildContext context) => AuthPage());
              }

              // We want something like this: '/product/:id',
              //  splitting will get us: '', 'product', and ':id' - index of the product
              final List<String> pathElements = settings.name.split('/');

              if (pathElements[0] != '') {
                return null; // Do not load the page
              }

              if (pathElements[1] == 'product') {
                final String productId = pathElements[2];
                _mainModel.selectProduct(productId);

                return CustomRoute<bool>(
                    builder: (BuildContext context) => !_isAuthenticated
                        ? AuthPage()
                        : ProductPage(_mainModel));
              }

              return null;
            },
            // Executed when 'onGenerateRoute' fails to generate a route
            onUnknownRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                  // When we want to go to a page that does not exist, then at least go to
                  //  this page - the home page
                  builder: (BuildContext context) => !_isAuthenticated
                      ? AuthPage()
                      : ProductsPage(_mainModel));
            }));
  }
}
