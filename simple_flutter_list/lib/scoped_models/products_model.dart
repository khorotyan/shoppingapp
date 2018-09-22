import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import './connected_products_model.dart';
import '../models/product.dart';

class ProductsModel extends ConnectedProductsModel {
  static const String _serviceUrl =
      'https://flutter-shopping-ce8bc.firebaseio.com/products.json';

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

  Future<void> addProduct(Product product) async {
    product.userEmail = authenticatedUser.email;
    product.userId = authenticatedUser.id;

    final Map<String, dynamic> productData = {
      'title': product.title,
      'description': product.description,
      'image':
          'https://yt3.ggpht.com/-tWsZd32F8kY/AAAAAAAAAAI/AAAAAAAAAAA/WrxnIMGaU3Y/nd/photo.jpg',
      'price': product.price,
      'userId': product.userId,
      'userEmail': product.userEmail
    };

    var response = await http.post(_serviceUrl, body: json.encode(productData));

    final Map<String, dynamic> responseData = json.decode(response.body);

    product.id = responseData['name'];
    products.add(product);
    notifyListeners();
  }

  void updateProduct(Product newProduct) {
    newProduct.userEmail = authenticatedUser.email;
    newProduct.userId = authenticatedUser.id;
    products[selectedProductIndex] = newProduct;
  }

  void removeProduct() {
    products.removeAt(selectedProductIndex);
  }

  Future<void> fetchProducts() async {
    var response = await http.get(_serviceUrl);

    List<Product> fetchedProducts = new List<Product>();
    Map<String, dynamic> productsData =
        json.decode(response.body);
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
