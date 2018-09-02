import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _email;
  String _password;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Container(
            margin: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                SwitchListTile(value: _acceptTerms, onChanged: (bool value){ setState(() {
                                  _acceptTerms = value;
                                });}, title: Text('Accept User Terms')),
                SizedBox(height: 10.0),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  child: Text('Login'),
                  onPressed: () {
                    // pushReplacement means that the current page gets completely
                    //  replaced by the new page (cannot go back to this page from it)
                    //  destroys data that existed in the previous page
                    Navigator.pushReplacementNamed(context, '/products');
                  },
                )
              ],
            )));
  }
}
