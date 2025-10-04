import 'package:ordena_ya/domain/entity/product.dart';

class OrderItem {
  final String id;
  final String name;
  final double unitPrice;
  final int quantity;
  final String imageUrl;
  final String category;
  final String note;

  const OrderItem({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.imageUrl,
    required this.category,
    required this.note
  });

  factory OrderItem.fromProduct(Product product) {
    return OrderItem(
      id: product.id,
      name: product.name,
      unitPrice: product.unitPrice,
      quantity: product.quantity,
      imageUrl: product.imageUrl,
      category: product.category,
      note: product.notes
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': id,
      'name': name,
      'price': unitPrice,
      'category': category,
      'photo': imageUrl,
      'quantity': quantity,
      'notes': note,
    };
  }
}
