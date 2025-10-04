import '../../domain/entity/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.preparationTime,
    required super.unitPrice,
    required super.imageUrl,
    required super.quantity,
    required super.category, 
    required super.notes,
  });

  /// Serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'preparationTime': preparationTime,
      'unitPrice': unitPrice,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'category': category,
      'observations': notes,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['productId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      preparationTime: json['preparationTime'] ?? 0,
      unitPrice: (json['price'] ?? 0).toDouble(),
      imageUrl: json['photo'] ?? '',
      quantity: json['quantity'] ?? 0,
      category: json['category'] ?? '',
      notes: json['observations'] ?? '',
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      preparationTime: preparationTime,
      unitPrice: unitPrice,
      imageUrl: imageUrl,
      quantity: quantity,
      category: category,
      notes: notes
    );
  }
}
