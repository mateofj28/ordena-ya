/*class Order {
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
}*/

class Order {
  final int? id;
  final int tenantId;
  final int tableId;
  final int waiterId;
  final String customerName;
  final String type; // ejemplo: dine_in, take_out
  final String? status; // ejemplo: pending, completed, cancelled
  final double subtotal;
  final double tax;
  final double total;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Order({
    this.id,
    required this.tenantId,
    required this.tableId,
    required this.waiterId,
    required this.customerName,
    required this.type,
    this.status,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Order('
        'id: $id, '
        'tenantId: $tenantId, '
        'tableId: $tableId, '
        'waiterId: $waiterId, '
        'customerName: $customerName, '
        'type: $type, '
        'status: $status, '
        'subtotal: $subtotal, '
        'tax: $tax, '
        'total: $total, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
