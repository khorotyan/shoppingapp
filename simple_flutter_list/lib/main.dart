import 'package:flutter/material.dart';

import './product_manager.dart';

void main() {
  runApp(SimpleApp());
}

// StatelessWidget cannot change internal data

// Lifecycle
// Stateless -> Constructor Function -> build()
// Statefull -> Constructor Function -> initState() -> build()
//   -> setState -> didUpdateWidget() -> build()

class SimpleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepOrangeAccent),
      home: Scaffold(
          appBar: AppBar(
            title: Text('SimpleList'),
          ),
          body: ProductManager()),
    );
  }
}
