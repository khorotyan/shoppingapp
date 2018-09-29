import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';
import '../widgets/custom/http_error_dialog.dart';

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
  bool _isLoginMode = true;
  static const String _loginSwitchText = 'Already have an account? LOGIN';
  static const String _signupSwitchText = 'Don\'t have an account? SIGNUP';
  static const String _loginButtonText = 'LOGIN';
  static const String _signupButtonText = 'SIGNUP';

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

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
      controller: _passwordController,
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

  Widget _buildPasswordConfirmTextField() {
    if (!_isLoginMode) {
      return TextFormField(
          decoration:
              InputDecoration(labelText: 'Confirm Password', filled: true),
          obscureText: true,
          validator: (String value) {
            if (_passwordController.text != value) {
              return 'Passwords do not match';
            }
          });
    }

    return Container();
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
      String text = _isLoginMode == true ? _loginButtonText : _signupButtonText;
      return model.isLoading
          ? Center(child: CircularProgressIndicator())
          : RaisedButton(
              textColor: Colors.white,
              child: Text(text),
              onPressed: () => _onLoginClick(model.authenticate),
            );
    });
  }

  Widget _buildModeChangerButton() {
    String modeName =
        _isLoginMode == true ? _signupSwitchText : _loginSwitchText;
    return FlatButton(
        child: Text(modeName, style: TextStyle()),
        onPressed: () {
          setState(() {
            _isLoginMode = !_isLoginMode;
          });
        });
  }

  void _onLoginClick(Function authenticate) async {
    _formKey.currentState.save();

    if (!_formKey.currentState.validate() || !_acceptTerms) {
      return;
    }

    bool isSuccessful = (await authenticate(_email, _password, _isLoginMode)).item1;

    if (!isSuccessful) {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              HttpErrorDialog('Something went wrong', 'Please try again!'));
    } else {
      Navigator.pushReplacementNamed(context, '/products');
    }
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
                child: SingleChildScrollView(
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
                                _buildPasswordConfirmTextField(),
                                SizedBox(height: 12.0),
                                _buildAcceptSwitch(),
                                SizedBox(height: 12.0),
                                _buildModeChangerButton(),
                                SizedBox(height: 12.0),
                                _buildLoginButton()
                              ],
                            )))))));
  }
}
