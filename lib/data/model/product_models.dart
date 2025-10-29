// Modelos para productos del nuevo servidor

class ProductResponseModel {
  final List<ProductDataModel> products;
  final List<ProductStatsModel> stats;

  ProductResponseModel({
    required this.products,
    required this.stats,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      products: (json['products'] as List<dynamic>?)
          ?.map((product) => ProductDataModel.fromJson(product))
          .toList() ?? [],
      stats: (json['stats'] as List<dynamic>?)
          ?.map((stat) => ProductStatsModel.fromJson(stat))
          .toList() ?? [],
    );
  }
}

class ProductDataModel {
  final String id;
  final String name;
  final double price;
  final int preparationTime;
  final String category;
  final String description;
  final String imageUrl;
  final bool isAvailable;

  ProductDataModel({
    required this.id,
    required this.name,
    required this.price,
    required this.preparationTime,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.isAvailable,
  });

  factory ProductDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDataModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      preparationTime: json['preparationTime'] ?? 0,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}

class ProductStatsModel {
  final String id;
  final int count;
  final double avgPrice;

  ProductStatsModel({
    required this.id,
    required this.count,
    required this.avgPrice,
  });

  factory ProductStatsModel.fromJson(Map<String, dynamic> json) {
    return ProductStatsModel(
      id: json['_id'] ?? '',
      count: json['count'] ?? 0,
      avgPrice: (json['avgPrice'] ?? 0).toDouble(),
    );
  }
}