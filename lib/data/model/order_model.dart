import 'package:ordena_ya/data/model/ordered_product_model.dart';

import '../../domain/entities/order.dart';

import '../../domain/entities/ordered_product.dart';
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
    try {
      print("orderNumber: ${json['orderNumber']}");
      print("deliveryType: ${json['deliveryType']}");
      print("assignedTable: ${json['assignedTable']}");
      print("numberOfPeople: ${json['numberOfPeople']}");
      print("clientId: ${json['clientId']}");
      print("deliveryAddress: ${json['deliveryAddress']}");
      print("orderedProducts: ${json['orderedProducts']}");
      print("discountApplied: ${json['discountApplied']}");
      print("totalValue: ${json['totalValue']}");
      print("paymentMethod: ${json['paymentMethod']}");
      print("orderStatus: ${json['orderStatus']}");
      print("orderDate: ${json['orderDate']}");
      print("statusUpdatedAt: ${json['statusUpdatedAt']}");

      return OrderModel(
        orderNumber: json['orderNumber'],
        deliveryType: json['deliveryType'],
        assignedTable: json['assignedTable'],
        numberOfPeople: json['numberOfPeople'],
        clientId: json['clientId'],
        deliveryAddress: json['deliveryAddress'] ?? 'Indefinido',
        orderedProducts:
            (json['orderedProducts'] as List)
                .map((item) => OrderedProductModel.fromJson(item))
                .toList(),
        discountApplied: json['discountApplied'].toDouble(),
        totalValue: json['totalValue'].toDouble(),
        paymentMethod: json['paymentMethod'],
        orderStatus: json['orderStatus'],
        orderDate: DateTime.parse(json['orderDate']),
        statusUpdatedAt: DateTime.parse(json['statusUpdatedAt']),
      );
    } catch (e, stacktrace) {
      print('❌ Error en OrderModel.fromJson: $e');
      print(stacktrace);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'deliveryType': deliveryType,
      'assignedTable': assignedTable,
      'numberOfPeople': numberOfPeople,
      'clientId': clientId,
      'deliveryAddress': deliveryAddress,
      'orderedProducts':
          orderedProducts
              .map((product) => (product as OrderedProductModel).toJson())
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
