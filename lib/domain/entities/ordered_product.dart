const List<String> states = [
  'pendiente',
  'en preparación',
  'listo para entregar',
  'entregado',
];

class OrderedProduct {
  final String? id; // optional
  final String name;
  final double price;
  final int quantity;
  String state;
  final double total;

  OrderedProduct(
      this.id, {
        required this.name,
        required this.price,
        required this.quantity,
        this.state = 'pendiente',
      }) : total = price * quantity;

  @override
  String toString() {
    return 'OrderedProduct(name: $name, quantity: $quantity, price: $price, total: $total, state: $state)';
  }


  void advanceState() {
    final index = states.indexOf(state);
    if (index < states.length - 1) {
      state = states[index + 1];
    }
  }

  bool get isDelivered => state == 'entregado';
}
