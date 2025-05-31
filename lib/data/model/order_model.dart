import '../../domain/entities/order.dart';

import 'product_model.dart';

class OrderModel extends Order {
  OrderModel({
    super.id,
    required super.orderNumber,
    required super.deliveryType,
    super.assignedTable,
    required super.numberOfPeople,
    required super.clientId,
    required super.deliveryAddress,
    required super.orderedProducts,
    required super.discountApplied,
    required super.totalValue,
    required super.paymentMethod,
    required super.orderStatus,
    required super.orderDate,
    required super.statusUpdatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderNumber: json['orderNumber'],
      deliveryType: json['deliveryType'],
      assignedTable: json['assignedTable'],
      numberOfPeople: json['numberOfPeople'],
      clientId: json['clientId'],
      deliveryAddress: json['deliveryAddress'],
      orderedProducts: (json['orderedProducts'] as List)
          .map((item) => ProductModel.fromJson(item))
          .toList(),
      discountApplied: json['discountApplied'].toDouble(),
      totalValue: json['totalValue'].toDouble(),
      paymentMethod: json['paymentMethod'],
      orderStatus: json['orderStatus'],
      orderDate: DateTime.parse(json['orderDate']),
      statusUpdatedAt: DateTime.parse(json['statusUpdatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'deliveryType': deliveryType,
      'assignedTable': assignedTable,
      'numberOfPeople': numberOfPeople,
      'clientId': clientId,
      'deliveryAddress': deliveryAddress,
      'orderedProducts': orderedProducts
          .map((product) => (product as ProductModel).toJson())
          .toList(),
      'discountApplied': discountApplied,
      'totalValue': totalValue,
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus,
      'orderDate': orderDate.toIso8601String(),
      'statusUpdatedAt': statusUpdatedAt.toIso8601String(),
    };
  }

  factory OrderModel.fromEntity(Order entity) {
    return OrderModel(
      orderNumber: entity.orderNumber,
      deliveryType: entity.deliveryType,
      assignedTable: entity.assignedTable,
      numberOfPeople: entity.numberOfPeople,
      clientId: entity.clientId,
      deliveryAddress: entity.deliveryAddress,
      orderedProducts: entity.orderedProducts,
      discountApplied: entity.discountApplied,
      totalValue: entity.totalValue,
      paymentMethod: entity.paymentMethod,
      orderStatus: entity.orderStatus,
      orderDate: entity.orderDate,
      statusUpdatedAt: entity.statusUpdatedAt,
    );
  }

  Order toEntity() => this;
}
