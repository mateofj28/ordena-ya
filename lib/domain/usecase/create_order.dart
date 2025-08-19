// domain/usecases/create_order.dart
import '../entity/order.dart';
import '../repository/order_repository.dart';

class CreateOrder {
  final OrderRepository repository;

  CreateOrder(this.repository);

  Future<void> call(Order order) {
    return repository.createOrder(order);
  }
}
