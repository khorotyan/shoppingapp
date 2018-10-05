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
                    onPressed: () {}),
                SizedBox(height: 5.0),
                FlatButton(
                    textColor: Theme.of(context).accentColor,
                    child: Text('Use Gallery'),
                    onPressed: () {})
              ]));
        });
  }

  void _getImage(BuildContext context, ImageSource ) {
    
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
                Text('Add Image', style: TextStyle(color: accentColor))
              ]))
    ]);
  }
}
