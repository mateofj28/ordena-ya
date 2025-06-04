

class OrderedProduct {
  final String? id; // opcional
  final String name;
  final double unitPrice;
  final int quantity;
  final double total;

  OrderedProduct(this.id, {
    required this.name,
    required this.unitPrice,
    required this.quantity,
  }) : total = unitPrice * quantity;

  
}
