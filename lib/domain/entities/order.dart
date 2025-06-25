import 'package:ordena_ya/domain/entities/ordered_product.dart';

class Order {
  String? id;
  String orderNumber;
  String deliveryType;
  String? assignedTable; // nullable for delivery orders
  int numberOfPeople;
  String clientId;
  String deliveryAddress;
  List<OrderedProduct> orderedProducts;
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

  Order copyWith({
    String? assignedTable,
    int? numberOfPeople,
    List<OrderedProduct>? orderedProducts,
    DateTime? statusUpdatedAt,
  }) {
    return Order(
      orderNumber: orderNumber,
      assignedTable: assignedTable ?? this.assignedTable,
      deliveryType: deliveryType,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      clientId: clientId,
      deliveryAddress: deliveryAddress,
      orderedProducts: orderedProducts ?? this.orderedProducts,
      discountApplied: discountApplied,
      totalValue: totalValue,
      paymentMethod: paymentMethod,
      orderStatus: orderStatus,
      orderDate: orderDate,
      statusUpdatedAt: statusUpdatedAt ?? this.statusUpdatedAt,
    );
  }

  @override
  String toString() {
    return 'Order('
      'id: $id, '
      'orderNumber: $orderNumber, '
      'deliveryType: $deliveryType, '
      'assignedTable: $assignedTable, '
      'numberOfPeople: $numberOfPeople, '
      'clientId: $clientId, '
      'deliveryAddress: $deliveryAddress, '
      'orderedProducts: $orderedProducts, ' // usa el toString() de cada OrderedProduct
      'discountApplied: $discountApplied, '
      'totalValue: $totalValue, '
      'paymentMethod: $paymentMethod, '
      'orderStatus: $orderStatus, '
      'orderDate: $orderDate, '
      'statusUpdatedAt: $statusUpdatedAt'
      ')';
  }
}
