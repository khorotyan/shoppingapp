import 'package:flutter/material.dart';

class ProductFAB extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFAB> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(child: Icon(Icons.more_vert), onPressed: () {});
  }
}
