import 'package:ordena_ya/domain/entity/ordered_product.dart';

class OrderedProductModel extends OrderedProduct {
  OrderedProductModel(
    super.id, {
    required super.name,
    required super.price, 
    required super.units,
  });

  factory OrderedProductModel.fromJson(Map<String, dynamic> json) {
    try {
      print("🧩 OrderedProductModel.fromJson() → json: $json");
      print("🆔 id: ${json['id']}");
      print("📦 name: ${json['name']}");
      print("💲 unitPrice: ${json['unitPrice']}");
      print("🔢 quantity: ${json['quantity']}");

      return OrderedProductModel(
        json['id'],
        name: json['name'],
        price: (json['unitPrice'] as num).toDouble(),
        units: []
      );
    } catch (e, stacktrace) {
      print('❌ Error en OrderedProductModel.fromJson: $e');
      rethrow;
    }
  }

  factory OrderedProductModel.fromEntity(OrderedProduct entity) {
    return OrderedProductModel(
      entity.id,
      name: entity.name,
      price: entity.price, 
      units: [],
    );
  }

  toJson() {
    return {'id': id, 'name': name, 'unitPrice': price, 'quantity': quantity};
  }
}
