import 'package:ordena_ya/data/model/unit_model.dart';
import 'package:ordena_ya/domain/entity/item.dart';

class ItemModel extends Item {
  ItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.price,
    required super.subtotal,
    required super.notes,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.units,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      notes: json['notes'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      units:
          (json['units'] as List<dynamic>)
              .map((u) => UnitModel.fromJson(u))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'subtotal': subtotal,
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'units': units.map((u) {
        // Si tienes UnitModel con toJson():
        if (u is UnitModel) return u.toJson();

        // Si 'units' es la entidad base Unit:
        return {
          'id': u.id,
          'status': u.status,
          'created_at': u.createdAt.toIso8601String(),
          'updated_at': u.updatedAt.toIso8601String(),
        };
      }).toList(),
    };
  }  

  factory ItemModel.fromEntity(Item item) {
    return ItemModel(
      id: item.id,
      productId: item.productId,
      productName: item.productName,
      quantity: item.quantity,
      price: item.price,
      subtotal: item.subtotal,
      notes: item.notes,
      status: item.status,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
      units: item.units.map((u) => UnitModel.fromEntity(u)).toList(),
    );
  }

  
}
