import '../../core/utils/logger.dart';
import '../../domain/entity/order.dart';

class OrderModel extends Order {
  OrderModel({
    required super.tenantId,
    required super.tableId,
    required super.status,
    required super.subtotal,
    required super.tax,
    required super.total,
    required super.createdAt,
    required super.orderId,
    required super.peopleCount,
    required super.consumptionType,
    required super.clientId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    Logger.debug('OrderModel JSON: $json');
    return OrderModel(
      orderId: json['orderId'] as String,
      tenantId: json['tenantId'] as String,
      tableId: json['tableId'] as String?,
      peopleCount: json['peopleCount'] as int,
      consumptionType: json['consumptionType'] as String,
      clientId: json['clientId'] as String?, // nullable
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'tenantId': tenantId,
      'tableId': tableId,
      'peopleCount': peopleCount,
      'consumptionType': consumptionType,
      'clientId': clientId,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
    };
  }

  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      orderId: order.orderId,
      tenantId: order.tenantId,
      tableId: order.tableId,
      peopleCount: order.peopleCount,
      consumptionType: order.consumptionType,
      clientId: order.clientId,
      status: order.status,
      createdAt: order.createdAt,
      subtotal: order.subtotal,
      tax: order.tax,
      total: order.total,
    );
  }

  Order toEntity() => this;
}
