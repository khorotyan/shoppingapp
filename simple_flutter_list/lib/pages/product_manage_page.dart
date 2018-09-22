import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scoped_models/main_model.dart';
import '../helpers/ensure_visible.dart';

class ProductManagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductManagePage> {
  Product _product = new Product('', '', '', 'images/img512_512.png', 0.0, '', '');

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
          focusNode: _titleFocusNode,
          decoration: InputDecoration(labelText: 'Product Title'),
          initialValue: product != null ? product.title : '',
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

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
            focusNode: _descriptionFocusNode,
            decoration: InputDecoration(labelText: 'Product Description'),
            maxLines: 5,
            initialValue: product != null ? product.description : '',
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

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
            focusNode: _priceFocusNode,
            decoration: InputDecoration(labelText: 'Product Price'),
            keyboardType: TextInputType.number,
            initialValue: product != null ? product.price.toString() : '',
            validator: (String value) {
              if (value.isEmpty) {
                return 'Product must have a price';
              } else if (!RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$')
                  .hasMatch(value)) {
                return 'Please enter a valid price';
              }
            },
            onSaved: (String value) {
              _product.price = double.parse(value);
            }));
  }

  Widget _buildCreateProductButton(MainModel model) {
    return RaisedButton(
        textColor: Colors.white,
        child: Text('Save'),
        onPressed: () => _onCreateProductClick(
            model.addProduct,
            model.updateProduct,
            model.selectProduct,
            model.selectedProductIndex));
  }

  void _onCreateProductClick(Function addProduct, Function updateProduct,
      Function setSelectedProduct, int selectedProductIndex) {
    _formKey.currentState.save();

    // Calls all the validator methods on the forms,
    //  true if all validations succeeds, false if at least one fails
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (selectedProductIndex == null) {
      addProduct(_product);
    } else {
      updateProduct(_product);
    }

    Navigator
        .pushReplacementNamed(context, '/products')
        .then((_) => setSelectedProduct(null));
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
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
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
                        _buildTitleTextField(model.selectedProduct),
                        _buildDescriptionTextField(model.selectedProduct),
                        _buildPriceTextField(model.selectedProduct),
                        SizedBox(height: 10.0),
                        _buildCreateProductButton(model)
                      ]))));

      return model.selectedProductIndex == null
          ? pageContent
          : Scaffold(
              appBar: AppBar(title: Text('Edit Product')), body: pageContent);
    });
  }
}
