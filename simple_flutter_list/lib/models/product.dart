class Product {
  String id;
  String title;
  String description;
  String imageUrl;
  double price;
  bool isFavorite;
  String userId;
  String userEmail;

  Product(this.id, this.title, this.description, this.imageUrl, this.price, this.userId,
      this.userEmail,
      [this.isFavorite = false]);
}
