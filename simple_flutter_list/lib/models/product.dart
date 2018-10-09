import './location_data.dart';

class Product {
  String id;
  String title;
  String description;
  String imagePath;
  String imageUrl;
  double price;
  bool isFavorite;
  String userId;
  String userEmail;
  LocationData location;

  Product(this.id, this.title, this.description, this.imagePath, this.imageUrl,
      this.price, this.userId, this.userEmail,
      [this.isFavorite = false, this.location]);
}
