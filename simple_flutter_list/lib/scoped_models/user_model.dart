import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import './connected_products_model.dart';
import '../models/user.dart';
import '../models/firebase_login_result.dart';

class UserModel extends ConnectedProductsModel {
  FirebaseLoginResult firebaseLoginResult;

  static const String _apiKey = 'AIzaSyAFHDcTuQPEe3xCM-G2uABjLzTVi5Zovgk';
  static const String _signupUrl = 'https://www.googleapis.com/identitytoolkit';

  PublishSubject<bool> _userSubject = PublishSubject();
  Timer _authTimer;

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Tuple2<bool, FirebaseLoginResult>> authenticate(
      String email, String password, bool isLoginMode) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    String endpointIdentifier =
        isLoginMode ? 'verifyPassword' : 'signupNewUser';

    String finalUrl =
        '$_signupUrl/v3/relyingparty/$endpointIdentifier?key=$_apiKey';

    isLoading = true;
    notifyListeners();
    http.Response response;

    try {
      response = await http.post(finalUrl,
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } catch (error) {
      isLoading = false;
      notifyListeners();
      return Tuple2(false, null);
    }

    isLoading = false;

    if (response.statusCode >= 400) {
      notifyListeners();
      return Tuple2(false, null);
    }

    Map<String, dynamic> responseData = json.decode(response.body);

    firebaseLoginResult = FirebaseLoginResult(
        responseData['kind'],
        responseData['idToken'],
        responseData['email'],
        responseData['refreshToken'],
        responseData['expiresIn'],
        responseData['localId']);

    int expireTime = int.parse(firebaseLoginResult.expiresIn);

    authenticatedUser = User(
        id: firebaseLoginResult.localId,
        email: firebaseLoginResult.email,
        accessToken: firebaseLoginResult.idToken);

    setAuthTimeout(expireTime);
    _userSubject.add(true);

    DateTime currentTime = DateTime.now();
    DateTime expiryTime = currentTime.add(Duration(seconds: expireTime));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', firebaseLoginResult.localId);
    prefs.setString('userEmail', firebaseLoginResult.email);
    prefs.setString('accessToken', firebaseLoginResult.idToken);
    prefs.setString('expiryTime', expiryTime.toIso8601String());

    notifyListeners();

    return Tuple2(true, firebaseLoginResult);
  }

  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken');
    String expiryTimeString = prefs.getString('expiryTime');

    if (accessToken != null) {
      DateTime currentTime = DateTime.now();
      DateTime expiryTime = DateTime.parse(expiryTimeString);

      // AccessToken has already expired
      if (expiryTime.isBefore(currentTime)) {
        authenticatedUser = null;
        notifyListeners();
        return;
      }

      String userId = prefs.getString('userId');
      String userEmail = prefs.getString('userEmail');
      int remainingTokenTime = expiryTime.difference(currentTime).inSeconds;

      authenticatedUser =
          User(id: userId, email: userEmail, accessToken: accessToken);
      setAuthTimeout(remainingTokenTime);
      _userSubject.add(true); // Emit an event when we login
      notifyListeners();
    }
  }

  void logout() async {
    authenticatedUser = null;
    products = [];
    _authTimer.cancel();
    _userSubject.add(false); // Emit an event when we logout
    selectProduct(null);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('userEmail');
    prefs.remove('accessToken');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}
