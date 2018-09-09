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

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.yellow.withOpacity(0.8), BlendMode.dstATop),
        image: AssetImage('images/background.png'));
  }

  Widget _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Email', filled: true),
      keyboardType: TextInputType.emailAddress,
      onChanged: (String value) {
        setState(() {
          _email = value;
        });
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Password', filled: true),
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          _password = value;
        });
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
        value: _acceptTerms,
        onChanged: (bool value) {
          setState(() {
            _acceptTerms = value;
          });
        },
        title: Text('Accept User Terms'));
  }

  Widget _buildLoginButton() {
    return RaisedButton(
      textColor: Colors.white,
      child: Text('Login'),
      onPressed: _onLoginClick,
    );
  }

  void _onLoginClick() {
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
                    )))));
  }
}
