class CartItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String message;
  final String category;
  final String description;
  final List<String> unitStates; // Estados de cada unidad individual

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.message = '',
    this.category = 'general',
    this.description = '',
    this.unitStates = const [], // Por defecto vacío para nuevos items
  });

  CartItem copyWith({
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? message,
    String? category,
    String? description,
    List<String>? unitStates,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      message: message ?? this.message,
      category: category ?? this.category,
      description: description ?? this.description,
      unitStates: unitStates ?? this.unitStates,
    );
  }

  // Validar si se puede reducir cantidad o eliminar producto
  bool get canReduceOrRemove {
    // Solo permitir si TODAS las unidades están en estado "pendiente"
    // Si no hay estados definidos (nuevo item), permitir la acción
    if (unitStates.isEmpty) return true;
    return unitStates.every((state) => state.toLowerCase() == 'pendiente');
  }

  // Contar unidades pendientes
  int get pendingUnitsCount {
    if (unitStates.isEmpty) return quantity; // Si no hay estados, todas son "pendientes"
    return unitStates.where((state) => state.toLowerCase() == 'pendiente').length;
  }

  // Validar si se puede reducir cantidad (debe haber unidades pendientes disponibles)
  bool get canDecrease {
    if (quantity <= 1) return false;
    
    // Si no hay estados definidos, permitir (producto nuevo)
    if (unitStates.isEmpty) return true;
    
    // Debe haber al menos una unidad pendiente disponible
    // El backend maneja inteligentemente cuáles unidades eliminar
    return pendingUnitsCount > 0;
  }

  // Validar si se puede incrementar cantidad (siempre permitido)
  bool get canIncrease => true;

  double get totalPrice => price * quantity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.productId == productId;
  }

  @override
  int get hashCode => productId.hashCode;
}