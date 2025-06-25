import 'package:ordena_ya/domain/entities/ordered_product.dart';

class OrderedProductModel extends OrderedProduct {
  OrderedProductModel(
    super.id, {
    required super.name,
    required super.price,
    required super.quantity,
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
        price:
            (json['unitPrice'] as num).toDouble(), // seguro si es int o double
        quantity:
            json['quantity'] is int
                ? json['quantity']
                : int.tryParse(json['quantity'].toString()) ??
                    1, // por si viene como string
      );
    } catch (e, stacktrace) {
      print('❌ Error en OrderedProductModel.fromJson: $e');
      print(stacktrace);
      rethrow;
    }
  }

  factory OrderedProductModel.fromEntity(OrderedProduct entity) {
    return OrderedProductModel(
      entity.id,
      name: entity.name,
      price: entity.price,
      quantity: entity.quantity,
    );
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'unitPrice': price,
      'quantity': quantity,
    };
  }
}
