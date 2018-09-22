import './connected_products_model.dart';
import '../models/product.dart';

class ProductsModel extends ConnectedProductsModel {
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

  void addProduct(Product product) {
    product.userEmail = authenticatedUser.email;
    product.userId = authenticatedUser.id;
    products.add(product);
  }

  void updateProduct(Product newProduct) {
    newProduct.userEmail = authenticatedUser.email;
    newProduct.userId = authenticatedUser.id;
    products[selectedProductIndex] = newProduct;
  }

  void removeProduct() {
    products.removeAt(selectedProductIndex);
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
