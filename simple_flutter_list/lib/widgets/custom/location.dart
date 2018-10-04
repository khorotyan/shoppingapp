import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;

import '../../helpers/ensure_visible.dart';
import '../../models/location_data.dart';
import '../../models/product.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  static const String _googleApiKey = 'AIzaSyD1tXGpDhf-91u0JTlMcKjGEAH_wFrH8GQ';
  final FocusNode _addressInputNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();

  Uri _staticMapUri;
  LocationData _locationData;

  @override
  void initState() {
    _addressInputNode.addListener(_updateLocation);

    // If we are in the edit mode, retrieve the product address
    if (widget.product != null) {
      getStaticMap(widget.product.location.address, false);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addressInputNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap(String locationName, [bool geocode = true]) async {
    if (locationName.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }

    // Retrieve coordinates from address
    if (geocode) {
      Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
          {'address': locationName, 'key': _googleApiKey});
      http.Response response;

      try {
        response = await http.get(uri);
      } catch (error) {
        return;
      }

      if (response.statusCode >= 400) {
        return;
      }

      Map<String, dynamic> decodedResponse = json.decode(response.body);
      var formattedAddress = decodedResponse['results'][0]['formatted_address'];
      var coordinates = decodedResponse['results'][0]['geometry']['location'];
      _locationData = LocationData(
          coordinates['lat'], coordinates['lng'], formattedAddress);
    } else {
      _locationData = widget.product.location;
    }

    StaticMapProvider staticMapProvider = StaticMapProvider(_googleApiKey);

    Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers([
      Marker('position', 'Position', _locationData.latitude,
          _locationData.longitude)
    ],
        center: Location(_locationData.latitude, _locationData.longitude),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);

    widget.setLocation(_locationData);

    setState(() {
      _addressInputController.text = _locationData.address;
      _staticMapUri = staticMapUri;
    });
  }

  void _updateLocation() {
    // When the user focuses away from the address input field
    if (!_addressInputNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
            focusNode: _addressInputNode,
            child: TextFormField(
                focusNode: _addressInputNode,
                controller: _addressInputController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Location field is required';
                  } else if (_locationData == null) {
                    return 'No valid location found';
                  }
                },
                decoration: InputDecoration(labelText: "Product Location"))),
        SizedBox(height: 12.0),
        _staticMapUri == null
            ? Container()
            : Image.network(_staticMapUri.toString())
      ],
    );
  }
}
