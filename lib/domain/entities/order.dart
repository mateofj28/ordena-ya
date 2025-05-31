import 'package:ordena_ya/domain/entities/product.dart';

class Order {

  String? id;
  String orderNumber;
  String deliveryType;
  String? assignedTable; // nullable for delivery orders
  int numberOfPeople;
  String clientId;
  String deliveryAddress;
  List<Product> orderedProducts;
  double discountApplied;
  double totalValue;
  String paymentMethod;
  String orderStatus;
  DateTime orderDate;
  DateTime statusUpdatedAt;

  Order({
    this.id,
    required this.orderNumber,
    required this.deliveryType,
    this.assignedTable,
    required this.numberOfPeople,
    required this.clientId,
    required this.deliveryAddress,
    required this.orderedProducts,
    required this.discountApplied,
    required this.totalValue,
    required this.paymentMethod,
    required this.orderStatus,
    required this.orderDate,
    required this.statusUpdatedAt,
  });
}
