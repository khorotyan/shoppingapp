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
  bool _isLoading = false;

  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.isFavorite).toList();
    }

    return List.from(products);
  }

  int get selectedProductIndex {
    return currentProductIndex;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }

    return products[selectedProductIndex];
  }

  bool get showFavorites {
    return _showFavorites;
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<void> addProduct(Product product) async {
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

    _isLoading = true;
    notifyListeners();
    var response = await http.post(_serviceUrl + _serviceExtension, body: json.encode(productData));
    _isLoading = false;

    final Map<String, dynamic> responseData = json.decode(response.body);

    product.id = responseData['name'];
    products.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(Product newProduct) async {
    newProduct.id = selectedProduct.id;
    newProduct.userEmail = authenticatedUser.email;
    newProduct.userId = authenticatedUser.id;

    String finalUrl = _serviceUrl + '/${selectedProduct.id}' + _serviceExtension;
    Map<String, dynamic> updateData = {
      'title': newProduct.title,
      'description': newProduct.description,
      'imageUrl': newProduct.imageUrl,
      'price': newProduct.price,
      'userId': newProduct.userId,
      'userEmail': newProduct.userEmail
    };

    _isLoading = true;
    notifyListeners();
    await http.put(finalUrl, body: json.encode(updateData));
    _isLoading = false;

    products[selectedProductIndex] = newProduct;
    notifyListeners();
  }

  Future<void> removeProduct() async {
    String finalUrl = _serviceUrl + '/${selectedProduct.id}' + _serviceExtension;

    _isLoading = true;
    products.removeAt(selectedProductIndex);
    selectProduct(null);
    
    notifyListeners();
    await http.delete(finalUrl);
    _isLoading = false;

    notifyListeners();
  }

  Future<void> fetchProducts({bool showSpinner = true}) async {
    
    if (showSpinner) {
      _isLoading = true;
      notifyListeners();
    }
    
    var response = await http.get(_serviceUrl + _serviceExtension);
    _isLoading = false;

    List<Product> fetchedProducts = new List<Product>();
    Map<String, dynamic> productsData = json.decode(response.body);

    if (productsData == null) {
      notifyListeners();
      return;
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
  }

  void toggleFavoriteStatus() {
    products[selectedProductIndex].isFavorite = !selectedProduct.isFavorite;
    notifyListeners();
  }

  void selectProduct(int index) {
    currentProductIndex = index;

    if (index != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
