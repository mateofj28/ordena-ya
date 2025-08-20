import '../../domain/entity/order_item.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel({
    required super.id,
    required super.orderId,
    required super.productName,
    required super.quantity,
    required super.price,
    required super.notes,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  // Desde JSON
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      notes: json['notes'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // A JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convierte de entidad a modelo
  factory OrderItemModel.fromEntity(OrderItem entity) {
    return OrderItemModel(
      id: entity.id,
      orderId: entity.orderId,
      productName: entity.productName,
      quantity: entity.quantity,
      price: entity.price,
      notes: entity.notes,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convierte de modelo a entidad
  OrderItem toEntity() {
    return OrderItem(
      id: id,
      orderId: orderId,
      productName: productName,
      quantity: quantity,
      price: price,
      notes: notes,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
