// domain/repositories/order_repository.dart
import '../entities/order.dart';

abstract class OrderRepository {
  Future<void> createOrder(Order order);
  Future<List<Order>> getAllOrders();
}
