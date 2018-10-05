import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 150.0,
              padding: EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Text('Pick an image',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                FlatButton(
                    textColor: Theme.of(context).accentColor,
                    child: Text('Use Camera'),
                    onPressed: () {
                      _getImage(context, ImageSource.camera);
                    }),
                SizedBox(height: 5.0),
                FlatButton(
                    textColor: Theme.of(context).accentColor,
                    child: Text('Use Gallery'),
                    onPressed: () {
                      _getImage(context, ImageSource.gallery);
                    })
              ]));
        });
  }

  void _getImage(BuildContext context, ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source, maxWidth: 400.0);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Color accentColor = Theme.of(context).accentColor;

    return Column(children: <Widget>[
      OutlineButton(
          borderSide: BorderSide(color: accentColor, width: 1.0),
          onPressed: () {
            _openImagePicker(context);
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.camera_alt, color: accentColor),
                SizedBox(width: 2.0),
                Text('Add Image', style: TextStyle(color: accentColor))
              ]))
    ]);
  }
}
