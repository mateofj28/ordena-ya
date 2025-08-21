class OrderItem {
  final int? id;
  final int? orderId;
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double? discount;
  final String notes;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderItem({
    this.id,
    this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.discount,
    required this.notes,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });


}
