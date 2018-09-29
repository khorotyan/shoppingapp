import 'package:flutter/material.dart';

class HttpErrorDialog extends StatelessWidget {
  final String title;
  final String content;

  HttpErrorDialog(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Something went wrong'),
        content: Text('Please try again!'),
        actions: <Widget>[
          FlatButton(
              child: Text('Okay'), onPressed: () => Navigator.of(context).pop())
        ]);
  }
}
