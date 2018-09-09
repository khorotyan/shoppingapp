import 'package:flutter/material.dart';

import '../entities/product.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String _title = '';
  String _description = '';
  double _price = 0.0;

  Widget _buildTitleTextField() {
    return TextField(
        decoration: InputDecoration(labelText: 'Product Title'),
        onChanged: (String value) {
          setState(() {
            _title = value;
          });
        });
  }

  Widget _buildDescriptionTextField() {
    return TextField(
        decoration: InputDecoration(labelText: 'Product Description'),
        maxLines: 5,
        onChanged: (String value) {
          setState(() {
            _description = value;
          });
        });
  }

  Widget _buildPriceTextField() {
    return TextField(
        decoration: InputDecoration(labelText: 'Product Price'),
        keyboardType: TextInputType.number,
        onChanged: (String value) {
          setState(() {
            _price = double.parse(value);
          });
        });
  }

  Widget _buildCreateProductButton() {
    return RaisedButton(
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
        child: Text('Create Product'),
        onPressed: _onCreateProductClick);
  }

  void _onCreateProductClick() {
    final Product product =
        new Product(_title, _description, 'images/img512_512.png', _price);
    widget.addProduct(product);

    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    // Return the body of the page, because this is a tab
    //  no need for a Scaffold and appBar
    return Container(
        margin: EdgeInsets.all(12.0),
        child: ListView(children: <Widget>[
          _buildTitleTextField(),
          _buildDescriptionTextField(),
          _buildPriceTextField(),
          SizedBox(height: 10.0),
          _buildCreateProductButton()
        ]));
  }
}
