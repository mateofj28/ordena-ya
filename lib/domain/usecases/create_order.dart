// domain/usecases/create_order.dart
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CreateOrder {
  final ClientRepository repository;

  CreateOrder(this.repository);

  Future<void> call(Order order) {
    return repository.createOrder(order);
  }
}
