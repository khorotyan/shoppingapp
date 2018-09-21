class Product {
  String title;
  String description;
  String imageUrl;
  double price;
  bool isFavorite;

  Product(this.title, this.description, this.imageUrl, this.price, [this.isFavorite = false]);
}
