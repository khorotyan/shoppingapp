import 'package:flutter/material.dart';

import './products_page.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Center(
            child: RaisedButton(
              color: Theme.of(context).accentColor,
          child: Text('Login', style: TextStyle(color: Colors.white)),
          onPressed: () {
            // pushReplacement means that the current page gets completely
            //  replaced by the new page (cannot go back to this page from it)
            //  destroys data that existed in the previous page
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProductsPage()));
          },
        )));
  }
}
