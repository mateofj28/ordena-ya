const List<String> states = [
  'pendiente',
  'en preparación',
  'listo para entregar',
  'entregado',
];

class OrderedProduct {
  final String? id;
  final String name;
  final double price;
  final List<OrderedProductUnit> units;
  final double total;

  OrderedProduct(
    this.id, {
    required this.name,
    required this.price,
    required this.units,
  }) : total = price * units.length;

  int get quantity => units.length;

  bool get isFullyDelivered => units.every((u) => u.isDelivered);

  @override
  String toString() {
    return 'OrderedProduct(name: $name, quantity: $quantity, total: $total, states: ${units.map((u) => u.state).toList()})';
  }
}

class OrderedProductUnit {
  String state;

  OrderedProductUnit({this.state = 'pendiente'});

  void advanceState() {
    final index = states.indexOf(state);
    if (index < states.length - 1) {
      state = states[index + 1];
    }
  }

  bool get isDelivered => state == 'entregado';
}
