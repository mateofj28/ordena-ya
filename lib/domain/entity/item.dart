import 'package:ordena_ya/domain/entity/unit.dart';

class Item {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double subtotal;
  final String notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Unit> units;

  Item({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.units,
  });
}