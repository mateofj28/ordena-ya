

class OrderedProduct {
  final String? id; // opcional
  final String name;
  final double price;
  final int quantity;
  final double total;

  OrderedProduct(this.id, {
    required this.name,
    required this.price,
    required this.quantity,
  }) : total = price * quantity;

  
}
