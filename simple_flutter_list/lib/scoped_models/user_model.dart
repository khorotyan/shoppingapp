import './connected_products_model.dart';
import '../models/user.dart';

class UserModel extends ConnectedProductsModel {
  void login(String email, String password) {
    authenticatedUser = User(id: 'jfhsvrbdr', email: email, password: password);
  }
}
