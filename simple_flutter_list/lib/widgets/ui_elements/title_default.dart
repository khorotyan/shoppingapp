import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String title;

  TitleDefault(this.title);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final fontSize = deviceWidth > 700 ? 20.0 : 16.0;

    return Text(title,
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'Oswald'));
  }
}
