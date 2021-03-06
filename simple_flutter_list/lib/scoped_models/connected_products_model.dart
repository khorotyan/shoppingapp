import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

class ConnectedProductsModel extends Model {
  List<Product> products = new List<Product>();
  String currentProductId;
  User authenticatedUser;

  bool isLoading = false;

  void selectProduct(String productId) {
    currentProductId = productId;

    if (productId == null) {
      return;
    }

    notifyListeners();
  }
}
