import 'package:flutter/material.dart';

class ProductCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Return the body of the page, because this is a tab
    //  no need for a Scaffold and appBar
    return Center(
        child: RaisedButton(
            color: Theme.of(context).accentColor,
            child: Text('Save Product', style: TextStyle(color: Colors.white)),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('images/img512_512.png',
                            width: 256.0, height: 256.0),
                        Container(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Product created!'))
                      ],
                    );
                  });
            }));
  }
}
