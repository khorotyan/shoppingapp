import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';

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

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.yellow.withOpacity(0.8), BlendMode.dstATop),
        image: AssetImage('images/background.png'));
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email', filled: true),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email address';
        }
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password', filled: true),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password must have a minimum length of 6';
        }
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
        value: _acceptTerms,
        onChanged: (bool value) {
          // We have setState because we have to rebuild the ui of the switch
          setState(() {
            _acceptTerms = value;
          });
        },
        title: Text('Accept User Terms'));
  }

  Widget _buildLoginButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return RaisedButton(
        textColor: Colors.white,
        child: Text('Login'),
        onPressed: () => _onLoginClick(model.login),
      );
    });
  }

  void _onLoginClick(Function login) {
    _formKey.currentState.save();

    if (!_formKey.currentState.validate() || !_acceptTerms) {
      return;
    }

    login(_email, _password);

    // pushReplacement means that the current page gets completely
    //  replaced by the new page (cannot go back to this page from it)
    //  destroys data that existed in the previous page
    Navigator.pushReplacementNamed(context, '/products');
  }

  double _getAuthPageWidth() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return MediaQuery.of(context).orientation == Orientation.portrait
        ? screenWidth * 0.95
        : screenWidth * 0.8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Container(
            decoration: BoxDecoration(image: _buildBackgroundImage()),
            padding: EdgeInsets.all(10.0),
            child: Center(
                child: Container(
                    width: _getAuthPageWidth(),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _buildEmailTextField(),
                            SizedBox(height: 12.0),
                            _buildPasswordTextField(),
                            SizedBox(height: 12.0),
                            _buildAcceptSwitch(),
                            SizedBox(height: 12.0),
                            _buildLoginButton()
                          ],
                        ))))));
  }
}
