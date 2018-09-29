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
      'userEmail': product.userEmail
    };

    isLoading = true;
    notifyListeners();
    http.Response response;
    try {
      response = await http.post(_serviceUrl + _serviceExtension,
          body: json.encode(productData));
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
        _serviceUrl + '/${selectedProduct.id}' + _serviceExtension;
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
        _serviceUrl + '/${selectedProduct.id}' + _serviceExtension;

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

  Future<bool> fetchProducts({bool showSpinner = true}) async {
    if (showSpinner) {
      isLoading = true;
      notifyListeners();
    }

    http.Response response;
    try {
      response = await http.get(_serviceUrl + _serviceExtension);
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
      Product product = Product(
          productId,
          productData['title'],
          productData['description'],
          productData['imageUrl'],
          productData['price'],
          productData['userId'],
          productData['userEmail']);

      fetchedProducts.add(product);
    });

    products = fetchedProducts;
    notifyListeners();

    return true;
  }

  void toggleFavoriteStatus() {
    products[selectedProductIndex].isFavorite = !selectedProduct.isFavorite;
    notifyListeners();
  }

  void selectProduct(String productId) {
    currentProductId = productId;

    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
