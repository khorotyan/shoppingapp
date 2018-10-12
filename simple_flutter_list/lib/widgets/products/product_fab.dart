import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/product.dart';
import '../../scoped_models/main_model.dart';

class ProductFAB extends StatefulWidget {
  final Product product;

  ProductFAB(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFAB> with TickerProviderStateMixin {
  AnimationController _animController;

  @override
  void initState() {
    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  Icon _getFavoriteFABIcon(bool isFavorite) {
    return Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Theme.of(context).accentColor);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
                alignment: FractionalOffset.centerRight,
                child: ScaleTransition(
                    scale: CurvedAnimation(
                        parent: _animController,
                        curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
                    child: FloatingActionButton(
                        heroTag: 'contact',
                        backgroundColor: Theme.of(context).cardColor,
                        mini: true,
                        child: Icon(Icons.mail,
                            color: Theme.of(context).accentColor),
                        onPressed: () async {
                          String url = 'mailto:${widget.product.userEmail}';

                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            print('Could not launch email url');
                          }
                        }))),
            SizedBox(height: 10.0),
            Container(
                alignment: FractionalOffset.centerRight,
                child: ScaleTransition(
                    scale: CurvedAnimation(
                        parent: _animController,
                        curve: Interval(0.0, 0.5, curve: Curves.easeOut)),
                    child: FloatingActionButton(
                        heroTag: 'favorite',
                        backgroundColor: Theme.of(context).cardColor,
                        mini: true,
                        child: _getFavoriteFABIcon(
                            model.selectedProduct.isFavorite),
                        onPressed: () {
                          model.toggleFavoriteStatus();
                        }))),
            SizedBox(height: 10.0),
            Container(
                child: FloatingActionButton(
                    heroTag: 'more',
                    child: AnimatedBuilder(
                        // Whenever an animation is done with the controller,
                        //  the builder of this widget reruns
                        animation: _animController,
                        builder: (BuildContext context, Widget child) {
                          return Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.rotationZ(
                                  _animController.value * 0.5 * math.pi),
                              child: Icon(_animController.isDismissed
                                  ? Icons.more_vert
                                  : Icons.close));
                        }),
                    onPressed: () {
                      if (_animController.isDismissed) {
                        _animController.forward();
                      } else {
                        _animController.reverse();
                      }
                    }))
          ]);
    });
  }
}
