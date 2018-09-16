import 'package:flutter/material.dart';

import '../entities/product.dart';
import '../helpers/ensure_visible.dart';

class ProductManagePage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Product product;
  final int productIndex;

  ProductManagePage(
      {this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductManagePage> {
  Product _product = new Product('', '', 'images/img512_512.png', 0.0);

  TextEditingController _priceTextFieldController;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  @override
  void initState() {
    _priceTextFieldController =
      TextEditingController(text: widget.product != null ? widget.product.price.toString() : '');

    super.initState();
  }

  Widget _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
          focusNode: _titleFocusNode,
          decoration: InputDecoration(labelText: 'Product Title'),
          initialValue: widget.product != null ? widget.product.title : '',
          validator: (String value) {
            if (value.isEmpty) {
              return 'Title field is required';
            } else if (value.length < 3) {
              return 'Title must be 3 or more characters long';
            }
          },
          onSaved: (String value) {
            _product.title = value;
          },
        ));
  }

  Widget _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
            focusNode: _descriptionFocusNode,
            decoration: InputDecoration(labelText: 'Product Description'),
            maxLines: 5,
            initialValue:
                widget.product != null ? widget.product.description : '',
            validator: (String value) {
              if (value.isEmpty) {
                return 'Description field is required';
              } else if (value.length < 15) {
                return 'Description must be 15 or more characters long';
              }
            },
            onSaved: (String value) {
              _product.description = value;
            }));
  }

  Widget _buildPriceTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
            focusNode: _priceFocusNode,
            controller: _priceTextFieldController,
            decoration: InputDecoration(labelText: 'Product Price'),
            keyboardType: TextInputType.number,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Product must have a minimum price of 0.99\$';
              } else if (!RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$')
                  .hasMatch(value)) {
                return 'Please enter a valid price';
              }
            },
            onSaved: (String value) {
              double price = double.parse(value);

              if (price < 0.99) {
                price = 0.99;
              }

              _product.price = price;
              _priceTextFieldController.text = price.toString();
            }));
  }

  Widget _buildCreateProductButton() {
    return RaisedButton(
        textColor: Colors.white,
        child: Text('Save'),
        onPressed: _onCreateProductClick);
  }

  void _onCreateProductClick() {
    _formKey.currentState.save();

    // Calls all the validator methods on the forms,
    //  true if all validations succeeds, false if at least one fails
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (widget.product == null) {
      widget.addProduct(_product);
    } else {
      widget.updateProduct(widget.productIndex, _product);
    }

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
    final Widget pageContent = GestureDetector(
        // Return the body of the page, because this is a tab
        //  no need for a Scaffold and appBar
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

    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(title: Text('Edit Product')), body: pageContent);
  }
}
