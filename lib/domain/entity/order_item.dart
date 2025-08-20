class OrderItem {
  final int id;
  final int orderId;
  final String productName;
  final int quantity;
  final double price;
  final double? discount;
  final String notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.discount,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });


}
