import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../../models/product.dart';
import '../../scoped_models/main_model.dart';
import './price_tag.dart';
import '../ui_elements/title_default.dart';
import '../products/address_tag.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleDefault(product.title),
            SizedBox(width: 10.0),
            PriceTag(product.price.toString())
          ],
        ));
  }

  Widget _buildActionButtons(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).accentColor,
            onPressed: () => Navigator.pushNamed<bool>(
                context, '/product/' + productIndex.toString())),
        ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
          IconData favoriteIcon = model.allProducts[productIndex].isFavorite
              ? Icons.favorite
              : Icons.favorite_border;

          return IconButton(
              icon: Icon(favoriteIcon),
              color: Theme.of(context).accentColor,
              onPressed: () {
                model.selectProduct(productIndex);
                model.toggleFavoriteStatus();
              });
        })
      ],
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      Image.network(product.imageUrl),
      _buildTitlePriceRow(),
      AddressTag('Manchester, United Kingdom'),
      SizedBox(height: 12.0),
      Text(product.userEmail),
      _buildActionButtons(context)
    ]));
  }
}
