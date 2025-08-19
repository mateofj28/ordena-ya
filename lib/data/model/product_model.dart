import '../../domain/entity/product.dart';


class ProductModel extends Product {
  ProductModel({
    required super.name,
    required super.description,
    required super.unitPrice,
    required super.imageUrl,
    required super.category,
    required super.available,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      description: json['description'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      available: json['available'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'unitPrice': unitPrice,
      'imageUrl': imageUrl,
      'category': category,
      'available': available,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      name: entity.name,
      description: entity.description,
      unitPrice: entity.unitPrice,
      imageUrl: entity.imageUrl,
      category: entity.category,
      available: entity.available,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Product toEntity() => this;
}
