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
  TextEditingController priceTextFieldController = new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title field is required';
        } else if (value.length < 3) {
          return 'Title must be 3 or more characters long';
        }
      },
      onSaved: (String value) {
        setState(() {
          _title = value;
        });
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
        decoration: InputDecoration(labelText: 'Product Description'),
        maxLines: 5,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Description field is required';
          } else if (value.length < 15) {
            return 'Description must be 15 or more characters long';
          }
        },
        onSaved: (String value) {
          setState(() {
            _description = value;
          });
        });
  }

  Widget _buildPriceTextField() {
    return TextFormField(
        controller: priceTextFieldController,
        decoration: InputDecoration(labelText: 'Product Price'),
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Product must have a minimum price of 0.01\$';
          } else if (!RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$')
              .hasMatch(value)) {
            return 'Please input a valid price';
          }
        },
        onSaved: (String value) {
          setState(() {
            double price = double.parse(value);

            if (price < 0.01) {
              price = 0.01;
            }

            _price = price;
            priceTextFieldController.text = price.toString();
          });
        });
  }

  Widget _buildCreateProductButton() {
    return RaisedButton(
        textColor: Colors.white,
        child: Text('Create Product'),
        onPressed: _onCreateProductClick);
  }

  void _onCreateProductClick() {
    // Calls all the validator methods on the forms,
    //  true if all validations succeeds, false if at least one fails
    if (!_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return;
    }

    final Product product =
        new Product(_title, _description, 'images/img512_512.png', _price);
    widget.addProduct(product);

    Navigator.pushReplacementNamed(context, '/products');
  }

  double _getPagePadding() {
    final double deviceWidth = MediaQuery.of(context).size.width;

    final double targetWidth =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? deviceWidth * 0.95
            : deviceWidth * 0.8;

    final double targetPadding = (deviceWidth - targetWidth) / 2;

    return targetPadding;
  }

  @override
  Widget build(BuildContext context) {
    // Return the body of the page, because this is a tab
    //  no need for a Scaffold and appBar
    return GestureDetector(
        onTap: () {
          // Creating an empty focus node - FocusNode(), closes the keyboard
          //  as whenever a user taps on a TextField, the focus node of the app
          //  becomes the node of the TextField, passing an empty one thus, removes the focus node
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            child: Form(
                key: _formKey,
                child: ListView(
                    padding:
                        EdgeInsets.symmetric(horizontal: _getPagePadding()),
                    children: <Widget>[
                      _buildTitleTextField(),
                      _buildDescriptionTextField(),
                      _buildPriceTextField(),
                      SizedBox(height: 10.0),
                      _buildCreateProductButton()
                    ]))));
  }
}
