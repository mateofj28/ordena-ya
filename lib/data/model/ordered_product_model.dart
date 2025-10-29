import 'package:ordena_ya/core/utils/logger.dart';
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
      Logger.debug("OrderedProductModel.fromJson() → json: $json");
      Logger.debug("id: ${json['id']}");
      Logger.debug("name: ${json['name']}");
      Logger.debug("unitPrice: ${json['unitPrice']}");
      Logger.debug("quantity: ${json['quantity']}");

      return OrderedProductModel(
        json['id'],
        name: json['name'],
        price: (json['unitPrice'] as num).toDouble(),
        units: []
      );
    } catch (e) {
      Logger.error('Error en OrderedProductModel.fromJson: $e');
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

  Map<String, Object?> toJson() {
    return {'id': id, 'name': name, 'unitPrice': price, 'quantity': quantity};
  }
}
