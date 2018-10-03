import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import './connected_products_model.dart';
import '../models/product.dart';

class ProductsModel extends ConnectedProductsModel {
  static const String _serviceUrl =
      'https://flutter-shopping-ce8bc.firebaseio.com/products';
  static const String _serviceExtension = '.json';

  bool _showFavorites = false;

  String get _authParam {
    return '?auth=${authenticatedUser.accessToken}';
  }

  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.isFavorite).toList();
    }

    return List.from(products);
  }

  String get selectedProductId {
    return currentProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }

    return products.firstWhere((Product product) {
      return product.id == selectedProductId;
    });
  }

  bool get showFavorites {
    return _showFavorites;
  }

  int get selectedProductIndex {
    return products.indexWhere((Product product) {
      return product.id == selectedProductId;
    });
  }

  Future<bool> addProduct(Product product) async {
    product.userEmail = authenticatedUser.email;
    product.userId = authenticatedUser.id;

    final Map<String, dynamic> productData = {
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'userId': product.userId,
      'userEmail': product.userEmail,
      'location': {
        'latitude': product.location.latitude,
        'longitude': product.location.longitude,
        'address': product.location.address
      }
    };

    String finalUrl = _serviceUrl + _serviceExtension + _authParam;

    isLoading = true;
    notifyListeners();
    http.Response response;
    try {
      response = await http.post(finalUrl, body: json.encode(productData));
    } catch (error) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    isLoading = false;

    if (response.statusCode >= 400) {
      notifyListeners();
      return false;
    }

    final Map<String, dynamic> responseData = json.decode(response.body);

    product.id = responseData['name'];
    products.add(product);
    notifyListeners();

    return true;
  }

  Future<bool> updateProduct(Product newProduct) async {
    newProduct.id = selectedProduct.id;
    newProduct.userEmail = authenticatedUser.email;
    newProduct.userId = authenticatedUser.id;

    String finalUrl =
        _serviceUrl + '/${selectedProduct.id}' + _serviceExtension + _authParam;
    Map<String, dynamic> updateData = {
      'title': newProduct.title,
      'description': newProduct.description,
      'imageUrl': newProduct.imageUrl,
      'price': newProduct.price,
      'userId': newProduct.userId,
      'userEmail': newProduct.userEmail
    };

    isLoading = true;
    notifyListeners();
    http.Response response;
    try {
      response = await http.put(finalUrl, body: json.encode(updateData));
    } catch (error) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    isLoading = false;

    if (response.statusCode >= 400) {
      notifyListeners();
      return false;
    }

    products[selectedProductIndex] = newProduct;
    notifyListeners();

    return true;
  }

  Future<bool> removeProduct() async {
    String finalUrl =
        _serviceUrl + '/${selectedProduct.id}' + _serviceExtension + _authParam;

    isLoading = true;
    products.removeAt(selectedProductIndex);
    selectProduct(null);

    notifyListeners();
    http.Response response;
    try {
      response = await http.delete(finalUrl);
    } catch (error) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    isLoading = false;

    if (response.statusCode >= 400) {
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<bool> fetchProducts(
      {bool showSpinner = true, onlyUserProducts = false}) async {
    if (showSpinner) {
      isLoading = true;
      notifyListeners();
    }

    String finalUrl = _serviceUrl + _serviceExtension + _authParam;

    http.Response response;
    try {
      response = await http.get(finalUrl);
    } catch (error) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    isLoading = false;

    if (response.statusCode >= 400) {
      notifyListeners();
      return false;
    }

    List<Product> fetchedProducts = new List<Product>();
    Map<String, dynamic> productsData = json.decode(response.body);

    if (productsData == null) {
      notifyListeners();
      return true;
    }

    productsData.forEach((String productId, dynamic productData) {
      var likedUsers = productData['likedUsers'];
      bool isFavorite = false;

      if (likedUsers != null) {
        isFavorite = (likedUsers as Map<String, dynamic>)
            .containsKey(authenticatedUser.id);
      }

      Product product = Product(
          productId,
          productData['title'],
          productData['description'],
          productData['imageUrl'],
          productData['price'],
          productData['userId'],
          productData['userEmail'],
          isFavorite);

      fetchedProducts.add(product);
    });

    if (onlyUserProducts) {
      products = fetchedProducts.where((Product product) {
        return product.userId == authenticatedUser.id;
      }).toList();
    } else {
      products = fetchedProducts;
    }

    notifyListeners();

    return true;
  }

  Future<bool> toggleFavoriteStatus() async {
    bool isFavorite = !selectedProduct.isFavorite;
    products[selectedProductIndex].isFavorite = isFavorite;
    notifyListeners();

    String finalUrl = _serviceUrl +
        '/${selectedProduct.id}/likedUsers/${authenticatedUser.id}' +
        _serviceExtension +
        _authParam;

    http.Response response;

    try {
      if (isFavorite) {
        response = await http.put(finalUrl, body: json.encode(true));
      } else {
        response = await http.delete(finalUrl);
      }
    } catch (error) {
      products[selectedProductIndex].isFavorite = !isFavorite;
      notifyListeners();
      return false;
    }

    if (response.statusCode >= 400) {
      products[selectedProductIndex].isFavorite = !isFavorite;
      notifyListeners();
      return false;
    }

    return true;
  }

  void selectProduct(String productId) {
    currentProductId = productId;

    if (productId == null) {
      return;
    }

    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
