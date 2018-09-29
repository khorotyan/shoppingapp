import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

import './connected_products_model.dart';
import '../models/user.dart';
import '../models/firebase_login_result.dart';

class UserModel extends ConnectedProductsModel {
  FirebaseLoginResult firebaseLoginResult;

  static const String _apiKey = 'AIzaSyAFHDcTuQPEe3xCM-G2uABjLzTVi5Zovgk';
  static const String _signupUrl = 'https://www.googleapis.com/identitytoolkit';

  Future<Tuple2<bool, FirebaseLoginResult>> authenticate(
      String email, String password, bool isLoginMode) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    String endpointIdentifier = isLoginMode ? 'verifyPassword' : 'signupNewUser';

    String finalUrl = '$_signupUrl/v3/relyingparty/$endpointIdentifier?key=$_apiKey';

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

    notifyListeners();

    return Tuple2(true, firebaseLoginResult);
  }
}
