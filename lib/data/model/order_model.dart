import 'package:ordena_ya/data/model/item_model.dart';

import '../../domain/entity/order.dart';

class OrderModel extends Order {
  OrderModel({
    required super.id,
    required super.tenantId,
    required super.tableId,
    required super.waiterId,
    required super.customerName,
    required super.type,
    required super.status,
    required super.tax,
    required super.total,
    required super.createdAt,
    required super.updatedAt,
    required List<ItemModel>? super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      tenantId: json['tenant_id'] ?? 1,
      tableId: json['table_id'],
      waiterId: json['waiter_id'] ?? 2,
      customerName: json['customer_name'],
      type: json['type'] ?? 'dine_in',
      status: json['status'],
      tax: double.tryParse(json['tax'].toString()) ?? 0.0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: json['items'] != null
              ? (json['items'] as List<dynamic>)
                  .map((item) => ItemModel.fromJson(item))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'table_id': tableId,
      'waiter_id': waiterId,
      'customer_name': customerName,
      'type': type,
      'status': status,
      'tax': tax,
      'total': total,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'items': items?.map((item) => (item as ItemModel).toJson()).toList(),
    };
  }

  /// -------- ENTITY ↔️ MODEL --------
  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      tenantId: order.tenantId,
      tableId: order.tableId,
      waiterId: order.waiterId,
      customerName: order.customerName,
      type: order.type,
      status: order.status,
      tax: order.tax,
      total: order.total,
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
      items:
          order.items != null
              ? order.items!.map((item) => ItemModel.fromEntity(item)).toList()
              : [],
    );
  }

  Order toEntity() => this;
}
