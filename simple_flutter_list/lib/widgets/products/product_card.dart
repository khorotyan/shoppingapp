import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../../models/product.dart';
import '../../scoped_models/main_model.dart';
import './price_tag.dart';
import '../ui_elements/title_default.dart';
import '../products/address_tag.dart';
import '../custom/http_error_dialog.dart';

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
            Flexible(child: TitleDefault(product.title)),
            Flexible(child: SizedBox(width: 10.0)),
            Flexible(child: PriceTag(product.price.toString()))
          ],
        ));
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      IconData favoriteIcon = model.displayedProducts[productIndex].isFavorite
          ? Icons.favorite
          : Icons.favorite_border;

      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDescriptionButton(context, model),
          _buildHeartButton(context, model, favoriteIcon)
        ],
      );
    });
  }

  Widget _buildDescriptionButton(BuildContext context, MainModel model) {
    return IconButton(
        icon: Icon(Icons.info),
        color: Theme.of(context).accentColor,
        onPressed: () {
          var productId = model.displayedProducts[productIndex].id;
          model.selectProduct(productId);
          Navigator.pushNamed<bool>(context, '/product/' + productId)
              .then((_) => model.selectProduct((null)));
        });
  }

  Widget _buildHeartButton(
      BuildContext context, MainModel model, IconData favoriteIcon) {
    return IconButton(
        icon: Icon(favoriteIcon),
        color: Theme.of(context).accentColor,
        onPressed: () async {
          model.selectProduct(model.displayedProducts[productIndex].id);

          bool isSuccessful = await model.toggleFavoriteStatus();

          if (!isSuccessful) {
            showDialog(
                context: context,
                builder: (BuildContext context) => HttpErrorDialog(
                    'Something went wrong', 'Please try again!'));
          }

          model.selectProduct(null);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      Hero(
          tag: product.id,
          child: FadeInImage(
              image: product.imageUrl != null
                  ? NetworkImage(product.imageUrl)
                  : AssetImage('images/img512_512.png'),
              height: 300.0,
              width: 500.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('images/img512_512.png'))),
      _buildTitlePriceRow(),
      AddressTag(product.location.address),
      _buildActionButtons(context)
    ]));
  }
}
