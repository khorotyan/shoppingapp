import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String title = '';
  String description = '';
  double price = 0.0;

  @override
  Widget build(BuildContext context) {
    // Return the body of the page, because this is a tab
    //  no need for a Scaffold and appBar
    return Container(
        margin: EdgeInsets.all(12.0),
        child: ListView(children: <Widget>[
          TextField(
              decoration: InputDecoration(labelText: 'Product Title'),
              onChanged: (String value) {
                setState(() {
                  title = value;
                });
              }),
          TextField(
              decoration: InputDecoration(labelText: 'Product Description'),
              maxLines: 5,
              onChanged: (String value) {
                setState(() {
                  description = value;
                });
              }),
          TextField(
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                setState(() {
                  price = double.parse(value);
                });
              }),
          Container(
              padding: EdgeInsets.only(top: 10.0),
              child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Create Product',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {}))
        ]));
  }
}
