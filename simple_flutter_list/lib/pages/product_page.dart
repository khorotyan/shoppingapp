import 'package:flutter/material.dart';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';

import '../models/product.dart';
import '../scoped_models/main_model.dart';
import '../widgets/ui_elements/title_default.dart';
import '../widgets/products/product_fab.dart';

class ProductPage extends StatelessWidget {
  final MainModel mainModel;

  static const _mapDismissId = 1;

  ProductPage(this.mainModel);

  Widget _buildAddressAddressAndPriceRow(String address, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
            child: Text(address,
                style: TextStyle(fontFamily: 'Oswald', color: Colors.grey)),
            onTap: _showMap),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('|', style: TextStyle(color: Colors.grey))),
        Text('\$$price',
            style: TextStyle(fontFamily: 'Oswald', color: Colors.grey))
      ],
    );
  }

  void _showMap() {
    var location = mainModel.selectedProduct.location;

    var markers = <Marker>[
      Marker('position', 'position', location.latitude, location.longitude)
    ];

    var cameraPosition =
        CameraPosition(Location(location.latitude, location.longitude), 14.0);

    var mapView = MapView();
    mapView.show(
        MapOptions(
            initialCameraPosition: cameraPosition,
            mapViewType: MapViewType.normal,
            title: 'Product location'),
        toolbarActions: [ToolbarAction('Close', _mapDismissId)]);
    mapView.onToolbarAction.listen((int id) {
      if (id == _mapDismissId) {
        mapView.dismiss();
      }
    });
    mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // WillPopScope used for getting back from this page
        // onWillPop executed when clicking the back button
        onWillPop: () {
      mainModel.selectProduct(null);
      // pass false as a parameter, meaning that we do not want to delete the product
      Navigator.pop(context, false);
      // Allows the user to leave the page, pass true if leaving without the pop method
      return Future.value(false);
    }, child: ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
      final Product product = model.selectedProduct;

      return Scaffold(
          floatingActionButton: ProductFAB(product),
          body: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
                expandedHeight: 256.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                    title: Text(product.title),
                    background: Hero(
                        tag: product.id,
                        child: FadeInImage(
                            image: NetworkImage(product.imageUrl),
                            height: 300.0,
                            fit: BoxFit.cover,
                            placeholder:
                                AssetImage('images/img512_512.png'))))),
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(height: 10.0),
              Container(
                  child: TitleDefault(product.title),
                  alignment: Alignment.center),
              SizedBox(height: 10.0),
              _buildAddressAddressAndPriceRow(
                  product.location.address, product.price),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(product.description, textAlign: TextAlign.center))
            ]))
          ]));
    }));
  }
}
