import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scoped_models/main_model.dart';
import '../helpers/ensure_visible.dart';
import '../widgets/custom/http_error_dialog.dart';
import '../widgets/custom/location_input.dart';
import '../widgets/custom/image_input.dart';
import '../models/location_data.dart';

class ProductManagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductManagePage> {
  Product _product = Product(null, null, null, null, null, null, null, null);
  File _imageFile;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
          focusNode: _titleFocusNode,
          initialValue: product != null ? product.title : '',
          decoration: InputDecoration(labelText: 'Product Title'),
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
            initialValue: product != null ? product.description : '',
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

  void _setLocation(LocationData locationData) {
    _product.location = locationData;
  }

  void _setImage(File image) {
    _imageFile = image;
  }

  Widget _buildCreateProductButton(MainModel model) {
    Widget widget = model.isLoading
        ? Center(child: CircularProgressIndicator())
        : ButtonTheme(
            minWidth: double.infinity,
            child: RaisedButton(
                textColor: Colors.white,
                child: Text('Save'),
                onPressed: () => _onCreateProductClick(
                    model.addProduct,
                    model.updateProduct,
                    model.selectProduct,
                    model.selectedProductId)));

    return widget;
  }

  void _onCreateProductClick(Function addProduct, Function updateProduct,
      Function setSelectedProduct, String selectedProductId) async {
    _formKey.currentState.save();

    // Calls all the validator methods on the forms,
    //  true if all validations succeeds, false if at least one fails
    if (!_formKey.currentState.validate() ||
        (_imageFile == null && selectedProductId == null)) {
      return;
    }

    bool isSuccessful;
    if (selectedProductId == null) {
      isSuccessful = await addProduct(_product, _imageFile);
    } else {
      isSuccessful = await updateProduct(_product, _imageFile);
    }

    if (!isSuccessful) {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              HttpErrorDialog('Something went wrong', 'Please try again!'));
    } else {
      Navigator
          .pushReplacementNamed(context, '/')
          .then((_) => setSelectedProduct(null));
    }
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
                  child: SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: _getPagePadding()),
                          child: Column(children: <Widget>[
                            _buildTitleTextField(model.selectedProduct),
                            _buildDescriptionTextField(model.selectedProduct),
                            _buildPriceTextField(model.selectedProduct),
                            SizedBox(height: 10.0),
                            LocationInput(_setLocation, model.selectedProduct),
                            SizedBox(height: 10.0),
                            ImageInput(_setImage, model.selectedProduct),
                            SizedBox(height: 10.0),
                            _buildCreateProductButton(model),
                            SizedBox(height: 10.0)
                          ]))))));

      return model.selectedProductId == null
          ? pageContent
          : Scaffold(
              appBar: AppBar(title: Text('Edit Product')), body: pageContent);
    });
  }
}
