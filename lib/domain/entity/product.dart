class Product {
  String name;
  String description;
  double unitPrice;
  String imageUrl;
  String category;
  bool available;
  DateTime createdAt;
  DateTime updatedAt;

  Product({
    required this.name,
    required this.description,
    required this.unitPrice,
    required this.imageUrl,
    required this.category,
    required this.available,
    required this.createdAt,
    required this.updatedAt,
  });
}
