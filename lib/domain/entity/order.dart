class Order {
  final int? orderId; // "o109"
  final int tenantId; // "t1"
  final int tableId; // "m2"
  final int peopleCount; // 3
  final String consumptionType; // "mesa"
  final String? clientId; // null (nullable)
  final String? status; // "pending"
  final DateTime? createdAt; // "2025-10-04T07:21:42.851Z"
  final double? subtotal; // 0
  final double? tax; // 0
  final double? total;

  const Order({
    this.orderId,
    required this.tenantId,
    required this.tableId,
    required this.peopleCount,
    required this.consumptionType,
    this.clientId,
    this.status,
    this.createdAt,
    this.subtotal,
    this.tax,
    this.total,
  });

  @override
  String toString() {
    return 'Order('
      'orderId: $orderId, '
      'tenantId: $tenantId, '
      'tableId: $tableId, '
      'peopleCount: $peopleCount, '
      'consumptionType: $consumptionType, '
      'clientId: $clientId, '
      'status: $status, '
      'createdAt: $createdAt, '
      'subtotal: $subtotal, '
      'tax: $tax, '
      'total: $total'
      ')';
  }
}
