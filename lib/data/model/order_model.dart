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
    required super.subtotal,
    required super.tax,
    required super.total,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      tenantId: json['tenant_id'],
      tableId: json['table_id'],
      waiterId: json['waiter_id'],
      customerName: json['customer_name'],
      type: json['type'],
      status: json['status'],
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
      tax: double.tryParse(json['tax'].toString()) ?? 0.0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenant_id': tenantId,
      'table_id': tableId,
      'waiter_id': waiterId,
      'customer_name': customerName,
      'type': type,
      'status': status,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
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
      subtotal: order.subtotal,
      tax: order.tax,
      total: order.total,
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    );
  }

  Order toEntity() => this;
}
