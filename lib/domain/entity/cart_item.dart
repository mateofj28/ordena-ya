class CartItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String message;
  final String category;
  final String description;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.message = '',
    this.category = 'general',
    this.description = '',
  });

  CartItem copyWith({
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? message,
    String? category,
    String? description,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      message: message ?? this.message,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  double get totalPrice => price * quantity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.productId == productId;
  }

  @override
  int get hashCode => productId.hashCode;
}